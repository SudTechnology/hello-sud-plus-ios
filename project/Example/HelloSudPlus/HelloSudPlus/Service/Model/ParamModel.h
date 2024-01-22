//
//  ParamModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2023/12/18.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParamModel : BaseModel

@end


@interface ReqMatchRoomParamModel : ParamModel
@property(nonatomic, assign)int64_t gameId;
@property(nonatomic, assign)int64_t sceneType;
@property(nonatomic, assign)NSInteger gameLevel;
@property(nonatomic, assign)NSInteger loadType;// 游戏加载类型
@property(nonatomic, assign)NSInteger tabType;// 应用tab，1: scene, 2: game
@end

@interface ReqEnterRoomParamModel : ParamModel
@property(nonatomic, assign)long roomId;
@property(nonatomic, assign)BOOL isFromCreate;
@property(nonatomic, strong)NSDictionary *extData;
@property(nonatomic, assign)NSInteger loadType;// 游戏加载类型
@property(nonatomic, assign)NSInteger tabType;// 应用tab，1: scene, 2: game
@end

NS_ASSUME_NONNULL_END
