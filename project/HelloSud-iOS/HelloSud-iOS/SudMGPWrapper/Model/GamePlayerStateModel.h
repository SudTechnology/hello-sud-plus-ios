//
//  GamePlayerStateModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/19.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 玩家状态
@interface GamePlayerStateModel : NSObject

#pragma mark - common
/// 用户userId
@property (nonatomic, copy) NSString *userId;
/// 状态类型
@property (nonatomic, copy) NSString *state;

#pragma mark - 状态重复字段
/// reason
@property (nonatomic, assign) int reason;
/// 内容
@property (nonatomic, copy) NSString *msg;

#pragma mark - 玩家: 加入状态  MG_COMMON_PLAYER_IN
/*
 {
     "isIn": true,           // true 已加入，false 未加入;
     "teamId":1,           // 加入哪支队伍;
     "reason": 0,          // 当isIn==false时有效；0 主动退出，1 被踢;（reason默认-1，无意义便于处理）
     "kickUID":""          // 当reason==1时有效；kickUID为踢人的用户uid；判断被踢的人是本人条件(onPlayerStateChange(userId==kickedUID == selfUID)；（kickUID默认""，无意义便于处理）
 }
 */
@property (nonatomic, assign) BOOL isIn;
@property (nonatomic, assign) int64_t teamId;
@property (nonatomic, copy) NSString *kickUID;

#pragma mark - 玩家: 准备状态  MG_COMMON_PLAYER_READY
/*
 {
     "isReady": true      // true 已准备，false 未准备
 }
 */
@property (nonatomic, assign) BOOL isReady;

#pragma mark - 玩家: 队长状态  MG_COMMON_PLAYER_CAPTAIN
/*
 {
     "isCaptain": true   // true 是队长，false 不是队长；
 }
 */
@property (nonatomic, assign) BOOL isCaptain;

#pragma mark - 玩家: 游戏状态  MG_COMMON_PLAYER_PLAYING
/*
 {
     "isPlaying": true,  // true 游戏中，false 未在游戏中；
     "gameRoundId": "12345699", // 本轮游戏id，当isPlaying==true时有效
     "reason": 0,           // 当isPlaying==false时有效；isPlaying=false, 0:正常结束 1:提前结束（自己不玩了）2:无真人可以提前结束（无真人，只有机器人） 3:所有人都提前结束；（reason默认-1，无意义便于处理）
     "spaceMax": true // true 建议尽量收缩原生UI，给游戏留出尽量大的操作空间 false 初始状态；
 }
 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL spaceMax;
@property (nonatomic, assign) int64_t gameRoundId;

#pragma mark - 玩家: 玩家在线状态  MG_COMMON_PLAYER_ONLINE
/*
 {
     "isOnline": true,  // true：在线，false： 离线
 }
 */
@property (nonatomic, assign) BOOL isOnline;

#pragma mark - 玩家: 玩家换游戏位状态  MG_COMMON_PLAYER_CHANGE_SEAT
/*
 {
     "preSeatIndex": 1,    // 换位前的游戏位(座位号)
     "currentSeatIndex": 1,        // 换位成功后的游戏位(座位号)
 }
*/
@property (nonatomic, assign) int preSeatIndex;
@property (nonatomic, assign) int currentSeatIndex;

#pragma mark - 玩家: 选词中状态  MG_DG_SELECTING
/*
 {
     "isSelecting": true    // bool 类型 true：正在选词中，false: 不在选词中
 }
*/
@property (nonatomic, assign) BOOL isSelecting;

#pragma mark - 玩家: 作画中状态  MG_DG_PAINTING
/*
 {
     isPainting: true // true: 绘画中，false: 取消绘画
 }
*/
@property (nonatomic, assign) BOOL isPainting;

#pragma mark - 玩家: 显示错误答案状态  MG_DG_ERRORANSWER
/*
 {
     "msg": "错误答案" // 字符串类型，展示错误答案
 }
*/

#pragma mark - 玩家: 显示总积分状态  MG_DG_TOTALSCORE
/*
 {
     "msg": "10" // 字符串类型 总积分
 }
*/

#pragma mark - 玩家: 本次获得积分状态  MG_DG_SCORE
/*
 {
     "msg": "10"    // string类型，展示本次获得积分
 }
*/

#pragma mark - 游戏状态  MG_COMMON_GAME_STATE
/*
 {
     "gameState": 0    // 0 = 空闲 1 = loading 2 = playing
 }
*/
@property (nonatomic, assign) NSInteger gameState;

@end

NS_ASSUME_NONNULL_END
