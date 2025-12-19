//
//  SudAdCacheManager.h
//  HelloSudPlus
//
//  Created by kaniel on 12/18/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// GI Ad预加载缓存
@interface SudAdCacheManager : NSObject
+(instancetype)shared;
- (void)loadAdCache;
@end

NS_ASSUME_NONNULL_END
