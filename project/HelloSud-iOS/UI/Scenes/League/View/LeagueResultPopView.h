//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 结果展示类型
typedef NS_ENUM(NSInteger, LeagueResultPopViewType) {
    LeagueResultTypeNotJoinFirstResult = 0,// 初赛未参与
    LeagueResultTypeNotJoinEndResult = 1,// 决赛未参与
    LeagueResultTypeJoinFirstBeforeThree = 2,// 初赛进入前三
    LeagueResultTypeJoinFirstAfterThree = 3,// 初赛未进前三
    LeagueResultTypeJoinEndFirst = 4,// 前三名争第一时第一个名
    LeagueResultTypeJoinEndLose = 5,// 前三名争第一时未获得第一
};

/// 联赛结果弹出框视图
@interface LeagueResultPopView : BaseView
/// 游戏玩家信息列表
@property(nonatomic, strong) NSArray <GuessPlayerModel *> *dataList;
@property(nonatomic, assign) LeagueResultPopViewType resultStateType;
@property(nonatomic, assign) NSInteger winCoin;
@property(nonatomic, strong) void (^againBlock)(void);
@end

NS_ASSUME_NONNULL_END
