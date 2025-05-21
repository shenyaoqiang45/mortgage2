# iOS 内测方案总结

## 1. TestFlight 内测流程

1. **准备工作**
   - 注册 Apple Developer 账号，并加入开发者计划
   - 完成 Xcode 和 Flutter 环境配置

2. **打包应用**
   - 在项目根目录运行：  
     `flutter build ipa`
   - 用 Xcode 打开 `ios/Runner.xcworkspace`
   - 选择 `Product > Archive` 进行归档

3. **上传至 TestFlight**
   - 归档完成后，点击 `Distribute App`
   - 选择 App Store Connect > Upload
   - 按提示上传应用

4. **TestFlight 配置**
   - 登录 [App Store Connect](https://appstoreconnect.apple.com/)
   - 在“我的 App”中找到应用，进入 TestFlight 页面
   - 添加内测人员邮箱，发送邀请

5. **用户体验内测**
   - 用户收到邀请邮件，安装 TestFlight
   - 通过 TestFlight 安装并测试应用

## 2. 注意事项

- 每个版本最多可邀请 10,000 名测试者
- 内测版本有效期为 90 天
- 提交新版本需重新审核（通常较快）

## 3. 其他内测方式

- 企业签名分发（需企业开发者账号）
- Ad Hoc 分发（最多 100 台设备，需手动添加 UDID）