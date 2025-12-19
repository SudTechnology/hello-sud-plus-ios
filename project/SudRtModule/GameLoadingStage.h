#import <Foundation/Foundation.h>

#ifndef GameLoadingStage_h
#define GameLoadingStage_h

@class GameInfo;

@protocol GameLoadingStageDelegate <NSObject>

- (void)onLoadStageFinish;

- (void)onLoadStageFailed:(NSError *)error;

- (void)onLoadStageTip:(NSString *)tip;

- (void)onLoadStageProgress:(long)downloadSize totalSize:(long)totalSize;

@end

@protocol GameLoadingStage <NSObject>
@property (nonatomic, weak) id<GameLoadingStageDelegate> delegate;

- (instancetype)initWithDelegate:(id<GameLoadingStageDelegate>)delegate;

- (void)execute:(GameInfo *)gameInfo options:(NSDictionary *)options;

- (void)cancel;

@end

#endif /* GameLoadingStage_h */
