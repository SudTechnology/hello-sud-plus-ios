//
// Created by kaniel on 2023/8/4.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

/// 表情数据模型
@interface Audio3dFaceItemModel : BaseModel
typedef NS_ENUM(NSInteger, Audio3dFaceItemModelType){
    Audio3dFaceItemModelFace = 0,
    Audio3dFaceItemModelLight = 1,
};

@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSString *icon;
@property (nonatomic, assign)NSInteger faceId;
// 0 表情 1 爆灯
@property (nonatomic, assign)Audio3dFaceItemModelType type;
@end