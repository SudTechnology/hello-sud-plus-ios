//
//  GuessModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 更多竞猜游戏数据model
@interface MoreGuessGameModel : BaseRespModel
/// 游戏ID
@property (nonatomic, assign)int64_t gameId;
/// 跨房pk倒计时间隔（秒）
@property (nonatomic, assign)NSInteger gameCountDownCycle;
/// 游戏名称
@property (nonatomic, strong)NSString * gameName;
/// 游戏图片
@property (nonatomic, strong)NSString * gamePic;
/// 首页游戏图片
@property (nonatomic, strong)NSString * homeGamePic;
/// 入场门票(金币)
@property (nonatomic, assign)NSInteger ticketCoin;
/// 奖励(金币)
@property (nonatomic, assign)NSInteger winCoin;

/// 开始倒计时时间
@property (nonatomic, assign)NSTimeInterval beginTimestamp;
@end


/// 更多竞猜数据model
@interface RespMoreGuessModel : BaseRespModel
/// 跨房pk倒计时间隔（秒）
@property (nonatomic, assign)NSInteger pkCountDownCycle;
@property (nonatomic, strong)NSArray<MoreGuessGameModel *> *quizGameInfoList;
@end

/// 竞猜数据玩家列表数据
@interface GuessPlayerModel : BaseModel
@property (nonatomic, assign)int64_t userId;
@property (nonatomic, assign)BOOL support;
@property (nonatomic, assign)NSInteger supportedUserCount;
@property (nonatomic, strong)NSString * header;
@property (nonatomic, strong)NSString * nickname;

/// 是否已经选中
@property (nonatomic, assign)BOOL isSelected;
@end

/// 竞猜数据玩家列表数据
@interface RespGuessPlayerListModel : BaseRespModel
/// 赢金币数(每人)
@property (nonatomic, assign)NSInteger winCoin;
/// 投注金币数(每人)
@property (nonatomic, assign)NSInteger betCoin;
@property (nonatomic, strong)NSArray<GuessPlayerModel *> *playerList;
@end

NS_ASSUME_NONNULL_END
