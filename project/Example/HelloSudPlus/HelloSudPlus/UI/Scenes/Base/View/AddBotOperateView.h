//
//  AddBotOperateView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 添加机器人
@interface AddBotOperateView : BaseView
@property(nonatomic, copy)void(^operateCallback)(NSInteger tag);
@property(nonatomic, copy)UIBUTTON_TAP_BLOCK cancelCallback;

@end

NS_ASSUME_NONNULL_END
