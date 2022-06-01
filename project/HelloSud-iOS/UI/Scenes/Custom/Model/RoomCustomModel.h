//
//  RoomCustomModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"
#import "GameCfgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomCustomOptionList :BaseModel
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) BOOL              isSeleted;
@property (nonatomic, assign, readonly)CGFloat cellHeight;
@end

@interface RoomCustomItems :BaseModel
@property (nonatomic , copy) NSArray<RoomCustomOptionList *>              * optionList;
@property (nonatomic , assign) NSInteger              value;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * subTitle;

- (NSString *)key;
- (NSArray *)keyList;
- (NSString *)getCurSelectedText;
- (BOOL)isVolumeItem;

@end

@interface RoomCustomList :BaseModel
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSArray<RoomCustomItems *>              * items;

@end

@interface RoomCustomModel :BaseModel
@property (nonatomic , copy) NSArray<RoomCustomList *>              * customList;

- (GameCfgModel *)getCfgModel;

@end

NS_ASSUME_NONNULL_END
