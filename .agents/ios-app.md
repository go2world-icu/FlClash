# iOS 应用侧

上游没有 iOS，这一层全是 fork 的。构建与发布见 [release-ios.md](release-ios.md)，合上游要重做的移植见
[merge-upstream.md](merge-upstream.md)；这里记的是**应用内**几个容易踩、且症状离成因很远的地方。

## 服务通道必须回字节，不能回 String

`lib/plugins/service.dart` 按字节读 `com.follow.clash/**core**` 的回复——和 Android 插件一致：

```dart
await methodChannel.invokeMethod<Uint8List>('invokeMethod', json.encode(call));
```

**Swift 侧于是必须 `result(FlutterStandardTypedData(bytes:))`。** 回 Swift `String` 时这个 cast 抛
`type 'String' is not a subtype of type 'Uint8List?'`，**每一次进 core 的调用都失败**：`getProxies`（节点列表）、
`getIsInit`、事件泵全灭。

这个故障极难认：表现是**隧道、NE、core 全部正常，但节点列表空、代理不生效**，因为核心其实跑得好好的，坏的是
「把数据取回来」这一跳。同一个通道上由 NE 自己回答的方法（`ping`、`getCoreState`）**照样正常**，更容易把人引偏。

要确认这类跨语言类型问题，别猜机制——写一个一次性 widget test，用 `setMockMethodCallHandler` 让通道回一个
String，再看 `invokeMethod<Uint8List>` 的反应，一分钟拿到铁证。

## Dart 的 iOS 专属接入

`lib/plugins/ios_service.dart` 持有 iOS 专属方法、`IosCoreState` 和 `IosServiceListener`。
通用 `Service` 只注册一次入站处理器，把平台扩展消息转给 `dispatchIosServiceCall`；iOS 调用方显式导入
专属文件以使用 extension。不能在专属适配器再次注册同名通道的处理器，否则会覆盖 Core 事件接收。
隧道诊断继续由 NE 自答，Core 的回复仍遵守下文的字节约定。

## core 有自己的通道：`com.follow.clash/core`

上游 `2201c199`（v0.9.1）把 core 调用从 `service` 通道拆到 `core` 通道，Kotlin 侧在 `ServicePlugin` 里注册。
iOS 侧原来只注册了 `.../service`，于是**每次进 core 的调用都抛 `MissingPluginException(No implementation found
for method invokeMethod on channel com.follow.clash/core)`**——加订阅、拉节点列表、`getIsInit` 全灭。而 `ping`
（NE 自答）和 `getCoreState`（NE 自答）继续正常，三颗点里「通道」「内核」看起来都没事，只有「隧道」之外的诊断点
跟着撒谎，症状再次离成因很远。

`ServiceChannel` 现在在同一个 object 上挂了两个 `FlutterMethodChannel`（`name` 与 `coreName`）；Dart 侧走哪个由
`Service._coreChannel` 决定，iOS 两个都得答。改动只在 `ios/Runner/Channels/ServiceChannel.swift`——Swift 文件
上游不存在，合并永远不会冲突，但反过来也没有任何东西提醒你上游又加了通道：
`test/lint/fork_invariants_test.dart` 的 "the channels the shared Dart code opens" 会拿 Dart 侧打开的通道名
去 Swift 侧找对应注册，找不到就红。

## 导航栏那三颗点（`lib/xboard/features/ios_shell/ios_core_status.dart`）

| 点 | 探针 | 经过 core 吗 |
|---|---|---|
| 隧道 | `isStartProvider`（乐观：拨开关即亮） | 否 |
| 通道 | `ping` —— NE 自己回答 | **否** |
| 内核 | `getCoreState` —— NE 自述 `coreBooted` / `tunStarted` / `quickSetup` 的错误 | **否** |

三颗点**刻意全部不经过 core**：「core 没起来」和「调用没回来」是两类问题，只有绕开 core 才分得开。内核点不用
`getIsInit` 正是因为它分不出这两者——两者都是「没答案」。长按有点的 Tooltip 带细节。

