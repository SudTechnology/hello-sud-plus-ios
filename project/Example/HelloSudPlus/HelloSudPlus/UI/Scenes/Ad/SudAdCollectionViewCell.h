//
//  SudAdCollectionViewCell.h
//  HelloSudPlus
//
//  Created by kaniel on 9/16/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SudAdItemModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SudAdGameState) {
    SudAdGameStateUnknow = 0,
    SudAdGameStatePlaying = 1,
    SudAdGameStateFinished = 2,
};

@interface SudAdCollectionViewCell : BaseCollectionViewCell<SudAdItemModelDelegate>
@property(nonatomic, assign)SudAdGameState gameState;
// 游戏状态变化
@property(nonatomic, strong)void(^onGameStateChangedBlock)(SudAdGameState gameState);
// 点击玩
@property(nonatomic, strong)void(^onStartPlayClickBlock)(SudAdCollectionViewCell *currentCell);
// 停止游戏
@property(nonatomic, strong)void(^onStopPlayClickBlock)(SudAdCollectionViewCell *currentCell);
// 是否游戏已经加载完了
@property(nonatomic, assign)BOOL isGamePrepared;

@property (nonatomic, strong) AVPlayer *player;
@property(nonatomic, weak)UICollectionView *col;

- (void)configureWithURL:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)addGameView:(UIView *)gameView;
/// 处理游戏已经开始
- (void)handleGameStarted;
- (void)handleGameStopped;
- (void)handleGameFinished;
- (void)resetGameToFirstState;
- (void)handleLoadGame:(BOOL)isPrepare;
- (void)showCell:(BOOL)isWillShow;
@end

NS_ASSUME_NONNULL_END
