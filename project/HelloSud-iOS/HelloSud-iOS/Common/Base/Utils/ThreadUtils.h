//
//  ThreadUtils.h
//  HelloSud-iOS
//
//  Created by Herbert on 2022/3/25.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ThreadUtils : NSObject

+(void)runOnUiThread:(dispatch_block_t) block;

@end
