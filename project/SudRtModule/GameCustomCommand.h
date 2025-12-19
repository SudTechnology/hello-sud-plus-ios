#import <SudGIP/SudGIP-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

@interface GameCustomCommand : NSObject <SudRt2GameCustomCommandListener>

@property (nonatomic, copy) NSString *gameID;

- (void)addCustomCommandListener:(__weak id<SudRt2GameCustomCommandListener>)listener;

- (void)removeCustomCommandListener:(__weak id<SudRt2GameCustomCommandListener>)listener;

@end

NS_ASSUME_NONNULL_END
