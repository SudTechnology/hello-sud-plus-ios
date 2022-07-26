//
//  HSThreadUtils.m
//  HelloSud-iOS
//
//  Created by Herbert on 2022/3/25.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HSThreadUtils.h"


@implementation HSThreadUtils {

}

+(void)runOnUiThread:(dispatch_block_t) block {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/// 主线程延迟回调
/// @param second 秒
/// @param callback 回调
+(void)dispatchMainAfter:(NSTimeInterval)second callback:(void(^)(void))callback {
    // 延迟关闭以便上面指令执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (second * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (callback) callback();
    });
}
@end
