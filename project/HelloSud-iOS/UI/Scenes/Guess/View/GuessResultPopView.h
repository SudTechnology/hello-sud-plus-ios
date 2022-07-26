//
//  GuessResultPopView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/14.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

/// 结果展示类型
typedef NS_ENUM(NSInteger, GuessResultPopViewType) {
    GuessResultPopViewTypeNotBet = 0,// 未参与
    GuessResultPopViewTypeLose = 1,// 未猜中
    GuessResultPopViewTypeWin = 2,// 猜中了
};

/// 竞猜结果弹出框视图
@interface GuessResultPopView : BaseView
/// 游戏玩家信息列表
@property(nonatomic, strong) NSArray <GuessPlayerModel *> *dataList;
@property(nonatomic, assign) GuessResultPopViewType resultStateType;
@property(nonatomic, assign) NSInteger winCoin;
@property (nonatomic, strong)void(^againBlock)(void);
@end

NS_ASSUME_NONNULL_END
