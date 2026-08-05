# App Store / TestFlight 发布与审核

ToWorld 的 Apple 侧发布流程：构建/签名见 [release-ios.md](release-ios.md)，这篇是**上传之后**的测试、审核、上架流程与合规注意事项。

## 1. TestFlight 测试

构建上传后（处理完状态从 Processing → Ready to Test）才能开始。

| 类型 | 人数 | 审核 | 说明 |
|------|------|------|------|
| **Internal（内部）** | ≤100 | 无 | 测试人员用 Apple ID，先接受邀请。适合自测/核心团队 |
| **External（外部）** | ≤10000 | 需 Beta App Review | 可公开链接，1-2 天审核 |

### Internal 操作
App Store Connect → TestFlight → **App Store Connect Users**（+ 加测试人员 Apple ID 邮箱，对方接受邀请）→ **Internal Testing**（建/选组）→ 把构建分配给组。测试人员在 iPhone 装 **TestFlight App** 登录后即可安装。

### External 提交审核
App Store Connect → TestFlight → **External Testing** → 选中构建 → **Submit for Beta Review**，填写：
- Description / What to Test、What's New
- Contact Info
- **Review Notes**：App 需登录 → **必须给审核员演示账号**（见下模板）
- Export Compliance：标准 HTTPS/TLS → 选 **exemption（豁免）**

### 开发者名称显示
TestFlight 与 App Store 显示的开发者名 = **Apple 开发者账号注册时的法定名称**（个人账号 = 实名，无法更改；组织账号 = 执照/公司注册名）。外部测试会把这个名称暴露给最多 1 万人。

## 2. App Store 发布

### 前置清单
- 元数据：名称、副标题、描述、关键词、**隐私政策 URL（必填）**、Support URL、截图（6.9" + 6.5" 各 ≥1 张）
- 年龄分级（内容评级问卷）、定价（免费，收入在官网）
- **App Privacy（隐私标签）**：如实声明收集的数据（账号、邮箱、设备信息等）
- **App Review Information**：联系信息 + **演示账号** + Notes
- 加密合规：`ITSAppUsesNonExemptEncryption=false` 已写入 Info.plist（HTTPS-only）；代理类 App 审核可能追问加密用途
- Sign in with Apple：仅自建邮箱/密码登录 → 不需要；若还接 Google/微信等第三方登录 → **必须**同时提供 Sign in with Apple（Guideline 4.8）

### 审核备注模板（App Review Notes）

英文版（推荐）：

```
App description:
ToWorld is a network proxy client. Users must log in with their account to use the
service. Accounts and paid plans are managed on our website; the app itself contains
no in-app purchase functionality.

Sign-in information (demo account with an active plan):
Email: demo@example.com
Password: Demo123456

Notes for the reviewer:
1. Subscriptions/plans are purchased on our official website
   (https://example.com), not through in-app purchase. The app has no purchase UI.
2. If the demo account is rate-limited or expired, please contact
   support@example.com and we will provide a fresh account promptly.
3. All network traffic is carried over standard HTTPS/TLS. No non-exempt
   encryption is used.
4. The app requires network access to function; please allow it when prompted.
```

中文版参考：内容同上，`demo@example.com` / `Demo123456` / `support@example.com` 均替换为真实值。

> ⚠️ 演示账号**必须已开通套餐**，审核员要能真正连接体验完整功能，否则以"功能不完整"拒绝。

### 隐私政策要点

App Store 必须有隐私政策 URL。模板占位：

- 收集：账号信息（邮箱/用户名）、设备信息、服务使用元数据（登录/登出、所选节点、连接时长）；**不**记录代理传输的具体内容/访问网站
- 用途：提供服务、安全防护、故障排查、通知
- 支付：在官网完成，App 内不处理支付、不存储支付凭据
- 共享：不售卖；仅法律法规/监管要求时共享
- 存储与安全：存储地区、日志保留期限
- 用户权利：可修改/删除/注销账号
- 联系方式：privacy@example.com / support@example.com

隐私标签（App Privacy）须与政策一致，如实填写。

## 3. 网站购买套餐（App 内无 IAP）的影响

- 苹果 Guideline 3.1.1：App 内消费的数字内容/服务须用 IAP（苹果抽 30%），不能用外部支付。
- 代理/VPN 套餐属**灰色地带**：可能被认定"App 内功能解锁"要求接 IAP，也可能按"真实网络服务/Reader App 例外"放行。
- 实务：App 内**不放任何购买入口、不放引导外部支付的文案**；审核 Notes 说明"购买在官网、App 仅登录使用"；给演示账号完整权限。多数代理类 App 这样能过，但要有被要求接 IAP 的预案。
- 中国区 App Store 禁代理/VPN 类 App（需网络经营许可），**只能海外区发布**。

## 4. 开发者账号

- 个人账号：显示名 = 法定实名，**无法改为品牌名**；要品牌名须升级**组织账号**。
- 组织账号：个体工商户可申请（有营业执照 + 统一社会信用代码 + D-U-N-S 编码），显示名 = **执照注册名称**（非品牌名），可申请 DBA；审核可能要求有限公司。
- 建议从现有个人账号**升级**而非新建（避免 App 迁移）。
