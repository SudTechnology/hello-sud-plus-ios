//
//  ZegoExpressEngine+Room.h
//  ZegoExpressEngine
//
//  Copyright © 2019 Zego. All rights reserved.
//

#import "ZegoExpressEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoExpressEngine (Room)

/// Logs in to a room. You must log in to a room before publishing or playing streams.
///
/// Available since: 1.1.0
/// Description: SDK uses the 'room' to organize users. After users log in to a room, they can use interface such as push stream [startPublishingStream], pull stream [startPlayingStream], send and receive broadcast messages [sendBroadcastMessage], etc.
/// Use cases: In the same room, users can conduct live broadcast, audio and video calls, etc.
/// When to call /Trigger: This interface is called after [createEngine] initializes the SDK.
/// Restrictions: For restrictions on the use of this function, please refer to https://doc-en.zego.im/article/7611 or contact ZEGO technical support.
/// Caution: 1. Apps that use different appIDs cannot intercommunication with each other, and the test/official environment cannot intercommunication with each other ether. 2. SDK supports startPlayingStream audio and video streams from different rooms under the same appID, that is, startPlayingStream audio and video streams across rooms. Since ZegoExpressEngine's room related callback notifications are based on the same room, when developers want to startPlayingStream streams across rooms, developers need to maintain related messages and signaling notifications by themselves. 3. It is strongly recommended that userID corresponds to the user ID of the business APP, that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID. Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems. 4. After the first login failure due to network reasons or the room is disconnected, the default time of SDK reconnection is 20min. 5. After the user has successfully logged in to the room, if the application exits abnormally, after restarting the application, the developer needs to call the logoutRoom interface to log out of the room, and then call the loginRoom interface to log in to the room again.
/// Privacy reminder: Please do not fill in sensitive user information in this interface, including but not limited to mobile phone number, ID number, passport number, real name, etc.
/// Related callbacks: 1. When the user starts to log in to the room, the room is successfully logged in, or the room fails to log in, the [onRoomStateUpdate] callback will be triggered to notify the developer of the status of the current user connected to the room. 2. Different users who log in to the same room can get room related notifications in the same room (eg [onRoomUserUpdate], [onRoomStreamUpdate], etc.), and users in one room cannot receive room signaling notifications in another room. 3. If the network is temporarily interrupted due to network quality reasons, the SDK will automatically reconnect internally. You can get the current connection status of the local room by listening to the [onRoomStateUpdate] callback method, and other users in the same room will receive [onRoomUserUpdate] callback notification. 4. Messages sent in one room (e.g. [setStreamExtraInfo], [sendBroadcastMessage], [sendBarrageMessage], [sendCustomCommand], etc.) cannot be received callback ((eg [onRoomStreamExtraInfoUpdate], [onIMRecvBroadcastMessage], [onIMRecvBarrageMessage], [onIMRecvCustomCommand], etc) in other rooms. Currently, SDK does not provide the ability to send messages across rooms. Developers can integrate the SDK of third-party IM to achieve.
/// Related APIs: 1. Users can call [logoutRoom] to log out. In the case that a user has successfully logged in and has not logged out, if the login interface is called again, the console will report an error and print the error code 1002001. 2. SDK supports multi-room login, please call [setRoomMode] function to select multi-room mode before engine initialization, and then call [loginRoom] to log in to multi-room. 3. Calling [destroyEngine] will also automatically log out.
///
/// @param roomID Room ID, a string of up to 128 bytes in length. Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
/// @param user User object instance, configure userID, userName. Note that the userID needs to be globally unique with the same appID, otherwise the user who logs in later will kick out the user who logged in first.
- (void)loginRoom:(NSString *)roomID user:(ZegoUser *)user;

