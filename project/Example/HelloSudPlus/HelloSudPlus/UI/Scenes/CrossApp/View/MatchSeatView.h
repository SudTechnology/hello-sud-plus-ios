//
//  SwitchRoomModeView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 匹配座位视图
@interface MatchSeatView : BaseView
@property(nonatomic, assign) NSInteger index;
@property (nonatomic, copy)void(^clickBlock)(NSInteger index);

- (instancetype)initWithIconWidth:(CGFloat)iconWidth;

- (void)updateUser:(HSUserInfoModel *)userModel isCaptain:(BOOL)isCaptain;

- (BOOL)isExistUser;
@end

NS_ASSUME_NONNULL_END
