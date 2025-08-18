//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "CommonListStringCellModel.h"
NS_ASSUME_NONNULL_BEGIN


/// 钱包地址切换视图
@interface CommonStringSelectPopView : BaseView
@property(nonatomic, strong)NSString *text;
@property(nonatomic, strong)void(^selectedBlock)(NSInteger selectedIndex);
- (void)updateCellModelList:(NSArray<CommonListStringCellModel *> *)cellModelList selectedIndex:(NSInteger)selectedIndex;
@end

NS_ASSUME_NONNULL_END
