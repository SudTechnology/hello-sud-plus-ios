//
//  AsyncCallWrapper.h
//  HelloSud-iOS
//
//  Created by Herbert on 2022/4/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AsyncCallWrapper : NSObject

+ (instancetype)sharedInstance;

- (instancetype)init;

- (void)addOperationWithBlock:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
