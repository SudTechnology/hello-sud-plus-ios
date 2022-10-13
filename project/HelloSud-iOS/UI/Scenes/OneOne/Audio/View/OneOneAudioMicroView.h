//
//  AudioMicroView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^OneOneTapMicViewBlock)(AudioRoomMicModel *micModel);
typedef NS_ENUM(NSInteger, OneOneMicType) {
    OneOneAudioMic,
    OneOneGameMic,
};
/// 麦位view
@interface OneOneAudioMicroView : BaseView
@property (nonatomic, assign) CGFloat headWidth;
@property (nonatomic, assign) OneOneMicType micType;
@property (nonatomic, strong) AudioRoomMicModel *model;
/// 点击麦位回调
@property (nonatomic, copy)OneOneTapMicViewBlock onTapCallback;
@property (nonatomic, copy)void(^micUserChangedBlock)(AudioRoomMicModel *micModel);
/// 跳过游戏状态
@property (nonatomic, assign)BOOL skipGameState;
/// 切换缩放比例
/// @param isSmall isSmall
- (void)changeScale:(BOOL)isSmall;
@end

NS_ASSUME_NONNULL_END
