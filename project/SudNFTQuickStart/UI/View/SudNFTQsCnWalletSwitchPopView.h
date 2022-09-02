//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "SudNFTQsCnWalletSwitchCellModel.h"
NS_ASSUME_NONNULL_BEGIN


/// 国内钱包切换选择
@interface SudNFTQsCnWalletSwitchPopView : BaseView
- (void)updateBindWalletList:(NSArray<SudNFTWalletInfoModel *> *)bindWalletList;
@end

NS_ASSUME_NONNULL_END
