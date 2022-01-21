//
//  BaseAlertView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"
#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseAlertView : BaseView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *customView;

typedef void(^OnCloseViewCallBack)(void);
@property (nonatomic, copy) OnCloseViewCallBack onCloseViewCallBack;

/// 展示弹窗
- (void)show;

/// 关闭弹窗
- (void)close;

@end

static BaseAlertView *h_alertView = nil;
NS_ASSUME_NONNULL_END