/// Logs in to a room with advanced room configurations. You must log in to a room before publishing or playing streams.
///
/// Available since: 1.1.0
/// Description: SDK uses the 'room' to organize users. After users log in to a room, they can use interface such as push stream [startPublishingStream], pull stream [startPlayingStream], send and receive broadcast messages [sendBroadcastMessage], etc. To prevent the app from being impersonated by a malicious user, you can add authentication before logging in to the room, that is, the [token] parameter in the ZegoRoomConfig object passed in by the [config] parameter.
/// Use cases: In the same room, users can conduct live broadcast, audio and video calls, etc.
/// When to call /Trigger: This interface is called after [createEngine] initializes the SDK.
/// Restrictions: For restrictions on the use of this function, please refer to https://doc-en.zego.im/article/7611 or contact ZEGO technical support.
/// Caution: 1. Apps that use different appIDs cannot intercommunication with each other, and the test/official environment cannot intercommunication with each other ether. 2. SDK supports startPlayingStream audio and video streams from different rooms under the same appID, that is, startPlayingStream audio and video streams across rooms. Since ZegoExpressEngine's room related callback notifications are based on the same room, when developers want to startPlayingStream streams across rooms, developers need to maintain related messages and signaling notifications by themselves. 3. It is strongly recommended that userID corresponds to the user ID of the business APP, that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID. Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems. 4. After the first login failure due to network reasons or the room is disconnected, the default time of SDK reconnection is 20min. 5. After the user has successfully logged in to the room, if the application exits abnormally, after restarting the application, the developer needs to call the logoutRoom interface to log out of the room, and then call the loginRoom interface to log in to the room again.
/// Privacy reminder: Please do not fill in sensitive user information in this interface, including but not limited to mobile phone number, ID number, passport number, real name, etc.
/// Related callbacks: 1. When the user starts to log in to the room, the room is successfully logged in, or the room fails to log in, the [onRoomStateUpdate] callback will be triggered to notify the developer of the status of the current user connected to the room. 2. Different users who log in to the same room can get room related notifications in the same room (eg [onRoomUserUpdate], [onRoomStreamUpdate], etc.), and users in one room cannot receive room signaling notifications in another room. 3. If the network is temporarily interrupted due to network quality reasons, the SDK will automatically reconnect internally. You can get the current connection status of the local room by listening to the [onRoomStateUpdate] callback method, and other users in the same room will receive [onRoomUserUpdate] callback notification. 4. Messages sent in one room (e.g. [setStreamExtraInfo], [sendBroadcastMessage], [sendBarrageMessage], [sendCustomCommand], etc.) cannot be received callback ((eg [onRoomStreamExtraInfoUpdate], [onIMRecvBroadcastMessage], [onIMRecvBarrageMessage], [onIMRecvCustomCommand], etc) in other rooms. Currently, SDK does not provide the ability to send messages across rooms. Developers can integrate the SDK of third-party IM to achieve.
/// Related APIs: 1. Users can call [logoutRoom] to log out. In the case that a user has successfully logged in and has not logged out, if the login interface is called again, the console will report an error and print the error code 1002001. 2. SDK supports multi-room login, please call [setRoomMode] function to select multi-room mode before engine initialization, and then call [loginRoom] to log in to multi-room. 3. Calling [destroyEngine] will also automatically log out.
///
/// @param roomID Room ID, a string of up to 128 bytes in length. Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
/// @param user User object instance, configure userID, userName. Note that the userID needs to be globally unique with the same appID, otherwise the user who logs in later will kick out the user who logged in first.
/// @param config Advanced room configuration.
- (void)loginRoom:(NSString *)roomID user:(ZegoUser *)user config:(ZegoRoomConfig *)config;

/// Logs out of a room.
///
/// Available since: 2.9.0
/// Description: This API will log out the current user has logged in the room, if user logs in more than one room, all the rooms will be logged out.
/// Use cases: In the same room, users can conduct live broadcast, audio and video calls, etc.
/// When to call /Trigger: After successfully logging in to the room, if the room is no longer used, the user can call the function [logoutRoom].
/// Restrictions: None.
/// Caution: 1. Exiting the room will stop all publishing and playing streams for user, and inner audio and video engine will stop, and then SDK will auto stop local preview UI. If you want to keep the preview ability when switching rooms, please use the [switchRoom] method. 2. If the user is not logged in to the room, calling this function will also return success.
/// Related callbacks: After calling this function, you will receive [onRoomStateUpdate] callback notification successfully exits the room, while other users in the same room will receive the [onRoomUserUpdate] callback notification(On the premise of enabling isUserStatusNotify configuration).
/// Related APIs: Users can use [loginRoom], [switchRoom] functions to log in or switch rooms.
- (void)logoutRoom;

