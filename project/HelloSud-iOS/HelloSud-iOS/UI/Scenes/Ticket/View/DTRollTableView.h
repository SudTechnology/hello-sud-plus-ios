//
//  DTRollTableView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTRollTableView : BaseView
@property (nonatomic, strong) NSMutableArray <NSAttributedString *> *dataArray;
- (void)reloadData;
- (void)endTimer;
@end

NS_ASSUME_NONNULL_END

@interface DTRollTableViewCell : BaseTableViewCell
@property (nonatomic, strong) NSAttributedString *attributedText;
@end
