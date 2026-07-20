#!/usr/bin/env ruby
# One-time script: adds the PacketTunnel NE target to Runner.xcodeproj.
# Idempotent — safe to re-run; exits if the target already exists.
# Kept in-repo so the setup is reproducible (see docs/ios.md).

require 'xcodeproj'

project_path = File.expand_path('../Runner.xcodeproj', __dir__)
project = Xcodeproj::Project.open(project_path)

if project.targets.any? { |t| t.name == 'PacketTunnel' }
  puts 'PacketTunnel target already exists — nothing to do'
  exit 0
end

runner = project.targets.find { |t| t.name == 'Runner' }
raise 'Runner target not found' unless runner

# --- Target -----------------------------------------------------------------
target = project.new_target(:app_extension, 'PacketTunnel', :ios, '15.0')

# --- Sources group + files --------------------------------------------------
group = project.main_group.new_group('PacketTunnel', 'PacketTunnel')
sources = %w[
  PacketTunnelProvider.swift
  ClashCore.swift
  SharedStateStore.swift
  EventBuffer.swift
  AppGroup.swift
]
sources.each do |name|
  file_ref = group.new_file(name)
  target.add_file_references([file_ref])
end
group.new_file('PacketTunnel-Bridging-Header.h')
group.new_file('Info.plist')
group.new_file('PacketTunnel.entitlements')

# AppGroup.swift is shared with the Runner target as well.
app_group_ref = group.files.find { |f| f.path == 'AppGroup.swift' }
runner.add_file_references([app_group_ref])

# --- Go core build phase (must precede compilation) -------------------------
script = target.new_shell_script_build_phase('Build Go Core')
script.shell_path = '/bin/bash'
script.shell_script = 'bash "${SRCROOT}/../plugins/setup/buildkit/build_pod.sh"'
script.always_out_of_date = '1'
target.build_phases.rotate!(target.build_phases.index(script))

# --- Link Libclash.xcframework + system frameworks --------------------------
frameworks_group = project.frameworks_group
xcframework_ref = frameworks_group.new_file('../libclash/ios/Libclash.xcframework')
target.frameworks_build_phase.add_file_reference(xcframework_ref)

ne_ref = frameworks_group.new_file('System/Library/Frameworks/NetworkExtension.framework')
ne_ref.source_tree = 'SDKROOT'
target.frameworks_build_phase.add_file_reference(ne_ref)

resolv_ref = frameworks_group.new_file('usr/lib/libresolv.tbd')
resolv_ref.source_tree = 'SDKROOT'
target.frameworks_build_phase.add_file_reference(resolv_ref)

# --- Build settings ---------------------------------------------------------
target.build_configurations.each do |config|
  bs = config.build_settings
  bs['PRODUCT_NAME'] = '$(TARGET_NAME)'
  bs['PRODUCT_BUNDLE_IDENTIFIER'] = 'uk.toworld.flclash.PacketTunnel'
  bs['INFOPLIST_FILE'] = 'PacketTunnel/Info.plist'
  bs['CODE_SIGN_ENTITLEMENTS'] = 'PacketTunnel/PacketTunnel.entitlements'
  bs['SWIFT_VERSION'] = '5.0'
  bs['SWIFT_OBJC_BRIDGING_HEADER'] = 'PacketTunnel/PacketTunnel-Bridging-Header.h'
  bs['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
  bs['TARGETED_DEVICE_FAMILY'] = '1,2'
  bs['LD_RUNPATH_SEARCH_PATHS'] = ['$(inherited)', '@executable_path/Frameworks', '@executable_path/../../Frameworks']
  bs['CURRENT_PROJECT_VERSION'] = '$(FLUTTER_BUILD_NUMBER)'
  bs['MARKETING_VERSION'] = '$(FLUTTER_BUILD_NAME)'
  bs['SKIP_INSTALL'] = 'YES'
  bs['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
  bs['OTHER_LDFLAGS'] = ['$(inherited)', '-ObjC']
  bs['ENABLE_BITCODE'] = 'NO'
  # Flutter's Generated.xcconfig provides FLUTTER_BUILD_NAME/NUMBER.
  config.base_configuration_reference =
    project.files.find { |f| f.path == 'Flutter/Generated.xcconfig' }
end

# --- Runner: entitlements + embed the extension -----------------------------
runner.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
end

runner_entitlements = project.main_group['Runner'].new_file('Runner.entitlements')
_ = runner_entitlements

embed_phase = runner.new_copy_files_build_phase('Embed Foundation Extensions')
embed_phase.dst_subfolder_spec = Xcodeproj::Constants::COPY_FILES_BUILD_PHASE_DESTINATIONS[:plug_ins]
build_file = embed_phase.add_file_reference(target.product_reference)
build_file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }

# Must run before Flutter's "Thin Binary" script phase, which reads the whole
# app bundle — leaving the embed after it creates a build-graph cycle.
thin = runner.build_phases.find do |p|
  p.respond_to?(:display_name) && p.display_name.include?('Thin Binary')
end
runner.build_phases.move(embed_phase, runner.build_phases.index(thin)) if thin

runner.add_dependency(target)

project.save
puts "PacketTunnel target added to #{project_path}"
