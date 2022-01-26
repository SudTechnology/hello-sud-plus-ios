//
//  HSAudioMicroView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapMicViewBlock)(HSAudioRoomMicModel *micModel);

/// 麦位view
@interface HSAudioMicroView : BaseView

typedef NS_ENUM(NSInteger, MicType) {
    HSAudioMic,
    HSGameMic,
};
@property (nonatomic, assign) MicType micType;
@property (nonatomic, strong)HSAudioRoomMicModel *model;
/// 点击麦位回调
@property (nonatomic, copy)TapMicViewBlock onTapCallback;
@end

NS_ASSUME_NONNULL_END