/// Logs out of a room.
///
/// Available since: 1.1.0
/// Description: This API will log out the room named roomID.
/// Use cases: In the same room, users can conduct live broadcast, audio and video calls, etc.
/// When to call /Trigger: After successfully logging in to the room, if the room is no longer used, the user can call the function [logoutRoom].
/// Restrictions: None.
/// Caution: 1. Exiting the room will stop all publishing and playing streams for user, and inner audio and video engine will stop, and then SDK will auto stop local preview UI. If you want to keep the preview ability when switching rooms, please use the [switchRoom] method. 2. If the user logs in to the room, but the incoming 'roomID' is different from the logged-in room name, SDK will return failure.
/// Related callbacks: After calling this function, you will receive [onRoomStateUpdate] callback notification successfully exits the room, while other users in the same room will receive the [onRoomUserUpdate] callback notification(On the premise of enabling isUserStatusNotify configuration).
/// Related APIs: Users can use [loginRoom], [switchRoom] functions to log in or switch rooms.
///
/// @param roomID Room ID, a string of up to 128 bytes in length. Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
- (void)logoutRoom:(NSString *)roomID;

/// Switch the room.
///
/// Available since: 1.14.0
/// Description: Using this interface allows users to quickly switch from one room to another room.
/// Use cases: If you need to quickly switch to the next room, you can call this function.
/// When to call /Trigger: After successfully login room.
/// Restrictions: None.
/// Caution: 1. When this function is called, all streams currently publishing or playing will stop (but the local preview will not stop). 2. When the function [setRoomMode] is used to set ZegoRoomMode to ZEGO_ROOM_MODE_MULTI_ROOM, this function is not available.
/// Privacy reminder: Please do not fill in sensitive user information in this interface, including but not limited to mobile phone number, ID number, passport number, real name, etc.
/// Related callbacks: When the user call the [switchRoom] function, the [onRoomStateUpdate] callback will be triggered to notify the developer of the status of the current user connected to the room.
/// Related APIs: Users can use the [logoutRoom] function to log out of the room.
///
/// @param fromRoomID Current roomID.
/// @param toRoomID The next roomID.
- (void)switchRoom:(NSString *)fromRoomID toRoomID:(NSString *)toRoomID;

/// Switch the room with advanced room configurations.
///
/// Available since: 1.15.0
/// Description: Using this interface allows users to quickly switch from one room to another room.
/// Use cases: if you need to quickly switch to the next room, you can call this function.
/// When to call /Trigger: After successfully login room.
/// Restrictions: None.
/// Caution: 1. When this function is called, all streams currently publishing or playing will stop (but the local preview will not stop). 2. To prevent the app from being impersonated by a malicious user, you can add authentication before logging in to the room, that is, the [token] parameter in the ZegoRoomConfig object passed in by the [config] parameter. This parameter configuration affects the room to be switched over. 3. When the function [setRoomMode] is used to set ZegoRoomMode to ZEGO_ROOM_MODE_MULTI_ROOM, this function is not available.
/// Privacy reminder: Please do not fill in sensitive user information in this interface, including but not limited to mobile phone number, ID number, passport number, real name, etc.
/// Related callbacks: When the user call the [switchRoom] function, the [onRoomStateUpdate] callback will be triggered to notify the developer of the status of the current user connected to the room.
/// Related APIs: Users can use the [logoutRoom] function to log out of the room.
///
/// @param fromRoomID Current roomID.
/// @param toRoomID The next roomID.
/// @param config Advanced room configuration.
- (void)switchRoom:(NSString *)fromRoomID toRoomID:(NSString *)toRoomID config:(ZegoRoomConfig *)config;

/// Renew token.
///
/// Available since: 2.8.0
/// Description: After the developer receives [onRoomTokenWillExpire], they can use this API to update the token to ensure that the subsequent RTC functions are normal.
/// Use cases: Used when the token is about to expire.
/// When to call /Trigger: After the developer receives [onRoomTokenWillExpire].
/// Restrictions: None.
/// Caution: The token contains important information such as the user's room permissions, publish stream permissions, and effective time, please refer to https://doc-en.zego.im/article/11649.
/// Related callbacks: None.
/// Related APIs: None.
///
/// @param token The token that needs to be renew.
/// @param roomID Room ID.
- (void)renewToken:(NSString *)token roomID:(NSString *)roomID;

