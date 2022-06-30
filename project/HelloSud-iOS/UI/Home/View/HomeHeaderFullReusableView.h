//
//  GameItemFullReusableView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseCollectionReusableView.h"

NS_ASSUME_NONNULL_BEGIN
/// 游戏全屏头部视图
@interface HomeHeaderFullReusableView : BaseCollectionReusableView
@property (nonatomic, strong) HSSceneModel *sceneModel;
@property (nonatomic, copy) UIBUTTON_TAP_BLOCK customBlock;
@end

NS_ASSUME_NONNULL_END
