//
//  HSBaseMsgCell.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSBaseMsgCell : BaseTableViewCell
@property (nonatomic, strong) UIView *msgContentView;
@property (nonatomic, strong) YYLabel *msgLabel;
@end

NS_ASSUME_NONNULL_END
