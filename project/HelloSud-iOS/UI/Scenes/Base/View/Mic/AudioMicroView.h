//
//  AudioMicroView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TapMicViewBlock)(AudioRoomMicModel *micModel);

typedef NS_ENUM(NSInteger, MicType) {
    HSAudioMic,
    HSGameMic,
};
/// 麦位view
@interface AudioMicroView : BaseView
@property (nonatomic, weak) SudFSMMGDecorator *iSudFSMMG;

@property (nonatomic, assign) CGFloat headWidth;
@property (nonatomic, assign) MicType micType;
@property (nonatomic, strong) AudioRoomMicModel *model;
/// 点击麦位回调
@property (nonatomic, copy)TapMicViewBlock onTapCallback;
/// 切换缩放比例
/// @param isSmall isSmall
- (void)changeScale:(BOOL)isSmall;
@end

NS_ASSUME_NONNULL_END
