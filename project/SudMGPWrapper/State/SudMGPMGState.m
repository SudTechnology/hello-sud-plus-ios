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

@implementation MGCommonGameGetScoreModel
@end

@implementation MGCommonGameSetScoreModel
@end

@implementation MgCommonSelfObStatusModel
@end

@implementation MgCommonGameCreateOrderModel
@end

@implementation MgCommonUsersInfoModel
@end

@implementation MgCommonSetClickRectItem
@end

@implementation MgCommonSetClickRect
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": [MgCommonSetClickRectItem class]
    };
}
@end

@implementation MgCommonPlayerRoleIdItem
@end

@implementation MgCommonPlayerRoleIdModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"playersRoleId": [MgCommonPlayerRoleIdItem class]
    };
}
@end

@implementation MgCommonSelfClickGoldBtnModel
@end

@implementation MgCommonGamePieceArriveEndModel
@end

@implementation MgCommonGamePlayerManagedStateModel
@end

@implementation MgCommonGameSendBurstWordModel
@end

@implementation MgCommonGamePlayerMonopolyCardsModel
@end

#pragma mark - MG_COMMON_GAME_PLAYER_RANKS
@implementation MgCommonGamePlayerRanksItem
@end

@implementation MgCommonGamePlayerRanksModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"ranks": [MgCommonGamePlayerRanksItem class]
    };
}
@end

#pragma mark - MG_COMMON_GAME_PLAYER_PAIR_SINGULAR
@implementation MgCommonGamePlayerPairSingularItem
@end

@implementation MgCommonGamePlayerPairSingularModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"pairs": [MgCommonGamePlayerPairSingularItem class]
    };
}
@end

#pragma mark - MG_COMMON_GAME_PLAYER_SCORES
@implementation MgCommonGamePlayerScoresItem
@end

@implementation MgCommonGamePlayerScoresModel : NSObject
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"scores": [MgCommonGamePlayerScoresItem class]
    };
}
@end


#pragma mark - MG_COMMON_GAME_UI_CUSTOM_CONFIG
@implementation MgCommonGameUiCustomConfigModel
@end

#pragma mark - MG_COMMON_GAME_MONEY_NOT_ENOUGH
@implementation MgCommonGameMoneyNotEnoughModel
@end
#pragma mark - MG_COMMON_GAME_SETTINGS
@implementation MgCommonGameSettingsModel
@end
#pragma mark - MG_COMMON_GAME_RULE
@implementation MgCommonGameRuleGameModeModel

@end
@implementation MgCommonGameRuleModel
@end
#pragma mark - MG_COMMON_GAME_IS_APP_CHIP
@implementation MgCommonGameIsAppChipModel

@end
#pragma mark - MG_COMMON_SELF_CLICK_EXIT_GAME_BTN
@implementation MgCommonSelfClickExitGameBtnModel

@end
#pragma mark - MG_COMMON_GAME_PLAYER_ICON_POSITION
@implementation MgFrameRectModel
@end

@implementation MgCommonGamePlayerIconPositionModel
@end

#pragma mark - MG_COMMON_GAME_PLAYER_COLOR
@implementation MgCommonGamePlayerColorItem
@end

@implementation MgCommonGamePlayerColorModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"players": [MgCommonGamePlayerColorItem class]
    };
}

@end
#pragma mark - MG_COMMON_GAME_OVER_TIP
@implementation MgCommonGameOverTipModel
@end
#pragma mark - MG_COMMON_WORST_TEAMMATE
@implementation MgCommonWorstTeammateModel
@end
#pragma mark - MG_COMMON_ALERT
@implementation MgCommonAlertModel
@end
#pragma mark - MG_COMMON_GAME_FPS
@implementation MgCommonGameFpsModel
@end
#pragma mark - MG_COMMON_SELF_CLICK_GOOD
@implementation MgCommonSelfClickGoodModel

@end
#pragma mark - MG_COMMON_SELF_CLICK_POOP
@implementation MgCommonSelfClickPoopModel

@end


