//
// Created by guanghui on 2022/2/28.
//

#import <Foundation/Foundation.h>

@protocol ISudCfg <NSObject>
/// 获取加载游戏时，是否显示游戏背景图
/// @return true:显示 false:隐藏 默认:显示true
-(BOOL) getShowLoadingGameBg;

/// 设置加载游戏时，是否显示游戏背景图
/// @param show true:显示 false:隐藏
-(void) setShowLoadingGameBg:(BOOL) show;
@end