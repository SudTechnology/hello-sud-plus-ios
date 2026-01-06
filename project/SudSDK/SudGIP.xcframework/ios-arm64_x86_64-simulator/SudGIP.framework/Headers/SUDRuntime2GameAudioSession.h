//
//  SUDRuntime2GameAudioSession.h
//  SudGIP
//
//  Created by kaniel on 10/18/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Whether to use the speaker for playback. Playback device priority: Headphones > Bluetooth > Device speaker
extern NSString * _Nonnull const SUD_RT2_KEY_AUDIO_SPEAKER_ON;
/// Whether to mix audio with other apps and other games (other games within this APP)
extern NSString * _Nonnull const SUD_RT2_KEY_AUDIO_MIX_WITH_OTHER;
/// Whether to respect the device's mute switch setting
extern NSString * _Nonnull const SUD_RT2_KEY_AUDIO_OBEY_MUTE_SWITCH;

@protocol SUDRuntime2GameQueryAudioOptionsHandle <NSObject>

- (void)complete:(BOOL)success error:(nullable NSError *)error;

@end


@protocol SUDRuntime2GameQueryAudioOptionsListener <NSObject>

- (void)onQueryAudioSession:(id<SUDRuntime2GameQueryAudioOptionsHandle>)handle appId:(NSString *)appId options:(NSDictionary *)options;

@end

@protocol SUDRuntime2GameAudioSession <NSObject>

- (float)getVolumeFactor;

- (BOOL)isMute;

- (void)mute:(BOOL)mute;

- (void)setGameQueryAudioOptionsListener:(nullable id<SUDRuntime2GameQueryAudioOptionsListener>)listener;

- (void)setVolumeFactor:(float)factor;

@end

NS_ASSUME_NONNULL_END

