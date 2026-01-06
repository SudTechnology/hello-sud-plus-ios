//
// Created by guanghui on 2022/7/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SudLoadMGParamModel : NSObject
/// loadMG模式
@property (nonatomic, assign) int loadMGMode;

/// game view container
@property (nonatomic, strong) UIView *gameViewContainer;

/// 用户ID，业务系统保证每个用户拥有唯一ID
@property (nonatomic, copy) NSString *userId;

/// 房间ID，业务系统保证唯一性，进入同一房间内
@property (nonatomic, copy) NSString *roomId;

/// code 短期令牌Code
@property (nonatomic, copy) NSString *code;

/// 小游戏ID，测试环境和生产环境小游戏ID是一致的
@property (nonatomic, assign) long mgId;

/// language 游戏语言 现支持，简体：zh-CN 繁体：zh-TW 英语：en-US 马来语：ms-MY 等
@property (nonatomic, copy) NSString *language;

/// 当loadMgMode为kLoadMgModeCrossApp时，该字段有效
@property (nonatomic, copy) NSString *authorizationSecret;

- (instancetype)init;

- (BOOL) check;
@end