//
//  ThirdGameView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2023/12/13.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThirdGameView : BaseView
/// 关闭游戏回调
@property(nonatomic, strong)void(^onCloseGameBlock)(void);
/// 游戏支付回调
@property(nonatomic, strong)void(^onGamePayBlock)(void);

/// 加载游戏
/// - Parameter url: url 游戏链接
- (void)loadGame:(NSString *)url;
/// 销毁游戏
- (void)destryGame;
/// 更新金币
- (void)updateCoin;
@end

NS_ASSUME_NONNULL_END
