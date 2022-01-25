//
//  GameSudManager.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import "GameSudManager.h"

@interface GameSudManager ()

@end

@implementation GameSudManager

/// 获取sud sdk版本号
+(NSString *)sudSDKVersion {
    return SudMGP.getVersion;
}

@end

