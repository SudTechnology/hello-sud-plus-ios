//
//  BaseSceneGameEventHandler.h
//  HelloSudPlus
//
//  Created by kaniel on 2024/1/25.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudGameBaseEventHandler.h"
#import "BaseSceneViewController.h"
NS_ASSUME_NONNULL_BEGIN
/// 游戏事件处理模块
@interface BaseSceneGameEventHandler : SudGameBaseEventHandler
@property(nonatomic, weak)BaseSceneViewController *vc;
- (void)pushAudioToAiAgent:(NSData *)pcmData;
- (void)pauseAudioToAiAgent;
- (void)sendTextToAiAgent:(NSString *)text;
- (BOOL)isOpenAiAgent;
- (void)handleUserPlayerAudioState:(NSString *)userId state:(NSInteger)state;
@end

NS_ASSUME_NONNULL_END
