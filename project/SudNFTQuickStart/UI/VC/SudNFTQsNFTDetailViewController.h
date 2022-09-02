//
//  HomeViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "BaseViewController.h"
#import "SudNFTQSNFTListCellModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 我的NFT详情控制器
@interface SudNFTQsNFTDetailViewController : BaseViewController
@property (nonatomic, strong)SudNFTQSNFTListCellModel *cellModel;
@end

NS_ASSUME_NONNULL_END
