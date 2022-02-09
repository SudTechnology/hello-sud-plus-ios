#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISudFSMStateHandle;

@protocol ISudFSMMG <NSObject>
/**
* 游戏日志
*/
-(void) onGameLog:(NSString*)dataJson;

/**
* 游戏开始
*/
-(void) onGameStarted;

/**
 * 游戏销毁
 */
-(void) onGameDestroyed;

/**
 * Code过期
 * @param dataJson {"code":"value"}
 */
-(void) onExpireCode:(id<ISudFSMStateHandle>)handle dataJson:(NSString*)dataJson;

/**
 * 获取游戏View信息
 * @param handle
 * @param dataJson {}
 */
-(void) onGetGameViewInfo:(id<ISudFSMStateHandle>) handle dataJson:(NSString*)dataJson;

/**
 * 获取游戏配置
 * @param handle
 * @param dataJson {}
 */
-(void) onGetGameCfg:(id<ISudFSMStateHandle>) handle dataJson:(NSString*)dataJson;

/**
 * 游戏状态变化
 * @param handle
 * @param state
 * @param dataJson
 */
-(void) onGameStateChange:(id<ISudFSMStateHandle>) handle state:(NSString*) state dataJson:(NSString*) dataJson;

/**
 * 游戏玩家状态变化
 * @param handle
 * @param userId
 * @param state
 * @param dataJson
 */
-(void) onPlayerStateChange:(nullable id<ISudFSMStateHandle>) handle userId:(NSString*) userId state:(NSString*) state dataJson:(NSString*) dataJson;
@end

NS_ASSUME_NONNULL_END