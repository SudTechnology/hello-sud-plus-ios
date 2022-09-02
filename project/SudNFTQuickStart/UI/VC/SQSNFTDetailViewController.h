//
//  HomeViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "BaseViewController.h"
#import "SQSNFTListCellModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 我的NFT详情控制器
@interface SQSNFTDetailViewController : BaseViewController
@property (nonatomic, strong)SQSNFTListCellModel *cellModel;
@end

NS_ASSUME_NONNULL_END
