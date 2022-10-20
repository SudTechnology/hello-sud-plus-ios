//
//  GameItemFullCollectionViewCell.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/// 首页列表item宽度满屏样式cell
@interface GameItemFullCollectionViewCell : BaseCollectionViewCell
/// 场景ID
@property (nonatomic, assign)NSInteger sceneId;
/// 场景图片
@property (nonatomic, strong)NSString * sceneImage;
@end

NS_ASSUME_NONNULL_END
