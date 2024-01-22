//
//  GameMicContentView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseView.h"
#import "AudioMicroView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameMicContentView : BaseView

@property (nonatomic, weak) SudFSMMGDecorator *iSudFSMMG;

typedef void(^OnUpdateMicArrCallBack)(NSArray <AudioMicroView *> *micArr);
@property (nonatomic, copy) OnUpdateMicArrCallBack updateMicArrCallBack;
@property (nonatomic, copy) NSMutableArray <AudioMicroView *> *micArr;
/// 点击麦位回调
@property (nonatomic, copy)TapMicViewBlock onTapCallback;
/// 切换缩放
@property (nonatomic, copy)void(^changeScaleBlock)(BOOL);

/// 切换到小图模式
- (void)switchToSmallView;
/// 缩放到小视图
- (void)scaleToSmallView;
/// 缩放到大视图
- (void)scaleToBigView;
/// 展示小视图状态
- (void)showSmallState;
/// 展示大视图状态
- (void)showBigState;
@end

NS_ASSUME_NONNULL_END
