//
//  RoomMsgTableView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"
#import "CommonAudioModelHeader.h"

NS_ASSUME_NONNULL_BEGIN

/// 公屏视图
@interface RoomMsgTableView : BaseView
/// 展示公屏消息
/// @param msg 消息体
- (void)addMsg:(RoomBaseCMDModel *)msg;

/// 展示公屏消息
/// @param msg 消息体
- (void)addMsgList:(NSArray<RoomBaseCMDModel *> *)msgList;
@end

NS_ASSUME_NONNULL_END
