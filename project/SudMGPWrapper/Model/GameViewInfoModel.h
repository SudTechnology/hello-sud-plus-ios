//
//  GameViewInfoModel.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/1/18.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取游戏View信息Model
@interface ViewGameRect: NSObject
@property (nonatomic, assign) CGFloat              left;
@property (nonatomic, assign) CGFloat              top;
@property (nonatomic, assign) CGFloat              right;
@property (nonatomic, assign) CGFloat              bottom;
@end

@interface GameViewSize: NSObject
@property (nonatomic, assign) CGFloat              width;
@property (nonatomic, assign) CGFloat              height;
@end

@interface GameViewInfoModel: NSObject
@property (nonatomic, strong) ViewGameRect          * view_game_rect;
@property (nonatomic, strong) GameViewSize          * view_size;
@property (nonatomic, assign) NSInteger             ret_code;
@property (nonatomic, copy) NSString                * ret_msg;
/// 序列化成JSON格式字符串串
- (nullable NSString *)toJSON;
@end

NS_ASSUME_NONNULL_END
