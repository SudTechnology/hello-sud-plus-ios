//
// Created by kaniel on 2022/3/23.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

/// 刷新token响应
@interface RespRefreshTokenModel : BaseRespModel
@property (nonatomic, copy) NSString * refreshToken;
@property (nonatomic, copy) NSString * token;

@end

/// 版本更新
@interface RespVersionUpdateInfoModel : BaseRespModel
/// 包路径
@property (nonatomic, copy) NSString * packageUrl;
/// 目标版本
@property (nonatomic, copy) NSString * targetVersion;
/// 升级类型(1强制升级，2引导升级)
@property (nonatomic, assign) NSInteger upgradeType;

@end

/// 响应开始PK
@interface RespStartPKModel : BaseRespModel
/// pk标识
@property (nonatomic, assign) int64_t pkId;
@end

/// 响应数据
@interface RespPlayerPropsCardsModel : BaseRespModel
/// 道具信息
@property (nonatomic, strong) NSString * props;
@end


@interface AiInfoModel : NSObject
@property (nonatomic, copy) NSString *aiUid;             // AI User UID (required)
@property (nonatomic, copy) NSString *aiId;              // AI ID (required)
@property (nonatomic, copy) NSString *nickname;              // AI nickname (required)

@property (nonatomic, copy) NSString *birthday;           // Birthday (required)
@property (nonatomic, copy) NSString *bloodType;          // Blood type (required)
@property (nonatomic, copy) NSString *mbti;               // MBTI (required)
@property (nonatomic, copy) NSArray<NSString *> *personalities;        // Personality traits (required)
@property (nonatomic, copy) NSArray<NSString *> *languageStyles;      // Language style (required)
@property (nonatomic, copy) NSArray<NSString *> *languageDetailStyles;      // Language style (required)
@property (nonatomic, assign) NSInteger voiceStatus;      // Voice status (required, 0: created, 1: training, 2: success, 3: failed)
@property (nonatomic, copy) NSString *demoAudioData;      // Demo audio base64 (required)
@property (nonatomic, copy) NSString *demoAudioText;      // Demo audio text (required)
@property (nonatomic, assign) NSInteger status;            // Status (required, 0: closed, 1: open)
@end

/// 响应数据
@interface RespAiCloneInfoModel : BaseRespModel
@property (nonatomic, strong, nullable) AiInfoModel *aiInfo; // AI information (optional)
@property (nonatomic, strong) NSArray<NSString *> *mbtiOptions; // MBTI options (required)
@property (nonatomic, strong) NSArray<NSString *> *personalityOptions; // Personality traits options (required)
@property (nonatomic, strong) NSArray<NSString *> *languageStyleOptions; // Language style options (required)
@property (nonatomic, strong) NSArray<NSString *> *languageDetailStyleOptions; // Detailed language style options (required)
@property (nonatomic, strong) NSArray<NSString *> *bloodTypeOptions;

@property (nonatomic, copy) NSString *audioText; // Training audio text (required)
@end


/// 响应数据
@interface RespRandAiCloneInfoModel : BaseRespModel
@property (nonatomic, assign) NSInteger userId;          // Original user UID (required)
@property (nonatomic, assign) NSInteger aiUid;            // AI user UID (required)
@property (nonatomic, copy) NSString *aiId;               // AI ID (required)
@property (nonatomic, copy) NSString *nickname;           // Nickname (required)
@property (nonatomic, copy) NSString *avatarUrl;         // Avatar URL (required)
@property (nonatomic, copy) NSString *gender;
@end

