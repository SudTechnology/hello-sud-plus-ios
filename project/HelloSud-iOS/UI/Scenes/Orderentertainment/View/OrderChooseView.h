//
//  OrderChooseView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/18.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"
#import "OrderChooseUsersView.h"
#import "OrderChooseGamesView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderChooseView : BaseView
typedef void(^EnterOrderBlock)(NSArray *userIdList, NSArray *userNameList, HSGameItem * gameItem);
@property (nonatomic, copy) EnterOrderBlock enterOrderBlock;
@property (nonatomic, strong) OrderChooseUsersView *usersView;
@property (nonatomic, strong) OrderChooseGamesView *gamesView;
- (void)configOrderBtnNotClick;

@end

NS_ASSUME_NONNULL_END
