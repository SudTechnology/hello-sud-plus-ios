//
//  HSAudioMsgConst.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#ifndef HSAudioMsgConst_h
#define HSAudioMsgConst_h

#define CMD_CHAT_TEXT_NOTIFY          10000 /// 公屏消息
#define CMD_SEND_GIFT_NOTIFY          10001 /// 发送礼物
#define CMD_UP_MIC_NOTIFY             10002 /// 上麦
#define CMD_DOWN_MIC_NOTIFY           10003 /// 下麦
#define CMD_CHANGE_GAME_NOTIFY        10004 /// 游戏切换
#define CMD_ENTER_ROOM_NOTIFY         10005 /// 用户进入房间通知
#define CMD_KICK_OUT_ROOM             10006 /// 踢出房间
#define CMD_ROOM_PK_SEND_INVITE	      10100	/// 1.3.0 发送跨房PK邀请
#define CMD_ROOM_PK_ANSWER	          10101	/// 1.3.0 跨房PK邀请应答
#define CMD_ROOM_PK_START	          10102	/// 1.3.0 开始跨房PK
#define CMD_ROOM_PK_FINISH	          10103	/// 1.3.0 结束跨房PK
#define CMD_ROOM_PK_SETTINGS	      10104	/// 1.3.0 跨房PK设置
#define CMD_ROOM_PK_OPEN_MATCH	      10105	/// 1.3.0 开启匹配跨房PK
#define CMD_ROOM_PK_CHANGE_GAME	      10106	/// 1.3.0 跨房PK，切换游戏
#define CMD_ROOM_PK_REMOVE_RIVAL	  10107	/// 1.3.0	跨房PK，移除对手
#define CMD_ROOM_PK_AGAIN	          10108	/// 1.3.0	重新PK
#define CMD_ROOM_ORDER_USER           10200 /// 用户发起点单
#define CMD_ROOM_ORDER_OPERATE        10201 /// 主播同意或者拒绝，发出点单结果
#define CMD_ROOM_QUIZ_BET	          10300	/// 1.4.0	竞猜下注通知
#define CMD_ROOM_DISCO_INFO_REQ	      10400	/// 1.4.0	请求蹦迪信息
#define CMD_ROOM_DISCO_INFO_RESP	  10401	/// 1.4.0	响应蹦迪信息
#define CMD_ROOM_DISCO_BECOME_DJ	  10402	/// 1.4.0	上DJ台
#define CMD_ROOM_DISCO_ACTION_PAY     10403 /// 1.4.2 蹦迪动作付费
#define CMD_ROOM_3D_SEND_FACE_NOTIFY  10700	/// 1.6.7	3D语聊房发送表情通知

#pragma mark 后台通知信令

#define CMD_ROOM_PK_GAME_SETTLE_NOTIFY	             20000 /// 跨房pk游戏结算消息
#define CMD_ROOM_PK_CLOSE_NOTIFY	                 20001 /// 跨房pk对手房间关闭消息
#define CMD_GAME_EXTRA_JOIN_TEAM_NOTIFY              21000 /// 1.6.1    跨域加入组队消息
#define CMD_GAME_EXTRA_MATCH_USERS_CHANGED_NOTIFY    21001 /// 1.6.1    跨域匹配人数变更通知
#define CMD_GAME_EXTRA_MATCH_STATUS_CHANGED_NOTIFY   21002 /// 1.6.1    跨域匹配状态变更通知
#define CMD_GAME_EXTRA_TEAM_CHANGED_NOTIFY	         21003 /// 1.6.1	跨域匹配队伍变更通知
#define CMD_GAME_EXTRA_GAME_SWITCH_NOTIFY	         21004 /// 1.6.1跨域匹配游戏切换通知
#define CMD_GAME_BULLET_JOIN_TEAM_NOTIFY	         21006 /// 1.6.1弹幕游戏加入战队通知

#define CMD_ROOM_GIFT_VALUES_CHANGE_NOTIFY_V2	     21010 /// 1.6.6 3d语聊房心动值变更
#define CMD_ROOM_3D_CONFIG_CHANGE_NOTIFY	         21011 /// 1.6.6 3D语聊房配置变更
#define CMD_ROOM_3D_MIC_STATE_CHANGE_NOTIFY	         21012 /// 1.6.6 3D语聊房麦位状态变更
#define CMD_GAME_MONOPOLY_CARD_GIFT_NOTIFY           22001 /// 1.6.9 大富翁道具卡送礼通知
#define CMD_GAME_PROPS_CARD_GIFT_NOTIFY              22002 /// 1.6.9 游戏道具卡送礼通知
#endif /* HSAudioMsgConst_h */
