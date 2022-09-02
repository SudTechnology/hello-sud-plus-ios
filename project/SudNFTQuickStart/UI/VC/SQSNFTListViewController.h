//
//  HomeViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "BaseViewController.h"
#import "SQSNFTListCellModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 我的NFT列表控制器
@interface SQSNFTListViewController : BaseViewController
- (void)updateNFTList:(NSArray<SQSNFTListCellModel *> *)list add:(BOOL)add;
@end

NS_ASSUME_NONNULL_END
