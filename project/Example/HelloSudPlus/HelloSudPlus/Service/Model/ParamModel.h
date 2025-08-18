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

@interface ReqPlayerPropsCardsParamModel : ParamModel
@property(nonatomic, assign)int64_t gameId;
@end

/// 修改分身状态
@interface ReqAiSwitchStateModel : ParamModel
/// 状态 0：关闭， 1：开启
@property(nonatomic, assign)NSInteger status;
@end

/// 获取分身状态
@interface ReqAiCloneInfoModel : ParamModel
@end

/// 保存分身状态
@interface ReqSaveAiCloneInfoModel : ParamModel
@property (nonatomic, copy) NSString *nickname;                // Nickname (required)
@property (nonatomic, copy) NSString *birthday;                // Birthday (yyyy-MM-dd, required)
@property (nonatomic, copy) NSString *bloodType;               // Blood type (required)
@property (nonatomic, copy) NSString *mbti;                    // MBTI (required)
@property (nonatomic, copy) NSArray<NSString *>  *personalities;             // Personality traits (required)
@property (nonatomic, copy) NSArray<NSString *> *languageStyles;           // Language style (required)
@property (nonatomic, copy) NSArray<NSString *> *languageDetailStyles;     // Detailed language style (required)
@property (nonatomic, copy, nullable) NSString *audioData;     // Base64 audio data (optional)
@property (nonatomic, copy, nullable) NSString *audioFormat;   // Audio format: wav, mp3 (optional)
@end

/// 保存分身状态
@interface ReqRandAiCloneInfoModel : ParamModel
@end



NS_ASSUME_NONNULL_END
