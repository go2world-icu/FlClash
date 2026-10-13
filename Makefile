SHELL := /bin/bash

.PHONY: help submodules

help:
	@echo 'make submodules                   # update git submodules (Clash.Meta core sources)'
	@echo ''
	@echo 'The Go core and the Rust helper are built by the setup build hook during'
	@echo 'flutter build (and dart setup.dart); there is no separate make target.'
	@echo 'See .agents/commands.md.'

submodules:
	git submodule update --init --recursive
