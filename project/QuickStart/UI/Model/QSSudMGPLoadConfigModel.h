//
//  SudMGPConfigModel.h
//  QuickStart
//
//  Created by kaniel on 2022/5/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 加载SudMGP SDK加载需要的业务参数
@interface QSSudMGPLoadConfigModel : NSObject
/// 游戏ID
@property (nonatomic, assign)int64_t gameId;
/// 房间ID
@property (nonatomic, strong)NSString * roomId;
/// 当前用户ID
@property (nonatomic, strong)NSString * userId;
/// 语言 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
@property (nonatomic, strong)NSString * language;
/// 加载展示视图
@property (nonatomic, strong)UIView * gameView;
@end

NS_ASSUME_NONNULL_END
