//
//  GameConfigPopView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "RoomCustomModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameConfigPopView : BaseView
@property(nonatomic, strong)NSArray<RoomCustomOptionList *> *dataArray;
@property(nonatomic, strong)Int64Block selectedIdxBlock;
@end

NS_ASSUME_NONNULL_END
