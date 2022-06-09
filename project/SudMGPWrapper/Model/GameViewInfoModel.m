//
//  GameViewInfoModel.m
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/1/18.
//

#import "GameViewInfoModel.h"
#import <MJExtension/MJExtension.h>

@implementation ViewGameRect

@end

@implementation GameViewSize

@end

@implementation GameViewInfoModel
/// 转成JSON串
- (NSString *)toJSON {
    return [self mj_JSONString];
}
@end
