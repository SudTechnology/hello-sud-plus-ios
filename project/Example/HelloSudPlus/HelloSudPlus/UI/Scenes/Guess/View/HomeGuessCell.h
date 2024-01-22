//
// Created by kaniel on 2022/6/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface HomeGuessCell : BaseCollectionViewCell
@property (nonatomic, copy)void(^onEnterRoomBlock)(MoreGuessGameModel *model);
@end