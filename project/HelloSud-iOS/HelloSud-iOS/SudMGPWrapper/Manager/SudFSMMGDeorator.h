//
//  SudFSMMGManager.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import <Foundation/Foundation.h>
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudAPPD.h>
#import <SudMGP/ISudFSMStateHandle.h>

NS_ASSUME_NONNULL_BEGIN

/// jicheng
@interface SudFSMMGDeorator : NSObject
/// 初始化
- (instancetype)init:(NSString *)roomID userID:(NSString *)userID language:(NSString *)language;

/// app To 游戏 管理类
@property (nonatomic, strong) SudFSTAPPDeorator *sudFSTAPPManager;



@end

NS_ASSUME_NONNULL_END
