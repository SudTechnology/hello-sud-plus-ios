//
//  HSGameManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "HSGameManager.h"

@implementation HSGameManager
+ (instancetype)shared {
    static HSGameManager *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HSGameManager.new;
    });
    return g_manager;
}
@end
