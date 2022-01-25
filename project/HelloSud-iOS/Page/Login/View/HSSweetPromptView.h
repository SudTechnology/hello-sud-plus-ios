//
//  HSSweetPromptView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSSweetPromptView : BaseView
@property (nonatomic, copy) UIBUTTON_TAP_BLOCK agreeTapBlock;
@property (nonatomic, copy) UIBUTTON_TAP_BLOCK exitTapBlock;

@end

NS_ASSUME_NONNULL_END
