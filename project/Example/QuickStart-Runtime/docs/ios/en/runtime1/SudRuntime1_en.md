# iOS Project Integration with SudGIP SDK

Description: SudGIP SDK includes the game runtime module. Follow these brief steps to integrate the SDK and use the game runtime to load and run games in your project.

## 1. Adding SDK Dependency to Project via CocoaPods

Using `Xcode 16.4` and target project `QuickStart-Runtime` as an example:

### 1.1 Adding SDK to the Project

```ruby
pod 'SudGIP', :path => '../../'
```

Navigate to the directory containing your project's Podfile in macOS Terminal and execute: `pod install`. After successful execution, the `QuickStart-Runtime.xcworkspace` file will be generated. Open this file.

## 2. Manual Project Configuration

### 2.1 Adding SDK to the Project

Using `Xcode 16.4` and target project `QuickStart-Runtime` as an example:

- Copy `SudGIP.xcframework` to the `QuickStart-Runtime` project directory.
- Open `Xcode`, select `QuickStart-Runtime` under `TARGETS`, then choose `Build Phases`.
- Drag `SudGIP.xcframework` into `Link Binary With Libraries`.
- Select `General`, and under `Frameworks, Libraries, and Embedded Content`, set `SudGIP.xcframework` to `Embed & Sign`.

### 2.2 Environment Configuration

- In `TARGETS` -> `Build Settings` (select ALL view) -> `Other Linker Flags`, add `-ObjC` (note capital O and C, do not omit the "-" symbol).
- In `TARGETS` -> `Build Settings` (select ALL view) -> `Enable Bitcode`, set it to `NO`.

### 2.3 Importing SDK Header Files

```objc
#import <SudGIP/SudGIP-umbrella.h>
```

## 3. Game Runtime Module Interfaces in SDK

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

## 4. Key Steps for Using Game Runtime

Refer to the sample code in the `QuickStart-Runtime` project included in the compressed package.

### 4.1 Initialize the SDK and Obtain Runtime Usage Authorization After Initialization

```objc
/// Initialize the SDK
/// - Parameter paramModel: Required parameters
/// - Parameter completion: completion description
+(void)initSDK:(SudRtInitSDKParamModel *)paramModel
    completion:(nullable void(^)(NSError *_Nullable error))completion;
```

### 4.2 Load the Game

Load the game package by calling the following interface and create the corresponding game operation handle.

```objc
/// Load game
/// @param paramModel Load parameters
/// @param progress Progress callback
/// @param completion Completion callback
+(void)loadGame:(SudRt1LoadGameParamModel *)paramModel
       progress:(nullable void(^)(NSInteger progress))progress
     completion:(nullable void(^)(id<ISudRt1GameHandle> _Nullable gameHandle, NSError *_Nullable error))completion;
```

### 4.3 Runtime Management

After loading the game package, you can use the instance returned by the runtime. For detailed information about the ISudRt1GameHandle module, please refer to [ISudRt1GameHandle Interface Documentation](SudRt1GameHandle_en.md).

## 5. Demo Example:

Refer to the ViewController in the quickstart-runtime project under Example, which demonstrates the game loading steps.
