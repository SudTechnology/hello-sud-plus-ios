//
//  WebpImageCacheService.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// webp图片缓存
@interface WebpImageCacheService : NSObject
+ (instancetype)shared;
/// 加载webp
- (void)loadWebp:(NSString *)url result:(nullable void(^)(UIImage *image))result;
@end

NS_ASSUME_NONNULL_END
