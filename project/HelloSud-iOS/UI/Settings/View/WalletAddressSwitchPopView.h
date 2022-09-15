//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "WalletAddressSwitchCellModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 钱包地址切换视图
@interface WalletAddressSwitchPopView : BaseView
- (void)updateCellModelList:(NSArray<WalletAddressSwitchCellModel *> *)cellModelList;
@end

NS_ASSUME_NONNULL_END
