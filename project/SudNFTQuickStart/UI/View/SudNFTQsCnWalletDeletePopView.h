//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 国内钱包解除绑定
@interface SudNFTQsCnWalletDeletePopView : BaseView
@property (nonatomic, strong)SudNFTWalletInfoModel *walletInfoModel;
@property (nonatomic, copy)void(^sureBlock)(void);
@property (nonatomic, copy)void(^cancelBlock)(void);
@end

NS_ASSUME_NONNULL_END
