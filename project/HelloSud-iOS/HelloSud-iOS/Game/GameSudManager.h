//
//  GameSudManager.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/// SudMGPSDK
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudFSMStateHandle.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameSudManager : NSObject

/// 获取sud sdk版本号
+(NSString *)sudSDKVersion;


@end

NS_ASSUME_NONNULL_END
