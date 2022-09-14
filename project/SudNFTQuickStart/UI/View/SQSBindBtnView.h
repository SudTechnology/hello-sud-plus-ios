//
// Created by kaniel on 2022/8/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

@interface SQSBindBtnView : BaseView
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) SudNFTWalletInfoModel *model;
@property(nonatomic, strong) void (^clickWalletBlock)(SudNFTWalletInfoModel *wallModel);
- (void)update:(SudNFTWalletInfoModel *)model;
@end

