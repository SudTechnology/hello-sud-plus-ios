//
//  MicOperateView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 麦位操作
@interface MicOperateView : BaseView
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK downMicCallback;
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK cancelCallback;
@end

NS_ASSUME_NONNULL_END
