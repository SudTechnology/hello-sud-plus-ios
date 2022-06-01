//
// Created by Mary on 2022/4/15.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "HSSceneModel.h"

@interface AllCategoryView : BaseView
typedef void(^SelectItemBlock)(HSSceneModel *m, NSInteger idx);
@property (nonatomic, copy) SelectItemBlock selectItemBlock;
- (void)configUI:(NSArray <HSSceneModel *> *)sceneList selectSceneID:(NSInteger)sceneId;
@end
