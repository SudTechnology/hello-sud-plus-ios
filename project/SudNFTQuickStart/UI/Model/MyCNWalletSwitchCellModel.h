//
// Created by kaniel on 2022/7/28.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//
/// 已绑定钱包切换cell model
@interface MyCNWalletSwitchCellModel : BaseModel
@property(nonatomic, strong) SudNFTWalletInfoModel *walletInfoModel;
@property(nonatomic, assign) BOOL isSelected;
@end
