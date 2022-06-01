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

#pragma mark 后台通知信令

#define CMD_ROOM_PK_GAME_SETTLE_NOTIFY	20000 /// 跨房pk游戏结算消息
#define CMD_ROOM_PK_CLOSE_NOTIFY	    20001 /// 跨房pk对手房间关闭消息
#endif /* HSAudioMsgConst_h */
