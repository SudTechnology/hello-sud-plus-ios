//
//  SudMGPMGState.m
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import "SudMGPMGState.h"

@implementation GamePublicText
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
            @"degf": @"default",
            @"en_GB": @"en-GB",
            @"en_US": @"en-US",
            @"ms_BN": @"ms-BN",
            @"ms_MY": @"ms-MY",
            @"zh_CN": @"zh-CN",
            @"zh_HK": @"zh-HK",
            @"zh_MO": @"zh-MO",
            @"zh_SG": @"zh-SG",
            @"zh_TW": @"zh-TW",

            @"vi_VN": @"vi-VN",
            @"th_TH": @"th-TH",
            @"ko_KR": @"ko-KR",
            @"ja_JP": @"ja-JP",
            @"es_ES": @"es-ES",
            @"id_ID": @"id-ID",
            @"ar_SA": @"ar-SA",
            @"tr_TR": @"tr-TR",
            @"ur_PK": @"ur-PK",
    };
}
@end

@implementation GamePublicUser

@end

@implementation GamePublicMsg

@end

@implementation MGCommonPublicMessageModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"msg": [GamePublicMsg class]
    };
}
@end


@implementation MGCommonKeyWrodToHitModel

@end


@implementation MGCommonGameSettleResults

@end

@implementation MGCommonGameSettleModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"results": [MGCommonGameSettleResults class]
    };
}
@end


@implementation MGCommonSelfClickJoinBtn

@end

@implementation MGCommonSelfClickCancelJoinBtn

@end

@implementation MGCommonSelfClickReadyBtn

@end

@implementation MGCommonSelfClickCancelReadyBtn

@end

@implementation MGCommonSelfClickStartBtn

@end

@implementation MGCommonSelfClickShareBtn

@end

@implementation MGCommonGameState

@end

@implementation MGCommonSelfClickGameSettleCloseBtn

@end

@implementation MGCommonSelfClickGameSettleAgainBtn

@end

@implementation MGCommonGameSoundList

@end

@implementation MGCommonGameSoundListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": [MGCommonGameSoundList class]
    };
}
@end

@implementation MGCommonGameSound

@end

@implementation MGCommonGameBgMusicState

@end

@implementation MGCommonGameSoundState

@end

@implementation MGCommonGameASRModel

@end

@implementation MGCommonGameSelfMicrophone

@end

@implementation MGCommonGameSelfHeadphone

@end


@implementation MGCommonPlayerInModel

@end

@implementation MGCommonPlayerReadyModel

@end

@implementation MGCommonPlayerCaptainModel

@end

@implementation MGCommonPlayerPlayingModel

@end

@implementation MGCommonPlayerOnlineModel

@end

@implementation MGCommonPlayerChangeSeatModel

@end

@implementation MGCommonSelfClickGamePlayerIconModel

@end


@implementation MGDGSelectingModel

@end

@implementation MGDGPaintingModel

@end

@implementation MGDGErrorAnswerModel

@end

@implementation MGDGTotalScoreModel

@end

@implementation MGDGScoreModel

@end

@implementation MGCommonSelfDieStatusModel
@end

@implementation MGCommonSelfTurnStatusModel
@end

@implementation MGCommonSelfSelectStatusModel
@end

@implementation MGCommonGameCountdownTimeModel
@end

@implementation MGCommonGameDiscoActionModel
@end

@implementation MGCommonGameDiscoActionEndModel
@end

@implementation MGCommonAppCommonSelfXRespModel
@end

@implementation MGCommonGameAddAIPlayersModel
@end

@implementation MGCommonGameNetworkStateModel
@end

@implementation MGCommonGameScoreModel
@end

@implementation MGCommonGameSetScoreModel
@end