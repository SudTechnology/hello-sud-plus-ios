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
@property (nonatomic, assign) NSInteger left;
@property (nonatomic, assign) NSInteger top;
@property (nonatomic, assign) NSInteger right;
@property (nonatomic, assign) NSInteger bottom;
@end

@interface GameViewSize: NSObject
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@end

@interface GameViewInfoModel: NSObject
/// 游戏视图四周安全区 px
@property (nonatomic, strong) ViewGameRect * view_game_rect;
/// 游戏视图大小，设置与gameView保持一致大小值 px
@property (nonatomic, strong) GameViewSize * view_size;
@property (nonatomic, assign) NSInteger ret_code;
@property (nonatomic, copy) NSString * ret_msg;
/// 序列化成JSON格式字符串串
- (nullable NSString *)toJSON;
@end

NS_ASSUME_NONNULL_END
