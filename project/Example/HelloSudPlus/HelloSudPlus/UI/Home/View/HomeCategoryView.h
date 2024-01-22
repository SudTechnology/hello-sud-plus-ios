//
//  HomeCategoryView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeCategoryView : BaseView
typedef void(^SelectSectionBlock)(NSInteger section);
@property (nonatomic, copy) SelectSectionBlock selectSectionBlock;
@property (nonatomic, strong) NSArray <HSSceneModel *> *sceneList;
@property (nonatomic, strong) NSArray *titleArr;
- (void)selectedIndex:(NSInteger)idx;
@end

NS_ASSUME_NONNULL_END
