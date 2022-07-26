//
//  HSThreadUtils.h
//  HelloSud-iOS
//
//  Created by Herbert on 2022/3/25.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HSThreadUtils : NSObject

+(void)runOnUiThread:(dispatch_block_t) block;
/// 主线程延迟回调
/// @param second 秒
/// @param callback 回调
+(void)dispatchMainAfter:(NSTimeInterval)second callback:(void(^)(void))callback;
@end
