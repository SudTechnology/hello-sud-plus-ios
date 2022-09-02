//
//  HomeViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "BaseViewController.h"
#import "SudNFTQSNFTListCellModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 我的NFT列表控制器
@interface SudNFTQsNFTListViewController : BaseViewController
- (void)updateNFTList:(NSArray<SudNFTQSNFTListCellModel *> *)list add:(BOOL)add;
@end

NS_ASSUME_NONNULL_END
