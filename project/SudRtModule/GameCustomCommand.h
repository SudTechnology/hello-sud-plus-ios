#import <SudGIP/SudGIP-umbrella.h>
NS_ASSUME_NONNULL_BEGIN

@interface GameCustomCommand : NSObject <SUDRuntime2GameCustomCommandListener>

@property (nonatomic, copy) NSString *gameID;

- (void)addCustomCommandListener:(__weak id<SUDRuntime2GameCustomCommandListener>)listener;

- (void)removeCustomCommandListener:(__weak id<SUDRuntime2GameCustomCommandListener>)listener;

@end

NS_ASSUME_NONNULL_END
