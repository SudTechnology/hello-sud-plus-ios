//
//  CustomRoomApiView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/21.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomRoomApiView : BaseView
typedef NS_ENUM(NSInteger, GameAPIType) {
    /// 加入状态
    GameAPITypeSelfIn = 1000,
    /// 准备
    GameAPITypeSelfReady,
    /// 取消准备
    GameAPITypeSelfReadyCancel,
    /// 退出游戏
    GameAPITypeSelfInOut,
    /// 开始游戏
    GameAPITypeSelfPlaying,
    /// 逃跑
    GameAPITypeSelfPlayingNot,
    /// 解散游戏（队长）
    GameAPITypeSelfEnd
};
@property (nonatomic, copy) UIBUTTON_TAP_BLOCK helpBtnBlock;
@property (nonatomic, copy) Int64Block gameAPITypeBlock;
@end

NS_ASSUME_NONNULL_END
