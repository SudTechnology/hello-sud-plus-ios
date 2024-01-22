//
//  GameListTableViewCell.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameListTableViewCell : BaseTableViewCell
@property (nonatomic, strong, readonly) UIImageView *iconImageView;
@property (nonatomic, strong, readonly) UIButton *enterRoomBtn;
@end

NS_ASSUME_NONNULL_END
