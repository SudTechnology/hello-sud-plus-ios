//
//  HSGameMicContentView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseView.h"
#import "HSAudioMicroView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSGameMicContentView : BaseView
typedef void(^OnUpdateMicArrCallBack)(NSArray <HSAudioMicroView *> *micArr);
@property (nonatomic, copy) OnUpdateMicArrCallBack updateMicArrCallBack;
@property (nonatomic, copy) NSMutableArray <HSAudioMicroView *> *micArr;
/// 点击麦位回调
@property (nonatomic, copy)TapMicViewBlock onTapCallback;
@end

NS_ASSUME_NONNULL_END
