//
//  HSRoomMsgTableView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"
#import "CommonAudioMsgModelHeader.h"
NS_ASSUME_NONNULL_BEGIN
/// 公屏视图
@interface HSRoomMsgTableView : BaseView
/// 展示公屏消息
/// @param msg 消息体
- (void)showMsg:(HSAudioMsgBaseModel *)msg;
@end

NS_ASSUME_NONNULL_END
