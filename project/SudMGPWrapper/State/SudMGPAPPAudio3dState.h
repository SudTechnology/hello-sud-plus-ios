//
//  SudMGPAPPState2.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/19.
//

#pragma mark - 3d语聊房<火箭>

/// 设置房间配置
static NSString *APP_CUSTOM_CR_SET_ROOM_CONFIG = @"app_custom_cr_set_room_config";
/// 设置主播位数据
static NSString *APP_CUSTOM_CR_SET_SEATS = @"app_custom_cr_set_seats";
/// 播放收礼效果
static NSString *APP_CUSTOM_CR_PLAY_GIFT_EFFECT = @"app_custom_cr_play_gift_effect";
/// 通知播放爆灯特效
static NSString *APP_CUSTOM_CR_SET_LIGHT_FLASH = @"app_custom_cr_set_light_flash";
/// 通知主播播放指定动作
static NSString *APP_CUSTOM_CR_PLAY_ANIM = @"app_custom_cr_play_anim";
/// 通知麦浪值变化
static NSString *APP_CUSTOM_CR_MICPHONE_VALUE_SEAT = @"app_custom_cr_micphone_value_seat";
/// 通知暂停或恢复立方体自转
static NSString *APP_CUSTOM_CR_PAUSE_ROTATE = @"app_custom_cr_pause_rotate";


#pragma mark - 3d语聊房 model

/// 设置房间配置数据模型
@interface AppCustomCrSetRoomConfigModel : NSObject
/// 立方体是否自转  0:不旋转 1：旋转
@property(nonatomic, assign) NSInteger platformRotate;
///// 立方体自转方向 0:从右往左转  1:从左往右转
@property(nonatomic, assign) NSInteger rotateDir;
/// 立方体自转速度（整形类型）0:使用默认速度每秒6度  x>0:每秒旋转x度
@property(nonatomic, assign) NSInteger rotateSpeed;
/// 音乐控制  0:关  1:开
@property(nonatomic, assign) NSInteger gameMusic;
/// 音效控制  0:关  1:开
@property(nonatomic, assign) NSInteger gameSound;
/// 是否开启爆灯边框效果  0:关  1:开
@property(nonatomic, assign) NSInteger flashVFX;
/// 是否开启麦浪边框效果  0:关  1:开
@property(nonatomic, assign) NSInteger micphoneWave;
/// 是否显示心动值  0:隐藏  1:显示
@property(nonatomic, assign) NSInteger showGiftValue;
@end

/// 麦位数据模型
@interface AppCustomCrSeatItemModel : NSObject
typedef NS_ENUM(NSInteger, AppCustomCrSeatItemModelType) {
    AppCustomCrSeatItemModelTypeHasUser = 1,
    AppCustomCrSeatItemModelTypeEmpty = 2,
    AppCustomCrSeatItemModelTypeLocked = 3
};

/// 0~4一共5个麦位，0为老板位，1~4为四个面主播位
@property(nonatomic, assign) NSInteger seatIndex;
/// 四个面场景等级 0~2
@property(nonatomic, assign) NSInteger level;
/// 麦位状态  1:有人  2:空位  3:麦位被锁
@property(nonatomic, assign) AppCustomCrSeatItemModelType microState;
/// 当前麦位用户id（如果有）
@property(nonatomic, strong) NSString *userId;
/// 性别  0:男  1:女
@property(nonatomic, assign) NSInteger gender;
/// 名字
@property(nonatomic, strong) NSString *name;
/// 头像链接
@property(nonatomic, strong) NSString *photoUrl;
/// 麦克风状态  -1:禁麦  0:闭麦  1:开麦
@property(nonatomic, assign) NSInteger micphoneState;
/// 心动值
@property(nonatomic, assign) NSInteger giftValue;
@end

/// 设置主播位数据
@interface AppCustomCrSetSeatsModel : NSObject
@property(nonatomic, strong) NSArray <AppCustomCrSeatItemModel *> *seats;
@end

@interface AppCustomCrPlayGiftItemModel : NSObject
/// 0~4一共5个麦位，0为老板位，1~4为四个面主播位
@property(nonatomic, assign) NSInteger seatIndex;
/// 礼物档位，1 ~ 30
@property(nonatomic, assign) NSInteger level;
/// 礼物数量
@property(nonatomic, assign) NSInteger count;
@end

/// 播放收礼效果
@interface AppCustomCrPlayGiftEffectModel : NSObject
/// 送礼人的userId
@property(nonatomic, strong) NSString *giverUserId;
/// 是否全麦，0 非全麦 1全麦
@property(nonatomic, assign)BOOL isAllSeat;
/// 礼物列表，可送给一个或者多个主播
@property(nonatomic, strong) NSArray <AppCustomCrPlayGiftItemModel *> *giftList;
@end

@interface AppCustomCrSetLightFlashModel : NSObject
/// 0~4一共5个麦位，0为老板位，1~4为四个面主播位
@property(nonatomic, assign) NSInteger seatIndex;
@end

/// 通知主播播放指定动作
@interface AppCustomCrPlayAnimModel : NSObject
/// 0~4一共5个麦位，0为老板位，1~4为四个面主播位
@property(nonatomic, assign) NSInteger seatIndex;
/// 动作id 1:跳舞 2:飞吻 3:感谢 4:鼓掌 5:害羞 6:欢呼 7:伤心 8:生气
@property(nonatomic, assign) NSInteger animId;
@end

/// 通知麦浪值变化
@interface AppCustomCrMicphoneValueSeatModel : NSObject
/// 0~4一共5个麦位，0为老板位，1~4为四个面主播位
@property(nonatomic, assign) NSInteger seatIndex;
/// 麦浪值，请映射到区间0~100
@property(nonatomic, assign) NSInteger value;
@end

/// 通知暂停或恢复立方体自转
@interface AppCustomCrPauseRotateModel : NSObject
// 0:恢复自转  1：暂停自转
@property(nonatomic, assign) NSInteger pause;
@end
