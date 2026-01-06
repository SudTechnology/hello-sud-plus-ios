#import "GameCustomCommand.h"
#import <SudGIP/SudGIP-umbrella.h>
//#import "GameEnv.h"


@interface GameCustomCommand ()

@property (nonatomic, copy) NSPointerArray *customCommandListenerArray;
@end

@implementation GameCustomCommand
- (instancetype)init {
    self = [super init];
    if (self) {
        _customCommandListenerArray = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

- (void)dealloc {
}

- (void)addCustomCommandListener:(__weak id<SUDRuntime2GameCustomCommandListener>)listener {
    [_customCommandListenerArray addPointer:(__bridge void *) listener];
}

- (void)removeCustomCommandListener:(__weak id<SUDRuntime2GameCustomCommandListener>)listener {
    NSArray *allObjects = _customCommandListenerArray.allObjects;
    NSInteger count = allObjects.count;
    for (NSInteger index = 0; index < count; ++index) {
        if (allObjects[index] == listener) {
            [_customCommandListenerArray removePointerAtIndex:index];
            return;
        }
    }
}

#pragma mark - CRGameCustomCommandListener
- (void)onCallCustomCommand:(nonnull id<SUDRuntime2GameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv {
    // TODO: wdz 实现 demo 层需要实现的 custom command 功能
    for (id<SUDRuntime2GameCustomCommandListener> customCommandListener in _customCommandListenerArray) {
        [customCommandListener onCallCustomCommand:handle info:argv];
    }
    [handle customCommandSuccess];
}

- (void)onCallCustomCommandSync:(nonnull id<SUDRuntime2GameCustomCommandHandle>)handle info:(nullable NSDictionary *)argv {
    for (id<SUDRuntime2GameCustomCommandListener> customCommandListener in _customCommandListenerArray) {
        [customCommandListener onCallCustomCommandSync:handle info:argv];
    }
    [handle customCommandSuccess];
}

@end

