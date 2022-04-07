//
//  GameItemCollectionViewCell.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/// 游戏item cell
@interface GameItemCollectionViewCell: BaseCollectionViewCell
@property (nonatomic, strong) UILabel *inGameLabel;
@property (nonatomic, assign) NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
