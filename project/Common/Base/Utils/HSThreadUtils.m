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


@end
