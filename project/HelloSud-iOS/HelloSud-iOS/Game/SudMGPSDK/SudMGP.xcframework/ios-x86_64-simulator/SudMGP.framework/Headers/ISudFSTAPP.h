#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISudListenerNotifyStateChange.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ISudFSMMG;

@protocol ISudFSTAPP <NSObject>
- (UIView *) getGameView;
- (bool) destroyMG;
//- (bool) changeMG:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t) mgId fsmMG:(id<ISudFSMMG>)fsmMG;

- (void) updateCode:(NSString *) code listener:(ISudListenerNotifyStateChange) listener;

- (NSString*) getGameState:(NSString*) state;

- (NSString*) getPlayerState:(NSString*) userId state:(NSString*) state;

- (void)notifyStateChange:(const NSString *)state dataJson:(NSString *)dataJson listener:(ISudListenerNotifyStateChange) listener;
@end

NS_ASSUME_NONNULL_END