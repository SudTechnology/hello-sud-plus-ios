//
//  TicketChooseViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketChooseViewController : BaseViewController
@property (nonatomic, assign) NSInteger gameId;
@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, copy) NSString *gameName;

@end

NS_ASSUME_NONNULL_END
