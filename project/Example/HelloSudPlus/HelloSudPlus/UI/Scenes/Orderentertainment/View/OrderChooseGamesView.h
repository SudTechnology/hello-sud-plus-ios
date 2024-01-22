//
//  OrderChooseGamesView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderChooseGamesView : BaseView
typedef void(^CompleteBlock)(void);
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, assign) BOOL isNotSelectedItem;

- (void)configGamesData:(NSArray <HSGameItem *>*)list;
- (HSGameItem *)getSelectGame;
@end

NS_ASSUME_NONNULL_END
