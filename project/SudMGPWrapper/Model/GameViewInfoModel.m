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
/// 序列化成JSON格式字符串串
- (nullable NSString *)toJSON {
    return self.mj_JSONString;
}
@end
