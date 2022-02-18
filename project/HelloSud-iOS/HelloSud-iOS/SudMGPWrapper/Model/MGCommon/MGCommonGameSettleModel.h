//
//  MGCommonGameSettleModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 通用状态-游戏: 游戏结算状态   MG_COMMON_GAME_SETTLE

@interface MGCommonGameSettleResults :NSObject
/// 本局游戏id
@property (nonatomic, copy) NSString *uid;
/// 杀自己的玩家id
@property (nonatomic, copy) NSString *killerId;
/// 排名 从 1 开始
@property (nonatomic, assign) NSInteger rank;
/// 奖励
@property (nonatomic, assign) NSInteger award;
/// 积分
@property (nonatomic, assign) NSInteger score;
/// 逃跑
@property (nonatomic, assign) NSInteger isEscaped;
@end

@interface MGCommonGameSettleModel : BaseModel
/// 游戏模式
@property (nonatomic, assign) NSInteger gameMode;
/// 本局游戏id
@property (nonatomic, copy) NSString *gameRoundId;
/// 
@property (nonatomic, copy) NSArray<MGCommonGameSettleResults *> *results;
@end


NS_ASSUME_NONNULL_END
