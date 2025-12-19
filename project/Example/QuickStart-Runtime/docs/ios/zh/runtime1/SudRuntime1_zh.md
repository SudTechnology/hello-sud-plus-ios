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
/// Game Runtime1
@interface SudRuntime1 : NSObject

/// Initialize the SDK
/// - Parameter paramModel: Required parameters
+(void)initSDK:(SudRtInitSDKParamModel *)paramModel
    completion:(nullable void(^)(NSError *_Nullable error))completion;

/// Reset the initialized SDK, called when SDK re-initialization is needed
+(void)uninitSDK;

/// Load game
/// @param paramModel Load parameters
/// @param progress Progress callback
/// @param completion Completion callback
+(void)loadGame:(SudRt1LoadGameParamModel *)paramModel
       progress:(nullable void(^)(NSInteger progress))progress
     completion:(nullable void(^)(id<ISudRt1GameHandle> _Nullable gameHandle, NSError *_Nullable error))completion;

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

### 2. 加载游戏

通过调用以下接口加载游戏包，并创建游戏对应操作 handle。

```objc
/// Load game
/// @param paramModel Load parameters
/// @param progress Progress callback
/// @param completion Completion callback
+(void)loadGame:(SudRt1LoadGameParamModel *)paramModel
       progress:(nullable void(^)(NSInteger progress))progress
     completion:(nullable void(^)(id<ISudRt1GameHandle> _Nullable gameHandle, NSError *_Nullable error))completion;
```

### 4. 运行时管理

加载完游戏包后，可以通过创建运行时返回的实例 详细 ISudRt1GameHandle 模块请查看 [ISudRt1GameHandle 接口说明](SudRt1GameHandle_zh.md)

## demo 示例：

详情参考 Example 中 quickstart-runtime 工程 ViewController 中展示游戏加载步骤