iOS 现在和安卓共用同一个外壳和仪表盘，这三颗点挂在**仪表盘标题栏**（`xboard_dashboard_view.dart` 的 `actions`），
`compact: true`：只画点不画标签，标签并进 Tooltip——标题栏还要放标题和页面自己的动作，带标签的版本在 412pt 宽
的屏幕上会溢出。`ios_shell/` 整个目录是停用（注释掉引用，未删除）状态，恢复外壳时把 `compact` 去掉即可。

## 配置：交给 core 的是订阅原文

`core/config_ios.go` 的 `parseConfigPathFiltered` 曾经无条件裁掉 `GEOSITE` / `IP-ASN` / `SRC-GEOIP` 规则和 DNS
`geosite` 项（注释说怕撑爆 NE 的 50MB）。前提已经不成立：

- 四个库都**打包**在 `assets/data/`（`GEOSITE.dat` 4.4MB 等），`CoreController.initGeo()` 在**应用启动时**把它们
  写进 homeDir——iOS 上 homeDir 是 **App Group，NE 共享同一个**；mihomo 的 `Path.GeoSite()` 大小写不敏感匹配。
- mihomo 的 `geodata-loader` 默认就是 **`memconservative`**，成本约等于文件大小，不是解析后的结构。

所以现在**只在对应的库真的缺失时才裁**，并打 Warn。保留裁剪是为了那种情况：库缺失会让 mihomo 去下载，下不动就
**整份配置失败**——表现为「隧道连上了但什么都没」。

## 与桌面仍不同的地方（平台固有，不是裁剪）

| 项 | iOS | 原因 |
|---|---|---|
| TUN 栈 | 强制 `gvisor`（`VpnOptions`），并 `applyPlatformTunOptions` 打开 `RecvMsgX`/`SendMsgX` | iOS 没有 iptables，系统栈不可用 |
| 重载时重建 TUN | `recreateTunOnReload = false` | utun 由 NE 持有，重建会跟系统抢接口 |
| 系统 DNS 补丁 | `handleUpdateDns` 空实现 | 系统 DNS 由 `NEDNSSettings` 管 |
| 隧道休眠 | `Suspend`（NE 的 sleep/wake 调用） | NE 随设备冻结 |

## 面板导入订阅：隧道没开时不能问 core 要校验

面板（`lib/xboard/`）在**存配置之前**要 core 校验一遍。iOS 上 core 只活在 PacketTunnel 里，
隧道没开时 `ServiceChannel` 直接回 `nil`；上游 v0.9.1 起这个 `nil` 被抛成
`CoreMethodException('Core did not answer validateConfig')`，于是「登录后自动导入订阅」「手动加订阅」
全部失败。`login()` 不 await 这次导入、catch 里只写日志，用户看到的是**「无可用套餐」**——
离成因很远。（v0.8.96 看似正常，是因为当时 `nil` 被 `?? ''` 读成「配置没问题」，校验根本没做。）

修法在 `lib/xboard/utils/xboard_core_validation.dart`，只碰面板自己的调用点：

- 先用 `ping` + `getCoreState`（**扩展自答，不经过 core**）探 core 可达性；
- 可达 → 将校验输入暂存到 `appPath.homeDirPath/.validation/` 下每次独立的目录，再交给 core；
  Runner 的 `Library/Caches` 临时文件对 PacketTunnel 不可见，直接传路径会导致「代理关闭能导入、打开就失败」。
  文件和字符串校验都必须走此共享路径；完成或抛错均删除临时目录。age 解密成功后还要把结果复制回调用方的文件；
- 不可达 → 跳过 core 校验、**先把配置存下来**，用本地结构校验兜底（YAML 映射、有
  `proxies` 或 `proxy-providers`），把权威校验推迟到隧道起来时——连接时 `applyProfile`
  仍会把同一份配置交给 core，起不来会以 core 的错误呈现。
