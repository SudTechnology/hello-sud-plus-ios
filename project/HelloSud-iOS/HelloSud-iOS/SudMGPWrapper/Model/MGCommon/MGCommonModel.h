//
//  MGCommonModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 通用状态-游戏: 加入游戏按钮点击状态   MG_COMMON_SELF_CLICK_JOIN_BTN
@interface MGCommonSelfClickJoinBtnModel : BaseModel
/// 点击头像加入游戏对应的座位号，int 类型，从0开始
@property (nonatomic, assign) NSInteger seatIndex;
@end


/// 通用状态-游戏: 取消加入游戏按钮点击状态   MG_COMMON_SELF_CLICK_CANCEL_JOIN_BTN
@interface MGCommonSelfClickCancelJoinBtnModel : BaseModel

@end


/// 通用状态-游戏: 准备按钮点击状态   MG_COMMON_SELF_CLICK_READY_BTN
@interface MGCommonSelfClickReadyBtnModel : BaseModel

@end


/// 通用状态-游戏: 取消准备按钮点击状态   MG_COMMON_SELF_CLICK_CANCEL_READY_BTN
@interface MGCommonSelfClickCancelReadyBtnModel : BaseModel

@end


/// 通用状态-游戏: 开始游戏按钮点击状态   MG_COMMON_SELF_CLICK_START_BTN
@interface MGCommonSelfClickStartBtnModel : BaseModel

@end


/// 通用状态-游戏: 分享按钮点击状态   MG_COMMON_SELF_CLICK_SHARE_BTN
@interface MGCommonSelfClickShareBtnModel : BaseModel

@end


/// 通用状态-游戏: 游戏状态   MG_COMMON_GAME_STATE
@interface MGCommonGameStateModel : BaseModel
/// gameState=0 (idle 状态，游戏未开始，空闲状态）；gameState=1 （loading 状态，所有玩家都准备好，队长点击了开始游戏按钮，等待加载游戏场景开始游戏，游戏即将开始提示阶段）；gameState=2（playing状态，游戏进行中状态）
@property (nonatomic, assign) NSInteger gameState;
@end


/// 通用状态-游戏: 结算界面关闭按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_CLOSE_BTN
@interface MGCommonSelfClickGameSettleCloseBtnModel : BaseModel

@end


/// 通用状态-游戏: 结算界面再来一局按钮点击状态   MG_COMMON_SELF_CLICK_GAME_SETTLE_AGAIN_BTN
@interface MGCommonSelfClickGameSettleAgainBtnModel : BaseModel

@end


/// 通用状态-游戏: 游戏通知app层播放声音   MG_COMMON_GAME_SOUND
@interface MGCommonGameSoundModel : BaseModel
/// 要播放的声音文件名，不带后缀
@property (nonatomic, copy) NSString *name;
/// 声音资源的URL链接
@property (nonatomic, copy) NSString *url;
/// 声音资源类型
@property (nonatomic, copy) NSString *type;
/// 是否播放 isPlay==true(播放)，isPlay==false(停止)
@property (nonatomic, assign) BOOL isPlay;
/// 播放次数；注：times == 0 为循环播放
@property (nonatomic, assign) NSInteger times;
@end


/// 通用状态-游戏: 游戏通知app层播放背景音乐状态   MG_COMMON_GAME_BG_MUSIC_STATE
@interface MGCommonGameBgMusicStateModel : BaseModel
/// 背景音乐的开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL isPlay;
@end


/// 通用状态-游戏: 游戏通知app层播放音效的状态   MG_COMMON_GAME_SOUND_STATE
@interface MGCommonGameSoundStateModel : BaseModel
/// 背景音乐的开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL state;
@end


/// 通用状态-游戏: 麦克风状态   MG_COMMON_GAME_SELF_MICROPHONE
@interface MGCommonGameSelfMicrophoneModel : BaseModel
/// 麦克风开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL isOn;
@end


/// 通用状态-游戏: 耳机（听筒，扬声器）状态   MG_COMMON_GAME_SELF_HEADEPHONE
@interface MGCommonGameSelfHeadphoneModel : BaseModel
/// 耳机（听筒，喇叭）开关状态 true: 开，false: 关
@property (nonatomic, assign) BOOL isOn;
@end









NS_ASSUME_NONNULL_END
