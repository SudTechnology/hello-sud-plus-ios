//
//  Version: 2.15.0.5948_stable_audio
//
//  ZegoExpressEngine.h
//  ZegoExpressEngine
//
//  Copyright © 2019 Zego. All rights reserved.
//

#import "ZegoExpressEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoExpressEngine : NSObject

/// Create ZegoExpressEngine singleton object and initialize SDK.
///
/// Available since: 2.14.0
/// Description: Create ZegoExpressEngine singleton object and initialize SDK.
/// When to call: The engine needs to be created before calling other functions.
/// Restrictions: None.
/// Caution: The SDK only supports the creation of one instance of ZegoExpressEngine. Multiple calls to this function return the same object.
///
/// @param profile The basic configuration information is used to create the engine.
/// @param eventHandler Event notification callback. [nil] means not receiving any callback notifications.It can also be managed later via [setEventHandler]. If [createEngine] is called repeatedly and the [destroyEngine] function is not called to destroy the engine before the second call, the eventHandler will not be updated.
/// @return engine singleton instance.
+ (ZegoExpressEngine *)createEngineWithProfile:(ZegoEngineProfile *)profile eventHandler:(nullable id<ZegoEventHandler>)eventHandler;

/// Destroy the ZegoExpressEngine singleton object and deinitialize the SDK.
///
/// Available since: 1.1.0
/// Description: Destroy the ZegoExpressEngine singleton object and deinitialize the SDK.
/// When to call: When the SDK is no longer used, the resources used by the SDK can be released through this interface
/// Restrictions: None.
/// Caution: After using [createEngine] to create a singleton, if the singleton object has not been created or has been destroyed, you will not receive related callbacks when calling this function.
///
/// @param callback Notification callback for destroy engine completion. Developers can listen to this callback to ensure that device hardware resources are released. If the developer only uses SDK to implement audio and video functions, this parameter can be passed [nil].
+ (void)destroyEngine:(nullable ZegoDestroyCompletionCallback)callback;

/// Returns the singleton instance of ZegoExpressEngine.
///
/// Available since: 1.1.0
/// Description: If the engine has not been created or has been destroyed, returns [nil].
/// When to call: After creating the engine, before destroying the engine.
/// Restrictions: None.
///
/// @return Engine singleton instance
+ (ZegoExpressEngine *)sharedEngine;

/// Set advanced engine configuration.
///
/// Available since: 1.1.0
/// Description: Used to enable advanced functions.
/// When to call: Different configurations have different call timing requirements. For details, please consult ZEGO technical support.
/// Restrictions: None.
///
/// @param config Advanced engine configuration
+ (void)setEngineConfig:(ZegoEngineConfig *)config;

/// Set log configuration.
///
/// Available since: 2.3.0
/// Description: If you need to customize the log file size and path, please call this function to complete the configuration.
/// When to call: It must be set before calling [createEngine] to take effect. If it is set after [createEngine], it will take effect at the next [createEngine] after [destroyEngine].
/// Restrictions: None.
/// Caution: Once this interface is called, the method of setting log size and path via [setEngineConfig] will be invalid.Therefore, it is not recommended to use [setEngineConfig] to set the log size and path.
///
/// @param config log configuration.
+ (void)setLogConfig:(ZegoLogConfig *)config;

/// Set room mode.
///
/// Available since: 2.9.0
/// Description: If you need to use the multi-room feature, please call this function to complete the configuration.
/// When to call: Must be set before calling [createEngine] to take effect, otherwise it will fail.
/// Restrictions: If you need to use the multi-room feature, please contact the instant technical support to configure the server support.
/// Caution: None.
///
/// @param mode Room mode. Description: Used to set the room mode. Use cases: If you need to enter multiple rooms at the same time for publish-play stream, please turn on the multi-room mode through this interface. Required: True. Default value: ZEGO_ROOM_MODE_SINGLE_ROOM.
+ (void)setRoomMode:(ZegoRoomMode)mode;

/// Gets the SDK's version number.
///
/// Available since: 1.1.0
/// Description: If you encounter an abnormality during the running of the SDK, you can submit the problem, log and other information to the ZEGO technical staff to locate and troubleshoot. Developers can also collect current SDK version information through this API, which is convenient for App operation statistics and related issues.
/// When to call: Any time.
/// Restrictions: None.
/// Caution: None.
///
/// @return SDK version.
+ (NSString *)getVersion;

