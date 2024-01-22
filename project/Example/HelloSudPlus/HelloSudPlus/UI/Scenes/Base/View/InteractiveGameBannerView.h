//
// Created by kaniel on 2022/11/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InteractiveGameBannerModel.h"

/// 首页banner视图
@interface InteractiveGameBannerView : BaseView
@property (nonatomic, copy)void(^clickBlock)(InteractiveGameBannerModel *model);
- (void)showBanner:(NSArray <InteractiveGameBannerModel *>*)bannerList;
@end