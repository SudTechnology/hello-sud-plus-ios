//
//  RoomGameInfoModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomGameInfoModel : BaseModel
/// 当前用户的游戏id
@property (nonatomic, copy) NSString *currentPlayerUserId;
/// 当前用户登录的code
@property (nonatomic, copy) NSString *code;
/// 当前游戏语言
@property (nonatomic, copy) NSString *language;
/// 错误码表
@property (nonatomic, strong) NSDictionary *errorMap;
/// 你画我猜专用，游戏中选中的关键词，会回调出来，通过 drawKeyWord 进行保存。
@property (nonatomic, copy) NSString *drawKeyWord;
/// 你画我猜，进入猜词环节，用来公屏识别关键字的状态标识
@property (nonatomic, assign) BOOL keyWordHiting;
/// 是否准备
@property (nonatomic, assign) BOOL isReady;
// 游戏状态： 0 = 空闲 1 = loading 2 = playing
@property (nonatomic, assign) NSInteger gameState;
/// true 已加入，false 未加入
@property (nonatomic, assign) BOOL isInGame;

/// 是否是数字炸弹  number
@property (nonatomic, assign) BOOL isHitBomb;
@end

NS_ASSUME_NONNULL_END
