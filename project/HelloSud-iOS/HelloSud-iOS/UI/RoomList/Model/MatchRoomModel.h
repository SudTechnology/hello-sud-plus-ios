//
//  MatchRoomModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 匹配游戏房Model
@interface MatchRoomModel : BaseRespModel
@property (nonatomic, assign) NSInteger roomId;
@property (nonatomic, copy) NSString * roomName;
@property (nonatomic, assign) NSInteger gameId;
@property (nonatomic, assign) NSInteger memberCount;
@property (nonatomic, assign) NSInteger roleType;

@end

NS_ASSUME_NONNULL_END
