//
// Created by kaniel on 2023/8/4.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Audio3dFaceItemModel.h"
/// 表情视图
@interface Audio3dFaceView : BaseView
@property (nonatomic, strong)void(^faceItemClickBlock)(Audio3dFaceItemModel *faceItemModel);
- (CGFloat)expectedHeight;

@end