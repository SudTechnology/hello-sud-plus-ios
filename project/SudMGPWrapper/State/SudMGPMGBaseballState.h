//
//  SudMGPMGState.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 通用状态-游戏

#pragma mark - 互动礼物<棒球>
/// 查询排行榜数据
static NSString *MG_BASEBALL_RANKING = @"mg_baseball_ranking";
/// 查询我的排名
static NSString *MG_BASEBALL_MY_RANKING = @"mg_baseball_my_ranking";
/// 查询当前距离我的前后玩家数据
static NSString *MG_BASEBALL_RANGE_INFO = @"mg_baseball_range_info";
/// 设置app提供给游戏可点击区域
static NSString *MG_BASEBALL_SET_CLICK_RECT = @"mg_baseball_set_click_rect";
/// 前期准备完成
static NSString *MG_BASEBALL_PREPARE_FINISH = @"mg_baseball_prepare_finish";
/// 主界面已显示
static NSString *MG_BASEBALL_SHOW_GAME_SCENE = @"mg_baseball_show_game_scene";
/// 主界面已隐藏
static NSString *MG_BASEBALL_HIDE_GAME_SCENE = @"mg_baseball_hide_game_scene";
/// 获取配置
static NSString *MG_BASEBALL_TEXT_CONFIG = @"mg_baseball_text_config";


#pragma mark - MG_BASEBALL_RANKING
@interface MGBaseballRanking : NSObject
/// 页数
@property(nonatomic, assign) NSInteger page;
/// 每页显示的数量
@property(nonatomic, assign) NSInteger size;
@end

#pragma mark - MG_BASEBALL_MY_RANKING
@interface MGBaseballMyRanking : NSObject

@end

#pragma mark - MG_BASEBALL_RANGE_INFO
@interface MGBaseballRangeInfo : NSObject
/// 自己当前的距离
@property(nonatomic, assign) NSInteger distance;
@end
NS_ASSUME_NONNULL_END
