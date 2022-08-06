//
// Created by kaniel on 2022/8/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

@interface BindBtnView : BaseView
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) SudNFTWalletModel *model;
@property(nonatomic, strong) void (^clickWalletBlock)(SudNFTWalletModel *wallModel);
- (void)update:(SudNFTWalletModel *)model;
@end