- 带 age 密钥时一律走 core：解密只有 core 做得了。

普通配置刷新（仪表盘配置卡、配置详情和自动更新）及文件导入仍由上游的
`ProfilesAction` / `Profile.saveFile` 调用 `validateProfile`。它们的 `appPath.tempFilePath`
通过 `lib/common/data_dir.dart` 的 `forkTempDir` 在 iOS 解析到 App Group 的
`Library/Caches/<appName>`，以便 PacketTunnel 读取临时文件；其他平台继续使用系统临时目录。
不能只为 XBoard 导入暂存共享副本，否则普通配置刷新仍会把 Runner 缓存路径传给扩展并报
`operation not permitted`。没有 App Group 的未签名环境保留系统临时目录回退。
普通上游路径在隧道没开时仍要求 core 校验；本地结构校验降级只属于面板导入。

普通配置刷新通过 `Request.getFileResponseForUrl` 的 `downloadXBoardProfile` 接缝识别 iOS 面板订阅：
当前账户缓存的 `subscribeUrl` 要精确匹配；配置订阅源按 scheme/host/port 匹配。不能只认配置源域名，
账户返回的原始订阅 URL 可能属于另一个域名。匹配后复用 `SubscriptionDownloader.fetchSubscription` 的
原 URL + 配置 SOCKS5 代理竞速，不改写路径或 token，不创建 Profile、不更新 provider 状态。
响应原字节和订阅头仍交给上游保存流程；其他下载沿用原逻辑。普通刷新保留 20 秒总预算，
面板导入保留 30 秒及竞速内的配置校验，取消和超时均关闭客户端。

## 配置重载未回复与隧道断开

`Core did not answer setupConfig` 表示服务没有返回回复，不能直接当作 YAML 校验错误或内存不足。
Swift 通道在 VPN 会话不再可用、发送失败或 NE 回复为空时返回 nil；普通配置错误有独立的错误响应。
`ne_stderr.log` 每次启动会覆盖，排查必须看故障同一轮的日志和对应设备终止报告。
`setupConfig begin/answered` 日志只记录扩展是否收到/回复及可用内存，不记录配置或订阅凭据。

`loadConfigWithBase` 已解析配置之后，iOS 的 `loadConfigForPlatformLimits` 在 geodata 齐全时直接复用结果，
避免再次构建整份配置；缺库时仍保留原过滤路径。这个优化减少重载分配，不能证明所有偶发断开都由内存导致。
TUN 仍由 PacketTunnel 持有，重载不重新创建。

## App 通道的 Android-only 方法

`ios/Runner/Channels/AppChannel.swift` 对 Android 独有的概念返回**无害默认值**，让共享 Dart 代码继续工作。新增
Dart 侧调用时记得在这里补一个 case——否则 iOS 抛 `MissingPluginException`；Dart 侧那层有 try 的（如
`didCrashOnPreviousExecution`）会静默降级，没有 try 的会直接炸。

## 远程配置请求与账户初始化

SDK 配置源自行创建 Dio / HttpClient，不读取面板 API 的 HttpConfig。初始化先通过
`XBoardTransport.ensureDirectRoute` 解析配置源域名并登记 iOS 排除路由，随后交给 SDK 按原 URL、
配置的 TypeA / TypeD 鉴权和正常 HTTPS 流程请求。不要通过 HttpOverrides 强制配置请求连接物理 DNS
返回的首个 IP：该结果可能来自其他可用接口，也会绕过系统地址选择与失败回退。
初始化检查合并并发调用，失败即结束当次操作；刷新等待已有操作完成，后续显式重试才启动新操作。
账户页继续等待 SDK 就绪，失败时显示原因与重试入口。相关回归在 `test/xboard/providers/`、
`test/xboard/config/` 和 `test/xboard/infrastructure/board_transport_test.dart`。
