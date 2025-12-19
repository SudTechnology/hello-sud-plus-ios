#import "GamePermissionModel.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

#import <SudGIP/SudGIP-umbrella.h>

#import "AppDelegate.h"
#import "GameEnv.h"

static NSString * const _CR_KEY_PERMISSION_USER_INFO_OLD = @"userInfo";

typedef NS_ENUM(NSInteger,_GamePermissionType)
{
    GAME_PERMISSION_TYPE_UNKNOW,
    GAME_PERMISSION_TYPE_LOCATION,
    GAME_PERMISSION_TYPE_CAMERA,
    GAME_PERMISSION_TYPE_PHOTOS,
    GAME_PERMISSION_TYPE_MICROPHONE,
};

typedef NS_ENUM(NSUInteger, _GamePermissionStatus) {
    GAME_PERMISSION_STATUS_UNDETERMINED,
    GAME_PERMISSION_STATUS_DENIED,
    GAME_PERMISSION_STATUS_GRANTED
};

typedef void (^_RequestPermissionCompletionBlock)(BOOL granted);

@interface GamePermissionModel ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) _RequestPermissionCompletionBlock locationPermissionCompletion;
@end

@implementation GamePermissionModel

- (UIWindow *)_keyWindow {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return keyWindow;
}

- (BOOL)_isRuntimePermissionScope:(NSString *)scope {
//    if ([scope isEqualToString:SUD_RT2_KEY_PERMISSION_CAMERA] ||
//        [scope isEqualToString:SUD_RT2_KEY_PERMISSION_LOCATION] ||
//        [scope isEqualToString:SUD_RT2_KEY_PERMISSION_SAVE_TO_ALBUM] ||
//        [scope isEqualToString:SUD_RT2_KEY_PERMISSION_RECORD]) {
//        return YES;
//    }
    return NO;
}

- (_GamePermissionType)_permissionTypeWithPermissionScope:(NSString *)scope {
//    if ([scope isEqualToString:SUD_RT2_KEY_PERMISSION_CAMERA]) {
//        return GAME_PERMISSION_TYPE_CAMERA;
//    } else if ([scope isEqualToString:SUD_RT2_KEY_PERMISSION_LOCATION]) {
//        return GAME_PERMISSION_TYPE_LOCATION;
//    } else if ([scope isEqualToString:SUD_RT2_KEY_PERMISSION_SAVE_TO_ALBUM]) {
//        return GAME_PERMISSION_TYPE_PHOTOS;
//    } else if ([scope isEqualToString:SUD_RT2_KEY_PERMISSION_RECORD]) {
//        return GAME_PERMISSION_TYPE_MICROPHONE;
//    }
    return GAME_PERMISSION_TYPE_UNKNOW;
}

- (void)_showGamePermissionAlert:(NSString *)permission
                           appID:(NSString *)appId
                      completion:(nonnull void (^)(BOOL allow))completion {
//    _GamePermissionType permissionType = [self _permissionTypeWithPermissionScope:permission];
//    GameEnv *env = [GameEnv getInstance];
//    id<SudRt2GameRuntime> runtime = [env getCocosGameRuntime];
//    id<CRCocosGamePackageManager> packageManager = (id<CRCocosGamePackageManager>)[runtime getManagerWithName:CR_KEY_MANAGER_GAME_PACKAGE
//                                                                                                      options:nil];
//    id<CRCocosGameConfigV2> config = [packageManager getGameConfig:appId];
//    NSString *tip = [config.permissions objectForKey:permission];;
//    if (!tip.length) {
//        switch (permissionType) {
//            case GAME_PERMISSION_TYPE_LOCATION:
//                tip = @"定位";
//                break;
//            case GAME_PERMISSION_TYPE_PHOTOS:
//                tip = @"相册";
//                break;
//            case GAME_PERMISSION_TYPE_CAMERA:
//                tip = @"摄像头";
//                break;
//            case GAME_PERMISSION_TYPE_MICROPHONE:
//                tip = @"麦克风";
//                break;
//            default:
//                tip = [NSString stringWithFormat:@"自定义 %@", permission];
//                break;
//        }
//    }
//    
//    NSString *message = [NSString stringWithFormat:@"应用需要获取%@权限，是否允许", tip];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"权限要求"
//                                                                                 message:message
//                                                                          preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"允许"
//                                                              style:UIAlertActionStyleDefault
//                                                            handler:^(UIAlertAction * _Nonnull action) {
//            completion(YES);
//        }];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
//                                                               style:UIAlertActionStyleCancel
//                                                             handler:^(UIAlertAction * _Nonnull action) {
//            completion(NO);
//        }];
//
//        [alertController addAction:cancelAction];
//        [alertController addAction:allowAction];
//        [[self _topMostController] presentViewController:alertController
//                                                animated:YES
//                                              completion:nil];
//    });
}

