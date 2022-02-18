//
//  APPCommonPlayerModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/18.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 玩家: 加入状态  MG_COMMON_PLAYER_IN
@interface MGCommonPlayerInModel : BaseModel
/// true 已加入，false 未加入;
@property (nonatomic, assign) BOOL isIn;
/// 加入哪支队伍;
@property (nonatomic, assign) int64_t teamId;
/// 当isIn==false时有效；0 主动退出，1 被踢;（reason默认-1，无意义便于处理）
@property (nonatomic, copy) NSString *kickUID;
/// 当reason==1时有效；kickUID为踢人的用户uid；判断被踢的人是本人条件(onPlayerStateChange(userId==kickedUID == selfUID)；（kickUID默认""，无意义便于处理）
@property (nonatomic, assign) int reason;
@end


#pragma mark - 玩家: 准备状态  MG_COMMON_PLAYER_READY
@interface MGCommonPlayerReadyModel : BaseModel
/// true 已准备，false 未准备
@property (nonatomic, assign) BOOL isReady;
@end


#pragma mark - 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
@interface MGCommonPlayerCaptainModel : BaseModel
/// true 是队长，false 不是队长；
@property (nonatomic, assign) BOOL isCaptain;
@end


#pragma mark - 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
@interface MGCommonPlayerPlayingModel : BaseModel
/// true 游戏中，false 未在游戏中；
@property (nonatomic, assign) BOOL isPlaying;
/// 本轮游戏id，当isPlaying==true时有效
@property (nonatomic, assign) int64_t gameRoundId;
/// 当isPlaying==false时有效；isPlaying=false, 0:正常结束 1:提前结束（自己不玩了）2:无真人可以提前结束（无真人，只有机器人） 3:所有人都提前结束；（reason默认-1，无意义便于处理）
@property (nonatomic, assign) int reason;
/// true 建议尽量收缩原生UI，给游戏留出尽量大的操作空间 false 初始状态；
@property (nonatomic, assign) BOOL spaceMax;
@end


#pragma mark - 玩家: 玩家在线状态  MG_COMMON_PLAYER_ONLINE
@interface MGCommonPlayerOnlineModel : BaseModel
/// true：在线，false： 离线
@property (nonatomic, assign) BOOL isOnline;
@end


#pragma mark - 玩家: 玩家换游戏位状态  MG_COMMON_PLAYER_CHANGE_SEAT
@interface MGCommonPlayerChangeSeatModel : BaseModel
/// 换位前的游戏位(座位号)
@property (nonatomic, assign) int preSeatIndex;
/// 换位成功后的游戏位(座位号)
@property (nonatomic, assign) int currentSeatIndex;
@end


#pragma mark - 玩家: 游戏通知app点击玩家头像  MG_COMMON_SELF_CLICK_GAME_PLAYER_ICON
@interface MGCommonSelfClickGamePlayerIconModel : BaseModel
/// 被点击头像的用户id
@property (nonatomic, copy) NSString *uid;
@end

NS_ASSUME_NONNULL_END
