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
@end

NS_ASSUME_NONNULL_END
