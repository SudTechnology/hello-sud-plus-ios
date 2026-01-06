#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ISudListenerNotifyStateChange.h"
#import "ISudAiAgent.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ISudFSMMG;

@protocol ISudFSTAPP <NSObject>

/// 获取游戏View
/// @return UIView
- (UIView *)getGameView;

/// 销毁游戏
/// @return boolean
- (bool)destroyMG;

/// 重新加载游戏
- (void)reloadMG;

/// 更新短期令牌code
/// @param code 短期令牌code
/// @param listener 回调只表示APP状态通知到了小游戏，不表示小游戏执行了别的逻辑代码（比如：游戏业务逻辑网络请求），一般传null。
- (void)updateCode:(NSString *) code listener:(ISudListenerNotifyStateChange) listener;

/// 获取游戏状态
/// @param state state
/// @return json
- (NSString*)getGameState:(NSString*) state;

/// 获取玩家状态
/// @param userId userId
/// @param state state
/// @return json
- (NSString*)getPlayerState:(NSString*) userId state:(NSString*) state;

/// APP状态通知给小游戏
/// @param state state
/// @param dataJson example: {"key": "value"}
/// @param listener 回调只表示APP状态通知到了小游戏，不表示小游戏执行了别的逻辑代码（比如：游戏业务逻辑网络请求），一般传null。
- (void)notifyStateChange:(const NSString *)state dataJson:(NSString *)dataJson listener:(nullable ISudListenerNotifyStateChange) listener;

/// 继续游戏
- (void) playMG;

/// 暂停游戏
- (void) pauseMG;

/// 传入的音频切片是从RTC获取的PCM数据
/// PCM数据格式必须是：采样率：16000， 采样位数：16， 声道数： MONO
/// PCM数据长度可以根据效果调整，长度大: 精确度好但延时长  长度小：延时短但牺牲精确度
/// @param data pcm数据
- (void)pushAudio:(NSData *)data;

/// 创建一个ai agent操作实例
- (id<ISudAiAgent>)getAiAgent;
@end

NS_ASSUME_NONNULL_END
