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

- (ViewGameRect *)view_game_rect {
    if (!_view_game_rect) {
        _view_game_rect = [[ViewGameRect alloc] init];
    }
    return _view_game_rect;
}

- (GameViewSize *)view_size {
    if (!_view_size) {
        _view_size = [[GameViewSize alloc] init];
    }
    return _view_size;
}

/// 序列化成JSON格式字符串串
- (nullable NSString *)toJSON {
    return self.mj_JSONString;
}
@end
