//
//  HSTextAlertView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSTextAlertView : BaseView

typedef void(^OnCloseViewCallBack)(void);
typedef void(^OnSureViewCallBack)(void);
@property (nonatomic, copy) OnCloseViewCallBack onCloseViewCallBack;
@property (nonatomic, copy) OnSureViewCallBack onSureViewCallBack;

@end

NS_ASSUME_NONNULL_END