- (void)_showGameSystemPermissionAlert:(NSString *)permission
                                 appID:(NSString *)appId
                            completion:(nonnull void (^)(BOOL allow))completion {
    _GamePermissionType permissionType = [self _permissionTypeWithPermissionScope:permission];
    NSString *tip = nil;
    switch (permissionType) {
        case GAME_PERMISSION_TYPE_LOCATION:
            tip = @"定位";
            break;
        case GAME_PERMISSION_TYPE_PHOTOS:
            tip = @"相册";
            break;
        case GAME_PERMISSION_TYPE_CAMERA:
            tip = @"摄像头";
            break;
        case GAME_PERMISSION_TYPE_MICROPHONE:
            tip = @"麦克风";
            break;
        default:
            tip = [NSString stringWithFormat:@"自定义 %@", permission];
            break;
    }
    
    NSString *message = [NSString stringWithFormat:@"应用需要获取%@权限，请到设置中打开", permission];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"权限要求"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"立刻设置"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
            completion(YES);
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
            completion(NO);
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:allowAction];
        [[self _topMostController] presentViewController:alertController
                                                animated:YES
                                              completion:nil];
    });
}

- (void)_showEnableServiceAlert:(NSString *)permission
                          appID:(NSString *)appId
                     completion:(nonnull void (^)(BOOL allow))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = [NSString stringWithFormat:@"%@ 服务未打开，立刻到设置中打开？", permission];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"权限要求"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *allowAction = [UIAlertAction actionWithTitle:@"立刻设置"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
            completion(YES);
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
            completion(NO);
        }];

        [alertController addAction:cancelAction];
        [alertController addAction:allowAction];
        [[self _topMostController] presentViewController:alertController
                                                animated:YES
                                              completion:nil];
    });
}

- (UIViewController *)_topMostController {
    UIWindow *keyWindow = [self _keyWindow];
    UIViewController *topController = keyWindow.rootViewController;
    while(topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    return topController;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            _locationPermissionCompletion(YES);
            _locationManager = nil;
            break;
        }
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            _locationPermissionCompletion(NO);
            _locationManager = nil;
            break;
        }
    }
}

#pragma mark - CRGameQueryPermissionListener
// 当需要用户允许游戏使用某个权限时调用，返回允许后，系统不会立刻申请相关的系统权限，而是当真正使用对应的api时才会申请
- (void)onQueryPermission:(id<SudRt2GameQueryPermissionHandle>)handle
               permission:(NSString *)permission
                    appId:(NSString *)appId
               authStatus:(SudRt2PermissionAuthStatus)authStatus {

}

#pragma mark - CRGameQuerySystemPermissionListener
// 当游戏将要请求系统权限前调用，如果服务被禁用或者未授权，可弹窗引导用户开启对应服务或者权限
- (void)beforeQuerySystemPermission:(id<SudRt2GameQuerySystemPermissionHandle>)handle
                       fromJSMethod:(NSString *)methodName
                         permission:(NSString *)permission
                              appId:(NSString *)appId
                         authStatus:(SudRt2SystemPermissionAuthStatus)authStatus
                      serviceStatus:(BOOL)enabled {

}
@end