/// Set method execution result callback.
///
/// Available since: 2.3.0
/// Description: Set the setting of the execution result of the calling method. After setting, you can get the detailed information of the result of each execution of the ZEGO SDK method.
/// When to call: Any time.
/// Restrictions: None.
/// Caution: It is recommended that developers call this interface only when they need to obtain the call results of each interface. For example, when troubleshooting and tracing problems. Developers generally do not need to pay attention to this interface.
///
/// @param callback Method execution result callback.
+ (void)setApiCalledCallback:(nullable id<ZegoApiCalledEventHandler>)callback;

/// Sets up the event notification callbacks that need to be handled. If the eventHandler is set to [nil], all the callbacks set previously will be cleared.
///
/// Available since: 1.1.0
/// Description: Set up event notification callbacks, used to monitor callbacks such as engine status changes, room status changes, etc.
/// When to call: After [createEngine].
/// Restrictions: None.
/// Caution: Invoke this function will overwrite the handler set in [createEngine] or the handler set by the last call to this method. After calling [destroyEngine], the event handler that has been set will be invalid and need to be reset after next calling of [createEngine].
///
/// @param eventHandler Event notification callback. If the eventHandler is set to [nil], all the callbacks set previously will be cleared. Developers should monitor the corresponding callbacks according to their own business scenarios. The main callback functions of the SDK are here.
- (void)setEventHandler:(nullable id<ZegoEventHandler>)eventHandler;

/// Uploads logs to the ZEGO server.
///
/// Available since: 1.1.0
/// Description: By default, SDK creates and prints log files in the App's default directory. Each log file defaults to a maximum of 5MB. Three log files are written over and over in a circular fashion. When calling this function, SDK will auto package and upload the log files to the ZEGO server.
/// Use cases: Developers can provide a business “feedback” channel in the App. When users feedback problems, they can call this function to upload the local log information of SDK to help locate user problems.
/// When to call: After [createEngine].
/// Restrictions: If you call this interface repeatedly within 10 minutes, only the last call will take effect.
/// Caution: After calling this interface to upload logs, if you call [destroyEngine] or exit the App too quickly, there may be a failure.It is recommended to wait a few seconds, and then call [destroyEngine] or exit the App after receiving the upload success callback.
- (void)uploadLog;

/// Uploads logs to the ZEGO server.
///
/// Available since: 2.4.0
/// Description: By default, SDK creates and prints log files in the App's default directory. Each log file defaults to a maximum of 5MB. Three log files are written over and over in a circular fashion. When calling this function, SDK will auto package and upload the log files to the ZEGO server.
/// Use cases: Developers can provide a business “feedback” channel in the App. When users feedback problems, they can call this function to upload the local log information of SDK to help locate user problems.
/// When to call: After [createEngine].
/// Restrictions: If you call this interface repeatedly within 10 minutes, only the last call will take effect.
/// Caution: After calling this interface to upload logs, if you call [destroyEngine] or exit the App too quickly, there may be a failure.It is recommended to wait a few seconds, and then call [destroyEngine] or exit the App after receiving the upload success callback..
///
/// @param callback Log upload result callback.
- (void)uploadLog:(nullable ZegoUploadLogResultCallback)callback;

/// Call the RTC experimental API.
///
/// Available since: 2.7.0
/// Description: ZEGO provides some technical previews or special customization functions in RTC business through this API. If you need to get the use of the function or the details, please consult ZEGO technical support.
/// When to call: After [createEngine].
///
/// @param params You need to pass in a parameter in the form of a JSON string, please consult ZEGO technical support for details.
/// @return Returns an argument in the format of a JSON string, please consult ZEGO technical support for details.
- (NSString *)callExperimentalAPI:(NSString *)params;

/// Set the path of the static picture would be published when the camera is closed.
///
/// Available: since 2.9.0
/// Description: Set the path of the static picture would be published when enableCamera(NO) is called, it would start to publish static pictures, and when enableCamera(YES) is called, it would end publishing static pictures.
/// Use case: The developer wants to display a static picture when the camera is closed. For example, when the anchor exits the background, the camera would be actively closed. At this time, the audience side needs to display the image of the anchor temporarily leaving.
/// When to call: After the engine is initialized, call this API to configure the parameters before closing the camera.
/// Restrictions: 1. Supported picture types are JPEG/JPG, PNG, BMP, HEIF. 2. The function is only for SDK video capture and does not take effect for custom video capture.
/// Caution: 1. The static picture cannot be seen in the local preview. 2. External filters, mirroring, watermarks, and snapshots are all invalid. 3. If the picture aspect ratio is inconsistent with the set code aspect ratio, it will be cropped according to the code aspect ratio.
/// Platform differences: 1. Windows: Fill in the location of the picture directly, such as "D://dir//image.jpg". 2. iOS: If it is a full path, add the prefix "file:", such as @"file:/var/image.png"; If it is a assets picture path, add the prefix "asset:", such as @"asset:watermark". 3. Android: If it is a full path, add the prefix "file:", such as "file:/sdcard/image.png"; If it is a assets directory path, add the prefix "asset:", such as "asset:watermark.png".
///
/// @param filePath Picture file path
/// @param channel Publish channel.
- (void)setDummyCaptureImagePath:(NSString *)filePath channel:(ZegoPublishChannel)channel;

