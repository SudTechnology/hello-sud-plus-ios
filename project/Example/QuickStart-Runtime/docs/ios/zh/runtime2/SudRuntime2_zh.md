# iOS 项目集成 SudGIP SDK

说明：SudGIP SDK 包含游戏运行时模块，通过以下简要步骤即可集成 SDK 并在项目中使用游戏运行时进行加载运行游戏。

## 一、pod 依赖引入 SDK 到工程

以 `Xcode 16.4`，目标工程 `QuickStart-Runtime` 为例：

### 1. 在工程中引入 SDK

```ruby
pod 'SudGIP', :path => '../../'

```

在 mac 终端中进入到工程 Podfile 所在目录并执行：pod install，命令执行成功后，会生成 `QuickStart-Runtime.xcworkspace` 文件，打开该文件。

## 二、手动配置工程

### 1. 在工程中引入 SDK

以 `Xcode 16.4`，目标工程 `QuickStart-Runtime` 为例：

- 将 `SudGIP.xcframework` 拷贝到 `QuickStart-Runtime` 工程中。
- 打开 `Xcode`，在 `TARGETS` 中，选中 `QuickStart-Runtime`，选择 `Build Phases`。
- 将 `SudGIP.xcframework` 拖到 `Link Binary With Libraries`。
- 选择 `General`，在 `Frameworks, Libraries, and Embedded Content` 中，将 `SudGIP.xcframework` 设置为 `Embed & Sign`。

### 2. 环境配置

- 在 `TARGETS` -> `Build Settings`（选中 ALL 视图） -> `Other Linker Flags` 中，添加 `-ObjC`，字母 O 和 C 大写，符号“-”请勿忽略。
- 在 `TARGETS` -> `Build Settings`（选中 ALL 视图） -> `Enable Bitcode` 中，将其设置为 `NO`。

### 3. 引入 SDK 头文件

```objc
#import <SudGIP/SudGIP-umbrella.h>
```

## 二、SDK 中游戏运行时模块接口

```objc
/// Game SudRuntime2
@interface SudRuntime2 : NSObject

/// Initialize the SDK
/// - Parameter paramModel: Required parameters
/// - Parameter completion: completion description
+(void)initSDK:(SudRtInitSDKParamModel *)paramModel
    completion:(nullable void(^)(NSError *_Nullable error))completion;

/// Reset the initialized SDK, called when SDK re-initialization is needed
+(void)uninitSDK;

/// Create a runtime instance (single process has only one)
/// @param options Optional configuration parameters for the runtime
/// @param completion Completion callback
+(void)createRuntime:(NSDictionary *_Nullable)options
          completion:(nullable void(^)(id<SudRt2GameRuntime> _Nullable runtime, NSError *_Nullable error))completion;

/// Load game package
/// @param paramModel Load parameters
/// @param progress Progress callback
/// @param completion Completion callback
+(void)loadPackage:(SudRt2LoadPackageParamModel *)paramModel
       progress:(nullable void(^)(NSInteger progress))progress
     completion:(nullable void(^)(NSError *_Nullable error))completion;

@end
```

## 二、游戏运行时使用关键步骤

示例代码请查看压缩包中的 `QuickStart-Runtime` 工程。

### 1. 初始化 SDK，完成初始化后获取运行时使用授权

```objc
/// Initialize the SDK
/// - Parameter paramModel: Required parameters
/// - Parameter completion: completion description
+(void)initSDK:(SudRtInitSDKParamModel *)paramModel
    completion:(nullable void(^)(NSError *_Nullable error))completion;
```

### 2. 创建运行时环境

调用一下接口创建一个运行时环境实例，单进程只有一个。

```objc
/// Create a runtime instance (single process has only one)
/// @param options Optional configuration parameters for the runtime
/// @param completion Completion callback
+(void)createRuntime:(NSDictionary *_Nullable)options
          completion:(nullable void(^)(id<SudRt2GameRuntime> _Nullable runtime, NSError *_Nullable error))completion;
```

### 3. 游戏包管理

通过调用以下接口加载游戏包，会进行游戏包及其必要插件依赖下载安装。成功之后，游戏包会自动缓存，下次加载时，会优先从缓存中加载。

```objc
/// Load game package
/// @param paramModel Load parameters
/// @param progress Progress callback
/// @param completion Completion callback
+(void)loadPackage:(SudRt2LoadPackageParamModel *)paramModel
       progress:(nullable void(^)(NSInteger progress))progress
     completion:(nullable void(^)(NSError *_Nullable error))completion;
```

### 4. 运行时管理

加载完游戏包后，可以通过创建运行时返回的实例 [SudRt2GameRuntime 接口说明](SudRt2GameRuntime_zh.md) 来进行创建游戏实例。并管理游戏实例生命周期，
详细 SudRt2GameHandle 模块请查看 [SudRt2GameHandle 接口说明](SudRt2GameHandle_zh.md)

## demo 示例：

详情参考 Example 中 quickstart-runtime 工程 ViewController 中展示游戏加载步骤

## SDK 调用流程图:

![](media/sdk-flow.png)
