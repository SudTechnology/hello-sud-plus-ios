//
//  SudRtWrapperManager.h
//  HelloSudPlus
//
//  Created by kaniel on 10/11/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SudRtWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface SudRtWrapperManager : NSObject

+(instancetype)shared;
- (void)addRt:(SudRtWrapper *)rt;
- (void)removeRt:(SudRtWrapper *)rt;
@end

NS_ASSUME_NONNULL_END