/// Set room extra information.
///
/// Available since: 1.13.0
/// Description: The user can call this function to set the extra info of the room.
/// Use cases: You can set some room-related business attributes, such as whether someone is Co-hosting.
/// When to call /Trigger: After logging in the room successful.
/// Restrictions: For restrictions on the use of this function, please refer to https://doc-en.zego.im/article/7611 or contact ZEGO technical support.
/// Caution: 'key' and 'value' are non nil. key.length < 128, value.length < 4096. The newly set key and value will overwrite the old setting.
/// Related callbacks: Other users in the same room will be notified through the [onRoomExtraInfoUpdate] callback function.
/// Related APIs: None.
///
/// @param value value if the extra info.
/// @param key key of the extra info.
/// @param roomID Room ID.
/// @param callback Callback for setting room extra information.
- (void)setRoomExtraInfo:(NSString *)value forKey:(NSString *)key roomID:(NSString *)roomID callback:(nullable ZegoRoomSetRoomExtraInfoCallback)callback;

/// [Deprecated] Logs in multi room.
///
/// This method has been deprecated after version 2.9.0 If you want to access the multi-room feature, Please set [setRoomMode] to select multi-room mode before the engine started, and then call [loginRoom] to use multi-room. If you call [loginRoom] function to log in to multiple rooms, please make sure to pass in the same user information.
/// You must log in the main room with [loginRoom] before invoke this function to logging in to multi room.
/// Currently supports logging into 1 main room and 1 multi room at the same time.
/// When logging out, you must log out of the multi room before logging out of the main room.
/// User can only publish the stream in the main room, but can play the stream in the main room and multi room at the same time, and can receive the signaling and callback in each room.
/// The advantage of multi room is that you can login another room without leaving the current room, receive signaling and callback from another room, and play streams from another room.
/// To prevent the app from being impersonated by a malicious user, you can add authentication before logging in to the room, that is, the [token] parameter in the ZegoRoomConfig object passed in by the [config] parameter.
/// Different users who log in to the same room can get room related notifications in the same room (eg [onRoomUserUpdate], [onRoomStreamUpdate], etc.), and users in one room cannot receive room signaling notifications in another room.
/// Messages sent in one room (e.g. [setStreamExtraInfo], [sendBroadcastMessage], [sendBarrageMessage], [sendCustomCommand], etc.) cannot be received callback ((eg [onRoomStreamExtraInfoUpdate], [onIMRecvBroadcastMessage], [onIMRecvBarrageMessage], [onIMRecvCustomCommand], etc) in other rooms. Currently, SDK does not provide the ability to send messages across rooms. Developers can integrate the SDK of third-party IM to achieve.
/// SDK supports startPlayingStream audio and video streams from different rooms under the same appID, that is, startPlayingStream audio and video streams across rooms. Since ZegoExpressEngine's room related callback notifications are based on the same room, when developers want to startPlayingStream streams across rooms, developers need to maintain related messages and signaling notifications by themselves.
/// If the network is temporarily interrupted due to network quality reasons, the SDK will automatically reconnect internally. You can get the current connection status of the local room by listening to the [onRoomStateUpdate] callback method, and other users in the same room will receive [onRoomUserUpdate] callback notification.
/// It is strongly recommended that userID corresponds to the user ID of the business APP, that is, a userID and a real user are fixed and unique, and should not be passed to the SDK in a random userID. Because the unique and fixed userID allows ZEGO technicians to quickly locate online problems.
///
/// @deprecated This method has been deprecated after version 2.9.0 If you want to access the multi-room feature, Please set [setRoomMode] to select multi-room mode before the engine started, and then call [loginRoom] to use multi-room. If you call [loginRoom] function to log in to multiple rooms, please make sure to pass in the same user information.
/// @param roomID Room ID, a string of up to 128 bytes in length. Only support numbers, English characters and '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '=', '-', '`', ';', '’', ',', '.', '<', '>', '/', '\'.
/// @param config Advanced room configuration.
- (void)loginMultiRoom:(NSString *)roomID config:(nullable ZegoRoomConfig *)config DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
