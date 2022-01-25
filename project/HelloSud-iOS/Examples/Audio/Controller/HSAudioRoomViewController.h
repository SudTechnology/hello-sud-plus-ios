//
//  HSAudioRoomViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseViewController.h"
#import "MediaAudioEngineManager.h"
#import "CommonAudioMsgModelHeader.h"
NS_ASSUME_NONNULL_BEGIN

/// 语音房间场景
@interface HSAudioRoomViewController : BaseViewController<MediaAudioEventHandler>
@property(nonatomic, copy)NSString *roomID;

/// 展示公屏消息
/// @param msg 消息体
- (void)addMsg:(HSAudioMsgBaseModel *)msg;
@end

NS_ASSUME_NONNULL_END
