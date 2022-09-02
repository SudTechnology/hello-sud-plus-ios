//
//  GuessResultTableViewCell.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/// 国内钱包选择cell
@interface SQSCnWalletSelectCell : BaseTableViewCell
@property(nonatomic, copy) void (^selectedWalletBlock)(SudNFTWalletInfoModel *walletInfoModel);
@end

NS_ASSUME_NONNULL_END