/// This function is unavailable.
///
/// Please use [+createEngineWithAppID:appSign:isTestEnv:scenario:eventHandler:] instead
+ (instancetype)new NS_UNAVAILABLE;

/// This function is unavailable.
///
/// Please use [+createEngineWithAppID:appSign:isTestEnv:scenario:eventHandler:] instead
- (instancetype)init NS_UNAVAILABLE;

/// [Deprecated] Create ZegoExpressEngine singleton object and initialize SDK.
///
/// Available: 1.1.0 ~ 2.13.1, deprecated since 2.14.0, please use the method with the same name without [isTestEnv] parameter instead
/// Description: Create ZegoExpressEngine singleton object and initialize SDK.
/// When to call: The engine needs to be created before calling other functions.
/// Restrictions: None.
/// Caution: The SDK only supports the creation of one instance of ZegoExpressEngine. Multiple calls to this function return the same object.
///
/// @deprecated Deprecated since 2.14.0, please use the method with the same name without [isTestEnv] parameter instead.
/// @param appID Application ID issued by ZEGO for developers, please apply from the ZEGO Admin Console https://console-express.zego.im The value ranges from 0 to 4294967295.
/// @param appSign Application signature for each AppID, please apply from the ZEGO Admin Console. Application signature is a 64 character string. Each character has a range of '0' ~ '9', 'a' ~ 'z'.
/// @param isTestEnv Choose to use a test environment or a formal commercial environment, the formal environment needs to submit work order configuration in the ZEGO management console. The test environment is for test development, with a limit of 10 rooms and 50 users. Official environment App is officially launched. ZEGO will provide corresponding server resources according to the configuration records submitted by the developer in the management console. The test environment and the official environment are two sets of environments and cannot be interconnected.
/// @param scenario The application scenario. Developers can choose one of ZegoScenario based on the scenario of the app they are developing, and the engine will preset a more general setting for specific scenarios based on the set scenario. After setting specific scenarios, developers can still call specific functions to set specific parameters if they have customized parameter settings.The recommended configuration for different application scenarios can be referred to: https://doc-zh.zego.im/faq/profile_difference.
/// @param eventHandler Event notification callback. [nil] means not receiving any callback notifications.It can also be managed later via [setEventHandler]. If [createEngine] is called repeatedly and the [destroyEngine] function is not called to destroy the engine before the second call, the eventHandler will not be updated.
/// @return Engine singleton instance.
+ (ZegoExpressEngine *)createEngineWithAppID:(unsigned int)appID appSign:(NSString *)appSign isTestEnv:(BOOL)isTestEnv scenario:(ZegoScenario)scenario eventHandler:(nullable id<ZegoEventHandler>)eventHandler DEPRECATED_ATTRIBUTE;

/// [Deprecated] Turns on/off verbose debugging and sets up the log language.
///
/// This function has been deprecated after version 2.3.0, please use the [setEngineConfig] function to set the advanced configuration property advancedConfig to achieve the original function.
/// The debug switch is set to on and the language is English by default.
///
/// @deprecated This function has been deprecated after version 2.3.0, please use the [setEngineConfig] function to set the advanced configuration property advancedConfig to achieve the original function.
/// @param enable Detailed debugging information switch
/// @param language Debugging information language
- (void)setDebugVerbose:(BOOL)enable language:(ZegoLanguage)language DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END

#import "ZegoExpressEngine+CustomAudioIO.h"
#import "ZegoExpressEngine+Device.h"
#import "ZegoExpressEngine+IM.h"
#import "ZegoExpressEngine+MediaPlayer.h"
#import "ZegoExpressEngine+AudioEffectPlayer.h"
#import "ZegoExpressEngine+RangeAudio.h"
#import "ZegoExpressEngine+CopyrightedMusic.h"
#import "ZegoExpressEngine+Mixer.h"
#import "ZegoExpressEngine+Player.h"
#import "ZegoExpressEngine+Preprocess.h"
#import "ZegoExpressEngine+Publisher.h"
#import "ZegoExpressEngine+Record.h"
#import "ZegoExpressEngine+Room.h"
#import "ZegoExpressEngine+Utilities.h"
#if ZEGO_EXPRESS_VIDEO_SDK
#import "ZegoExpressEngine+CustomVideoIO.h"
#import "ZegoExpressEngine+ReplayKit.h"
#endif
