//
//  SudMGPAPPState.m
//  SudMGPWrapper
//
//  Created by kaniel on 2022/7/4.
//

#import "SudMGPAPPAudio3dState.h"
#import <MJExtension/MJExtension.h>

/// 设置房间配置数据模型
@implementation AppCustomCrSetRoomConfigModel
@end

/// 麦位数据模型
@implementation AppCustomCrSeatItemModel
@end

/// 设置主播位数据
@implementation AppCustomCrSetSeatsModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"seats": AppCustomCrSeatItemModel.class};
}
@end

@implementation AppCustomCrPlayGiftItemModel
@end

/// 播放收礼效果
@implementation AppCustomCrPlayGiftEffectModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"giftList": AppCustomCrPlayGiftItemModel.class};
}
@end

@implementation AppCustomCrSetLightFlashModel
@end

/// 通知主播播放指定动作
@implementation AppCustomCrPlayAnimModel
@end

/// 通知麦浪值变化
@implementation AppCustomCrMicphoneValueSeatModel
@end

/// 通知暂停或恢复立方体自转
@implementation AppCustomCrPauseRotateModel
@end
