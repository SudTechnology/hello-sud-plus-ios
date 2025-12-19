#import "GameLoadingStageLoadPackage.h"

#import <lib_runtime/CRCocosGamePackageManager.h>

#import "GameEnv.h"
#import "GameInfo.h"

#import "SudCocosPkgManager.h"

@interface GameLoadingStageLoadPackage ()
@end

@implementation GameLoadingStageLoadPackage

@synthesize delegate;

- (instancetype)initWithDelegate:(id<GameLoadingStageDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - GameLoadingStage
- (void)cancel {
    
}


- (void)execute:(GameInfo *)gameInfo options:(NSDictionary *)options {
    
    SudCocosPkgTask *task = [[SudCocosPkgTask alloc]init];
    task.gameInfo = gameInfo;
    task.options = options;
    WeakSelf
    task.onLoadStageFailed = ^(NSError * _Nonnull error) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onLoadStageFailed:)]) {
            [weakSelf.delegate onLoadStageFailed:error];
        }
    };
    task.onLoadStageFinish = ^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(onLoadStageFinish)]) {
            [weakSelf.delegate onLoadStageFinish];
        }
    };

    [SudCocosPkgManager.shared loadTask:task];
    
}


@end
