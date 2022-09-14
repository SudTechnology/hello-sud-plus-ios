//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 国内钱包选择
@interface CNWalletSelectPopView : BaseView
@property(nonatomic, copy) void (^selectedWalletBlock)(SudNFTWalletInfoModel *walletInfoModel);

- (void)updateDataList:(NSArray<SudNFTWalletInfoModel *> *)dataList;
@end

NS_ASSUME_NONNULL_END
