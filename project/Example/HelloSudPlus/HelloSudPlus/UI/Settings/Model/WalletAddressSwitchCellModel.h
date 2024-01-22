//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

/// 钱包地址切换cell model
@interface WalletAddressSwitchCellModel : BaseModel
@property(nonatomic, strong) SudNFTWalletInfoModel *walletModel;
@property(nonatomic, strong) NSString *walletAddress;
@property(nonatomic, assign) BOOL isSelected;
@end
