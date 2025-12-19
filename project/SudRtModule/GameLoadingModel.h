#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GameInfo;

@interface GameLoadingModel : NSObject
@property (nonatomic) GameInfo *gameInfo;

- (void)startLoadGame:(GameInfo *)gameInfo
             progress:(void (^)(NSString *message))progress
           completion:(void (^)(NSError * _Nullable error))completion;

- (void)stopWithCompletion:(nullable void (^)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
