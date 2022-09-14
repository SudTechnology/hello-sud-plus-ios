//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN


/// 网链选择
@interface SQSEthereumChainsSelectPopView : BaseView

- (void)updateChains:(NSArray<SudNFTChainInfoModel *> *)chains;
@end

NS_ASSUME_NONNULL_END
