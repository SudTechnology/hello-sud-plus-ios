# SudNFT快速接入
- 申请秘钥集成SDK
  <details>
  <summary>详细描述</summary>

      1.appId、appKey和isTestEnv=true，请使用QuickStart客户端的；
      2.iOS bundleId、Android applicationId，请使用APP客户端自己的；(接入信息表中的bundleId/applicationId)；
      3.完成集成，Demo跑起来;

  </details>
# 功能介绍
1. 支持海外以太坊主链主流钱包Metamask、TrustWallet、Rainbow等钱包端来授权绑定钱包地址
2. 可以选择各种正式链、测试链、侧链获取对应链NFT列表数据、NFT详情数据
3. 可以生成NFT的使用token，用于应用端唯一使用NFT的使用凭证
4. 支持国内（稀物）平台授权绑定、藏品数据列表、详情数据获取及使用
# 相关接口描述
- 初始化SDK
```
/// 初始化, 必须初始化后使用
/// @param paramModel 参数model
/// @param listener 结果回调
+ (void)initNFT:(SudInitNFTParamModel *)paramModel listener:(ISudNFTListenerInitNFT _Nullable)listener;
```
- 获取支持的钱包列表
```
/// 获取支持钱包列表
/// @param listener 返回支持钱包列表数据
+ (void)getWalletList:(ISudNFTListenerGetWalletList _Nullable)listener;
```
## 海外以太坊链钱包相关接口
- 绑定钱包
```
/// 绑定钱包
/// @param paramModel 参数model
/// @param listener 结果回调
+ (void)bindWallet:(SudNFTBindWalletParamModel *)paramModel listener:(id <ISudNFTListenerBindWallet>)listener;
```
- 获取NFT列表
```
/// 获取NFT列表,必须授权成功之后才能获取NFT列表
/// @param paramModel 参数model
/// @param listener 回调
+ (void)getNFTList:(SudNFTGetNFTListParamModel *)paramModel listener:(ISudNFTListenerGetNFTList _Nullable)listener;
```
- 生成元数据使用唯一认证token
```
/// 生成元数据使用唯一认证token
/// @param paramModel 参数model
/// @param listener 回调
+ (void)genNFTCredentialsToken:(SudNFTCredentialsTokenParamModel *)paramModel listener:(ISudNFTListenerGenNFTCredentialsToken)listener;
```


## 国内藏品平台相关接口（稀物）
- 发送短信验证码
```
/// 发送短信验证码
/// @param paramModel 参数model
/// @param listener 回调
+ (void)sendSmsCode:(SudNFTSendSmsCodeParamModel *)paramModel listener:(ISudNFTListenerSendSmsCode)listener;
```
- 绑定藏品账户
```
/// 绑定国内藏品账户
/// @param paramModel 参数model
/// @param listener 回调
+ (void)bindCnWallet:(SudNFTBindCnWalletParamModel *)paramModel listener:(ISudNFTListenerBindCnWallet)listener;
```
- 获取藏品列表
```
/// 获取国内NFT列表
/// @param paramModel 参数model
/// @param listener 回调
+ (void)getCnNFTList:(SudNFTGetCnNFTListParamModel *)paramModel listener:(ISudNFTListenerGetCnNFTList)listener;
```
- 生成藏品使用唯一认证token
```
/// 生成国内NFT使用唯一认证token
/// @param paramModel 参数model
/// @param listener 回调
+ (void)genCnNFTCredentialsToken:(SudNFTCnCredentialsTokenParamModel *)paramModel listener:(ISudNFTListenerCnGenNFTCredentialsToken)listener;
```
- 解绑绑定平台
```
/// 解绑用户
/// @param paramModel 参数
/// @param listener 回调
+ (void)unbindCnWallet:(SudNFTUnBindCnWalletParamModel *)paramModel listener:(ISudNFTListenerUnBindCnWallet)listener;
```

# 接入文档

- [接入文档](https://docs.sud.tech/zh-CN/)
