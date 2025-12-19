#import "GameLoadingModel.h"

#import "GameLoadingStage.h"
#import "GameLoadingStageLoadPackage.h"
//#import "GameLoadingStageLoadPlugin.h"

@interface GameLoadingModel () <GameLoadingStageDelegate>
@property (nonatomic, assign) NSInteger currentStage;
@property (nonatomic, copy) NSString *loadingTipType;
@property (nonatomic, copy) void (^progressHandler)(NSString * _Nullable);
@property (nonatomic, copy) void (^startCompletion)(NSError * _Nullable);
@property (nonatomic, strong) NSArray<id<GameLoadingStage>> *gameLoadingStages;
@end

@implementation GameLoadingModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentStage = 0;
        _gameLoadingStages = @[
            [[GameLoadingStageLoadPackage alloc] initWithDelegate:self],
//            [[GameLoadingStageLoadPlugin alloc] initWithDelegate:self]
        ];
    }
    return self;
}

- (void)startLoadGame:(GameInfo *)gameInfo
             progress:(nonnull void (^)(NSString * _Nonnull))progress
           completion:(nonnull void (^)(NSError * _Nullable))completion {
    NSLog(@"start loading");
    // TODO: wdz demo 需要判断 Core 的 feature 是否支持当前游戏配置中的 require，若不支持需要调用 onLoadAbort()
    _gameInfo = gameInfo;
    _progressHandler = progress;
    _startCompletion = completion;
    
//    if (_currentStage < _gameLoadingStages.count) {
//        [[_gameLoadingStages objectAtIndex:_currentStage] cancel];
//    }
    _currentStage = 0;
    [[_gameLoadingStages objectAtIndex:_currentStage] execute:_gameInfo options:nil];
}

- (void)stopWithCompletion:(void (^)(NSError * _Nullable))completion {
    NSLog(@"stop loading");
    if (_currentStage < _gameLoadingStages.count) {
        [[_gameLoadingStages objectAtIndex:_currentStage] cancel];
        _currentStage = 0;
    }
    if (completion) {
        completion(nil);
    }
}

#pragma mark - GameLoadingStageDelegate
- (void)onLoadStageFailed:(NSError *)error {
    if (_startCompletion) {
        _startCompletion(error);
        _startCompletion = nil;
        _progressHandler = nil;
    }
    _gameInfo = nil;
}

- (void)onLoadStageFinish {
    _currentStage++;
    if (_currentStage >= _gameLoadingStages.count) {
        // 加载完成
        NSLog(@"loading finish");
        [self onLoadStageTip:NSLocalizedString(@"启动游戏...", nil)];
        if (_startCompletion) {
            _startCompletion(nil);
            _startCompletion = nil;
            _progressHandler = nil;
        }
        return;
    }
    [[_gameLoadingStages objectAtIndex:_currentStage] execute:_gameInfo options:nil];
}

- (void)onLoadStageProgress:(long)downloadSize totalSize:(long)totalSize {
    float sizeF = downloadSize * 1.f / 1024;
    float totalF = totalSize * 1.f / 1024;
    NSString *speedText = [NSString stringWithFormat:@"%@: %.2fKB/%.2fKB", _loadingTipType, sizeF, totalF];
    if (_progressHandler) {
        _progressHandler(speedText);
    }
}

- (void)onLoadStageTip:(NSString *)tip {
    _loadingTipType = tip;
    if (_progressHandler) {
        _progressHandler(tip);
    }
}

@end
