//
//  QSAppPreferences.h
//  QuickStart
//
//  Created by kaniel on 2022/5/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSGameItemModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 应用配置
@interface QSAppPreferences : NSObject

+ (instancetype)shared;
// 当前用户ID
@property(nonatomic, strong)NSString * currentUserID;

/// 读取游戏列表
- (NSArray<QSGameItemModel *> *)readGameList;
@end

NS_ASSUME_NONNULL_END
