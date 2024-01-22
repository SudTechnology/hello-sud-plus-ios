//
// Created by kaniel on 2022/11/16.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

/// 选择游戏model
@interface CrossAppSelectGameModel : BaseModel
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSArray<HSGameItem *> *list;
@end