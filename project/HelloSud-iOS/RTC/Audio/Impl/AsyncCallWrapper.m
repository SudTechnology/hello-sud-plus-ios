//
//  AsyncCallWrapper.m
//  HelloSud-iOS
//
//  Created by Herbert on 2022/4/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "AsyncCallWrapper.h"

@interface AsyncCallWrapper()

@property(nonatomic, strong) NSOperationQueue *rtcQueue;

@end

@implementation AsyncCallWrapper

+ (instancetype)sharedInstance {
    static AsyncCallWrapper *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = AsyncCallWrapper.new;
        }
    });
    
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.rtcQueue = NSOperationQueue.new;
        self.rtcQueue.name = @"com.sudmgp.hellosud.rtc";
        self.rtcQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)addOperationWithBlock:(void(^)(void))block {
    if (self.rtcQueue != nil) {
        [self.rtcQueue addOperationWithBlock:block];
    }
}

@end
