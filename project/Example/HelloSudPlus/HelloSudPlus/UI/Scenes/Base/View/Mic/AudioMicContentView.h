//
//  AudioMicContentView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"
#import "AudioMicroView.h"

NS_ASSUME_NONNULL_BEGIN
/// 语音房麦位视图
@interface AudioMicContentView : BaseView

@property (nonatomic, weak) SudFSMMGDecorator *iSudFSMMG;

typedef void(^OnUpdateMicArrCallBack)(NSArray <AudioMicroView *> *micArr);
@property (nonatomic, copy) OnUpdateMicArrCallBack updateMicArrCallBack;
@property (nonatomic, copy) NSMutableArray <AudioMicroView *> *micArr;

/// 点击麦位回调
@property (nonatomic, copy)TapMicViewBlock onTapCallback;
@end

NS_ASSUME_NONNULL_END
