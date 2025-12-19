#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISudListenerNotifyStateChange.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ISudRt1GameStateListener;

/// Game instance
@protocol ISudRt1GameHandle <NSObject>

/// Set game state listener
/// @param stateListener Game state listener
- (void)setStateHandler:(id<ISudRt1GameStateListener>)stateListener;

/// Get game view
/// @return UIView
- (UIView *)getGameView;

/// Send user custom message
/// - Parameters:
///   - state: State name
///   - dataJson: Content in JSON format
///   - listener: Callback listener
- (void)notifyStateChange:(const NSString *)state
                 dataJson:(NSString *)dataJson
                 listener:(nullable ISudListenerNotifyStateChange)listener;

/// Start game
- (void)start;

/// Resume game (used in conjunction with pause)
- (void)play;

/// Pause game (used in conjunction with play)
- (void)pause;

/// Destroy game
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
