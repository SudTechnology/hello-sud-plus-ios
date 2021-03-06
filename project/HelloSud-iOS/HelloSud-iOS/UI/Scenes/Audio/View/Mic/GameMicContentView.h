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
@end

NS_ASSUME_NONNULL_END
