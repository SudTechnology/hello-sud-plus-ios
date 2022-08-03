//
// Created by kaniel on 2022/5/26.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 游戏item model
@interface QSGameItemModel : BaseModel
@property (nonatomic, assign) int64_t gameId;
@property (nonatomic, copy) NSString * gameName;
/// 游戏列表icon
@property (nonatomic, copy) NSString * gamePic;
/// 游戏房间内列表icon
@property (nonatomic, copy) NSString * gameRoomPic;

/// 业务需要 默认为0  1 = 关闭游戏 2 = 结束游戏
@property (nonatomic, assign) NSInteger itemType;

/// 预下载状态值
@property (nonatomic, assign)long downloadedSize;
@property (nonatomic, assign)long totalSize;
@property (nonatomic, assign)BOOL success;
@property (nonatomic, assign)NSInteger errCode;
@property (nonatomic, copy) NSString * errMsg;
@end
