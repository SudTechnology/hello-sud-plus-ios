#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GameInfo;
@protocol SUDRuntime2CocosGameHandle;

@protocol SUDRuntime2GameCustomCommandListener;

@protocol SUDRuntime2CocosGameMediaPlayerHandle;

@protocol SUDRuntime2MediaPlayerHandleListener <NSObject>

- (void)addMediaPlayerHandle:(id<SUDRuntime2CocosGameMediaPlayerHandle>)mediaPlayerHandle;

- (void)removeMediaPlayerhandleWithInstanceID:(UInt64) instanceID;

@end
        
@protocol GameRunningModelDelegate;

@interface GameRunningModel : NSObject
@property (nonatomic, copy, readonly) GameInfo *gameInfo;
@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, strong) id<SUDRuntime2GameCustomCommandListener> customCommandListener;
@property (nonatomic, strong, readonly) NSDictionary *gameOptions;
@property (nonatomic, strong, readonly) id<SUDRuntime2GameHandle> gameHandle;
@property (nonatomic, weak) id<SUDRuntime2MediaPlayerHandleListener> mediaPlayerHandleListener;
@property (nonatomic, weak) id<GameRunningModelDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithUserID:(NSString *)userID NS_DESIGNATED_INITIALIZER;

- (void)runGame:(GameInfo *)gameInfo
    gameOptions:(NSDictionary *)options
  handleCreated:(nullable void (^)(id<SUDRuntime2GameHandle> handle))create
     completion:(nullable void (^)(id<SUDRuntime2GameHandle> _Nullable handle,
                                   NSError * _Nullable error))completion;

- (void)quitWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;
/// 画面动
- (void)start;
/// 画面停
- (void)stop;

- (void)startPlayGame;
- (void)stopPlayGame;
@end

@protocol GameRunningModelDelegate <NSObject>

// 游戏主动结束，中断运行
- (void)runningModelDidInterrupt:(GameRunningModel *)model;

@end

NS_ASSUME_NONNULL_END
