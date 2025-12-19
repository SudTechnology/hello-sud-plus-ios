#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISudRt1GameStateHandle;
@protocol ISudRt1GameStateListener <NSObject>

/// 游戏回调状态定义
/// @param state state description
/// @param dataJson dataJson description
/// @param handle handle description
-(void)onStateChanged:(NSString*)state dataJson:(NSString*)dataJson handle:(id<ISudRt1GameStateHandle>)handle;
@end

NS_ASSUME_NONNULL_END
