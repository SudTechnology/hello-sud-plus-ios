//
//  SudAdItemModel.h
//  HelloSudPlus
//
//  Created by kaniel on 9/17/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

// 视频
@interface SudAdVideoItem : BaseModel
@property(nonatomic, strong)NSString *url;// 链接
@end

// 游戏
@interface SudAdGameItem : BaseModel
@property(nonatomic, strong)NSString *url;// 包链接
@property(nonatomic, strong)NSString *gameHash;// url hash
@property(nonatomic, strong)NSString *cover;// 封面图片
@property(nonatomic, strong)NSString *name;// 名称
@property(nonatomic, strong)NSString *icon;// icon
@property(nonatomic, strong)NSString *gameId;// 游戏id
@property(nonatomic, strong)NSString *version;// 游戏版本
@property(nonatomic, strong)NSString *link;// 跳转链接
@end

typedef NS_ENUM(NSInteger,SudAdItemModelAdType ){
    SudAdItemModelAdTypeVideo = 1,
    SudAdItemModelAdTypeGame = 2
};

@protocol SudAdItemModelDelegate <NSObject>

@optional
- (void)onGameNotifyFinished;
- (void)onShowGameView:(UIView *)gameView;
@end

@interface SudAdItemModel : BaseModel
@property(nonatomic, weak)id<SudAdItemModelDelegate> delegate;

@property(nonatomic, assign)NSInteger adType;// 1 视频 2 游戏
@property(nonatomic, strong)SudAdVideoItem *videoInfo;// 视频信息
@property(nonatomic, strong)SudAdGameItem *gameInfo;// 游戏信息
@property(nonatomic, strong)NSString *tag;
@property(nonatomic, strong)void(^onGameNotifyFinished)(void);
@property(nonatomic, assign)NSInteger lastState;
@property(nonatomic, assign)NSInteger index;
@property(nonatomic, strong)NSString *code;
@property(nonatomic, weak)UIView *cacheGameView;
@property(nonatomic, assign)BOOL isLoaded;
/// 预加载
- (void)preLoad;
- (void)loadGame:(void(^)(UIView *gameView))completed;
- (void)requestShowGameView;
/// 有交互声音
- (void)playGame;
/// 没有交互声音
- (void)stopGame;
- (void)destroyGame;
// 画面动
- (void)startRunGame;
// 画面停止
- (void)stopRunGame;
@end

NS_ASSUME_NONNULL_END
