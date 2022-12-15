//
//  SudMGPAPPState2.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/19.
//

#pragma mark - 互动礼物<棒球>

/// 查询排行榜数据(棒球)
static NSString *APP_BASEBALL_RANKING = @"app_baseball_ranking";
/// 查询我的排名数据(棒球)
static NSString *APP_BASEBALL_MY_RANKING = @"app_baseball_my_ranking";
/// 排在自己前后的玩家数据(棒球)
static NSString *APP_BASEBALL_RANGE_INFO = @"app_baseball_range_info";
/// app主动调起主界面(棒球)
static NSString *APP_BASEBALL_SHOW_GAME_SCENE = @"app_baseball_show_game_scene";
/// app主动隐藏主界面(棒球)
static NSString *APP_BASEBALL_HIDE_GAME_SCENE = @"app_baseball_hide_game_scene";
/// 获取配置(棒球)
static NSString *APP_BASEBALL_TEXT_CONFIG = @"app_baseball_text_config";

#pragma mark - 互动礼物棒球 model

@interface AppBaseballRankingItemModel : NSObject
/// 玩家Id
@property (nonatomic, strong)NSString * playerId;
/// 玩家昵称
@property (nonatomic, strong)NSString *name;
/// 头像
@property (nonatomic, strong)NSString *avatar;
/// 距离
@property (nonatomic, assign)NSInteger distance;
/// 排名
@property (nonatomic, assign)NSInteger rank;
@end

/// APP_BASEBALL_RANKING 排行榜数据(棒球)
@interface AppBaseballRankingModel : NSObject

///  玩家数据的数组
@property(nonatomic, strong) NSArray<AppBaseballRankingItemModel *> *data;
@end

/// APP_BASEBALL_MY_RANKING 我的排名数据(棒球)
@interface AppBaseballMyRankingModel : NSObject
@property(nonatomic, strong) AppBaseballRankingItemModel *data;
@end

/// APP_BASEBALL_RANGE_INFO 我的排名数据(棒球)
@interface AppBaseballRangeInfoModel : NSObject
/// 前一名
@property(nonatomic, strong) AppBaseballRankingItemModel *before;
/// 后一名
@property(nonatomic, strong) AppBaseballRankingItemModel *after;
@end

/// APP_BASEBALL_TEXT_CONFIG 文本配置
@interface AppBaseballTextConfigModel : NSObject
/// 模式1
@property(nonatomic, strong) NSString *mode1;
/// 模式2
@property(nonatomic, strong) NSString *mode2;
/// 模式3
@property(nonatomic, strong) NSString *mode3;
@end

