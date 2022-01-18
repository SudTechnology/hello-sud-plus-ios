//
//  ZegoExpressEngine+Preprocess.h
//  ZegoExpressEngine
//
//  Copyright © 2019 Zego. All rights reserved.
//

#import "ZegoExpressEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoExpressEngine (Preprocess)

/// Whether to enable acoustic echo cancellation (AEC).
///
/// Available since: 1.1.0
/// Description: Turning on echo cancellation, the SDK filters the collected audio data to reduce the echo component in the audio.
/// Use case: When you need to reduce the echo to improve the call quality and user experience, you can turn on this feature.
/// Default value: When this function is not called, echo cancellation is enabled by default.
/// When to call: It needs to be called after [createEngine], before [startPublishingStream], [startPlayingStream], [startPreview], [createMediaPlayer], [createAudioEffectPlayer].
/// Caution: The AEC function only supports the processing of sounds playbacked through the SDK, such as sounds played by the playing stream, media player, audio effect player, etc.
/// Restrictions: None.
/// Related APIs: Developers can use [enableHeadphoneAEC] to set whether to enable AEC when using headphones, and use [setAECMode] to set the echo cancellation mode.
///
/// @param enable Whether to enable echo cancellation, YES: enable, NO: disable
- (void)enableAEC:(BOOL)enable;

/// Whether to turn on acoustic echo cancellation (AEC) when using the headphone.
///
/// Available since: 1.1.0
/// Description: When [enableAEC] is used to turn on echo cancellation, it is only turned on when using speakers for mobile devices, and not turned on by default when using headphones. If you need to enable echo cancellation when using headphones, please call this function.
/// Use case: It is common when the mobile device is connected to a bluetooth speaker as the audio output source. In order to eliminate the echo in this case, you need to call this function to turn on the echo cancellation.
/// Default value: When this function is not called, this is disabled by default.
/// When to call: It needs to be called after [createEngine], before [startPublishingStream], [startPlayingStream], [startPreview], [createMediaPlayer], [createAudioEffectPlayer].
/// Restrictions: None.
/// Related APIs: Developers need to use [enableAEC] to set whether the SDK enables echo cancellation before using this function.
/// Platform differences: Only supports iOS and Android.
///
/// @param enable Whether to enable, YES: enable, NO: disable
- (void)enableHeadphoneAEC:(BOOL)enable;

/// Sets the acoustic echo cancellation (AEC) mode.
///
/// Available since: 1.1.0
/// Description: When [enableAEC] is used to enable echo cancellation, this function can be used to switch between different echo cancellation modes to control the degree of echo cancellation.
/// Use case: When the default echo cancellation effect does not meet expectations, this function can be used to adjust the echo cancellation mode.
/// Default value: When this function is not called, the default echo cancellation mode is [Aggressive].
/// When to call: It needs to be called after [createEngine], before [startPublishingStream], [startPlayingStream], [startPreview], [createMediaPlayer], [createAudioEffectPlayer].
/// Restrictions: The value set by this function is valid only after the echo cancellation function is turned on.
///
/// @param mode Echo cancellation mode
- (void)setAECMode:(ZegoAECMode)mode;

/// Enables or disables automatic gain control (AGC).
///
/// Available since: 1.1.0
/// Description: After turning on this function, the SDK can automatically adjust the microphone volume to adapt to near and far sound pickups and keep the volume stable.
/// Use case: When you need to ensure volume stability to improve call quality and user experience, you can turn on this feature.
/// Default value: When this function is not called, AGC is enabled by default.
/// When to call: It needs to be called after [createEngine] and before [startPublishingStream], [startPlayingStream], [startPreview], [createMediaPlayer] and [createAudioEffectPlayer]. Note that the Mac needs to be called after [startPreview] and before [startPublishingStream].
/// Restrictions: None.
///
/// @param enable Whether to enable automatic gain control, YES: enable, NO: disable
- (void)enableAGC:(BOOL)enable;

/// Enables or disables active noise suppression (ANS, aka ANC).
///
/// Available since: 1.1.0
/// Description: Enable the noise suppression can reduce the noise in the audio data and make the human voice clearer.
/// Use case: When you need to suppress noise to improve call quality and user experience, you can turn on this feature.
/// Default value: When this function is not called, ANS is enabled by default.
/// When to call: It needs to be called after [createEngine], before [startPublishingStream], [startPlayingStream], [startPreview], [createMediaPlayer], [createAudioEffectPlayer].
/// Related APIs: This function has a better suppression effect on continuous noise (such as the sound of rain, white noise). If you need to turn on transient noise suppression, please use [enableTransientANS]. And the noise suppression mode can be set by [setANSMode].
/// Restrictions: None.
///
/// @param enable Whether to enable noise suppression, YES: enable, NO: disable
- (void)enableANS:(BOOL)enable;

/// Enables or disables transient noise suppression.
///
/// Available since: 1.17.0
/// Description: Enable the transient noise suppression can suppress the noises such as keyboard and desk knocks.
/// Use case: When you need to suppress transient noise to improve call quality and user experience, you can turn on this feature.
/// Default value: When this function is not called, this is disabled by default.
/// When to call: It needs to be called after [createEngine], before [startPublishingStream], [startPlayingStream], [startPreview], [createMediaPlayer], [createAudioEffectPlayer].
/// Related APIs: This function will not suppress normal noise after it is turned on. If you need to turn on normal noise suppression, please use [enableANS].
/// Restrictions: None.
///
/// @param enable Whether to enable transient noise suppression, YES: enable, NO: disable
- (void)enableTransientANS:(BOOL)enable;

/// Sets the automatic noise suppression (ANS) mode.
///
/// Available since: 1.1.0
/// Description: When [enableANS] is used to enable noise suppression, this function can be used to switch between different noise suppression modes to control the degree of noise suppression.
/// Use case: When the default noise suppression effect does not meet expectations, this function can be used to adjust the noise suppression mode.
/// Default value: When this function is not called, the default echo cancellation mode is [Medium].
/// When to call: It needs to be called after [createEngine], before [startPublishingStream], [startPlayingStream], [startPreview], [createMediaPlayer], [createAudioEffectPlayer].
/// Restrictions: The value set by this function is valid only after the noise suppression function is turned on.
///
/// @param mode Audio Noise Suppression mode
- (void)setANSMode:(ZegoANSMode)mode;

/// Enables or disables audio mixing function.
///
/// Available since: 1.9.0
/// Description: After the audio mixing function is turned on, the SDK will mix the audio data prepared by the developer with the audio data collected by the SDK before publishing.
/// Use case: Developers can use this function when they need to mix their own songs, sound effects or other audio data into the publishing stream.
/// Default value: When this function is not called, this is disabled by default.
/// When to call: It needs to be called after [createEngine].
/// Related APIs: After enabling audio mixing, the developer also needs to call [setAudioMixingHandler] to set the audio mixing callback, so as to provide the SDK with the audio data that needs to be mixed in the [onAudioMixingCopyData] callback.
/// Caution: After you start audio mixing, the SDK will play the mixed audio on the local (publisher side) by default. If you do not want to play it locally but only on the remote (player side), please call [muteLocalAudioMixing] to set the local audio mixing mute.
/// Restrictions: None.
///
/// @param enable Whether to enable audio mixting, YES: enable, NO: disable
- (void)enableAudioMixing:(BOOL)enable;

/// Sets up the audio mixing event handler.
///
/// Available since: 1.9.0
/// Description: After the audio mixing function is turned on, the SDK will mix the audio data prepared by the developer with the audio data collected by the SDK before publishing.
/// Use case: Developers can use this function when they need to mix their own songs, sound effects or other audio data into the publishing stream.
/// When to call: It needs to be called after [createEngine].
/// Caution: When this function is called again to set the callback, the previously set mixing callback will be overwritten.
/// Restrictions: None.
///
/// @param handler Audio mixing callback handler
- (void)setAudioMixingHandler:(nullable id<ZegoAudioMixingHandler>)handler;

/// Mute or resume local playback of the mixing audio.
///
/// Available since: 1.9.0
/// Description: When calling this function to mute the local playback audio mixing, the local (publisher side) will not play the audio provided to the SDK through [onAudioMixingCopyData], but the remote (player side) can still playback it Mix.
/// Use case: When developers need to mix their own songs, sound effects or other audio data into the publishing stream, but the mixed audio only wants to be heard by the remote player, and does not want to be playback locally, you can use this function.
/// Default value: When this function is not called, the default is not mute, which is NO.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
///
/// @param mute Whether to mute local audio mixting, YES: mute, NO: unmute
- (void)muteLocalAudioMixing:(BOOL)mute;

/// Sets the audio mixing output volume for both local playback and the stream to be published.
///
/// Available since: 1.9.0
/// Description: After enabling the audio mixing function through [enableAudioMixing], the developer can use this function to set the volume of the mixing audio to be mixed to SDK.
/// Use case: When developers need to mix their own songs, sound effects or other audio data into the publishing stream, and want to adjust the volume of the mixing audio, you can use this function.
/// When to call: It needs to be called after [createEngine].
/// Caution: This function will set both the mixing audio volume of the local playback and the remote playback at the same time.
/// Related APIs: If you need to set the mixing audio volume for local playback or remote playback separately, please use the function of the same name with the [type] parameter.
/// Restrictions: None.
///
/// @param volume The audio mixing volume, range from 0 to 200, 100 as default.
- (void)setAudioMixingVolume:(int)volume;

/// Sets the audio mixing output volume for either local playback or the stream to published.
///
/// Available since: 1.9.0
/// Description: After enabling the audio mixing function through [enableAudioMixing], the developer can use this function to set the volume of the mixing audio to be mixed to SDK.
/// Use case: When developers need to mix their own songs, sound effects or other audio data into the publishing stream, and want to adjust the volume of the mixing audio, you can use this function.
/// When to call: It needs to be called after [createEngine].
/// Caution: This function can individually set the mixing audio volume of the local playback or the remote playback.
/// Restrictions: None.
///
/// @param volume The audio mixing volume, range from 0 to 200, 100 as default.
/// @param type Local playback volume / Remote playback volume
- (void)setAudioMixingVolume:(int)volume type:(ZegoVolumeType)type;

/// Set the sound equalizer (EQ).
///
/// Available since: 1.12.0
/// Description: Call this function to set the sound equalizer adjust the tone.
/// Use cases: Often used in voice chatroom, KTV.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
///
/// @param bandIndex Band frequency index, the value range is [0, 9], corresponding to 10 frequency bands, and the center frequencies are [31, 62, 125, 250, 500, 1K, 2K, 4K, 8K, 16K] Hz.
/// @param bandGain Band gain for the index, the value range is [-15, 15]. Default value is 0, if all gain values in all frequency bands are 0, EQ function will be disabled.
- (void)setAudioEqualizerGain:(int)bandIndex bandGain:(float)bandGain;

/// Setting up the voice changer via preset enumeration.
///
/// Available since: 1.17.0
/// Description: Call this function to use preset voice changer effect.
/// Use cases: Often used in live broadcasting, voice chatroom and KTV.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: Voice changer effect is only effective for SDK captured sound.
/// Related APIs:
/// If you need advanced voice changer effect, please use [setVoiceChangerParam].
/// This function is mutually exclusive with [setReverbPreset]. If used at the same time, it will produce undefined effect.
/// Using ANDROID/ETHEREAL preset voice changer effect will modify reverberation or reverberation echo parameters. Calling [setVoiceChangerParam], [setReverbAdvancedParam], [setReverbEchoParam] may affect the voice changer effect after use these preset voice changer effect.
/// If you need advanced reverb/echo/electronic effects/voice changer effect, please use [setReverbAdvancedParam], [setReverbEchoParam], [setElectronicEffects], [setVoiceChangerParam] together.
///
/// @param preset The voice changer preset enumeration.
- (void)setVoiceChangerPreset:(ZegoVoiceChangerPreset)preset;

/// Setting up the specific voice changer parameters.
///
/// Available since: 1.10.0
/// Description: Call this function to set custom voice changer effect.
/// Use cases: Often used in live broadcasting, voice chatroom and KTV.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: Voice changer effect is only effective for SDK captured sound.
/// Related APIs:
/// [setVoiceChangerPreset] provide a set of preset voice changer effects.
/// If you need advanced reverb/echo/voice changer effect, please use [setReverbAdvancedParam], [setReverbEchoParam], [setVoiceChangerParam] together.
///
/// @param param Voice changer parameters.
- (void)setVoiceChangerParam:(ZegoVoiceChangerParam *)param;

/// Setting up the reverberation via preset enumeration.
///
/// Available since: 1.17.0
/// Description: Call this function to set preset reverb effect.
/// Use cases: Often used in live broadcasting, voice chatroom and KTV.
/// When to call: It needs to be called after [createEngine]. Support call this function to change preset reverb effect during publishing stream.
/// Restrictions: Reverb effect is only effective for SDK captured sound.
/// Related APIs:
/// If you need advanced reverb effect, please use [setReverbAdvancedParam].
/// This function is mutually exclusive with [setVoiceChangerPreset]. If used at the same time, it will produce undefined effects.
/// If you need advanced reverb/echo/voice changer effect, please use [setReverbAdvancedParam], [setReverbEchoParam], [setVoiceChangerParam] together.
///
/// @param preset The reverberation preset enumeration.
- (void)setReverbPreset:(ZegoReverbPreset)preset;

/// Setting up the specific reverberation parameters.
///
/// Available since: 1.10.0
/// Description: Call this function to set preset reverb effect.
/// Use cases: Often used in live broadcasting, voice chatroom and KTV.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: Reverb effect is only effective for SDK captured sound.
/// Caution: Different values dynamically set during publishing stream will take effect. When all parameters are set to 0, the reverberation is turned off.
/// Related APIs:
/// [setReverbPreset] provide a set of preset reverb effects.
/// If you need advanced reverb/echo/voice changer effect, please use [setReverbAdvancedParam], [setReverbEchoParam], [setVoiceChangerParam] together.
///
/// @param param Reverb advanced parameter.
- (void)setReverbAdvancedParam:(ZegoReverbAdvancedParam *)param;

/// Setting up the specific reverberation echo parameters.
///
/// Available since: 1.17.0
/// Description: Call this function to set reverb echo effect. This function can be used with voice changer and reverb to achieve a variety of custom sound effects.
/// Use cases: Often used in live broadcasting, voice chatroom and KTV.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: Reverb echo effect is only effective for SDK captured sound.
/// Related APIs: If you need advanced reverb/echo/voice changer effect, please use [setReverbAdvancedParam], [setReverbEchoParam], [setVoiceChangerParam] together.
///
/// @param param The reverberation echo parameter.
- (void)setReverbEchoParam:(ZegoReverbEchoParam *)param;

/// Enable or disable the virtual stereo effect when publishing stream..
///
/// Available since: 1.10.0; Note: Starting from 2.15.0, the angle parameter supports setting -1 to present a all round virtual stereo effect.
/// Description: Call this function to enable / disable the virtual stereo effect when publishing stream.
/// Use cases: Often used in live broadcasting, voice chatroom and KTV.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: Virtual stereo effect is only effective for SDK captured sound.
/// Caution: You need to set up a dual channel with [setAudioConfig] for the virtual stereo to take effect.
///
/// @param enable YES to turn on the virtual stereo, NO to turn off the virtual stereo.
/// @param angle The angle of the sound source in virtual stereo in the range of -1 ~ 360, with 90 being directly in front, 0 / 180 / 270 corresponding to the rightmost and leftmost respectively. In particular, when set to -1, it is all round virtual stereo effects.
- (void)enableVirtualStereo:(BOOL)enable angle:(int)angle;

/// Enable or disable the virtual stereo effect when playing stream.
///
/// Available since: 2.8.0
/// Description: Call this function to enable/disable the virtual stereo effect when playing stream.
/// Use cases: Often used in live broadcasting, voice chatroom and KTV.
/// When to call: It needs to be called after [createEngine].
/// Caution: It can dynamically switch and set angle parameters before and after playing stream. After stopping playing stream, it will automatically reset and disable.
///
/// @param enable YES to turn on the virtual stereo, NO to turn off the virtual stereo.
/// @param angle The angle of the sound source in virtual stereo in the range of 0 ~ 360, with 90 being directly in front, 0 / 180 / 270 corresponding to the rightmost and leftmost respectively.
/// @param streamID Stream ID.
- (void)enablePlayStreamVirtualStereo:(BOOL)enable angle:(int)angle streamID:(NSString *)streamID;

/// Turn on or off the electronic sound effect.
///
/// Available since: 2.13.0
/// Description: Call this function to turn on or off the electronic sound effect.
/// Use cases: Often used in live broadcasting, voice chatroom and sung unaccompanied scenes.
/// Default value: When this function is not called, the electronic sound effect is not enabled by default.
/// When to call: It needs to be called after [createEngine].
/// Restrictions: None.
/// Caution: When the mode parameter is Harmonic Minor, the tonal parameter does not take effect.
/// Related APIs: Common electronic sound effect configurations can be set via [setVoiceChangerPreset].
///
/// @param enable YES to turn on the electronic sound effect, NO to turn off the electronic sound effect.
/// @param mode Mode of Electronic Effects reference.
/// @param tonal The starting pitch of an electric tone in a given mode, representing 12 semitones in one octave of the sound, in the range [0, 11].
- (void)setElectronicEffects:(BOOL)enable mode:(ZegoElectronicEffectsMode)mode tonal:(int)tonal;

/// [Deprecated] Setting up the specific reverberation parameters.
///
/// This function has been deprecated since version 1.18.0, please use [setReverbAdvancedParam] instead.
/// Different values dynamically set during publishing stream will take effect. When all parameters are set to 0, the reverberation is turned off.
/// This function is an advanced version of [setReverbPreset], you can configure the reverb effect by yourself.
/// If you need to configure the reverb/echo/voice changer effect, please use [setReverbAdvancedParam], [setReverbEchoParam], [setVoiceChangerParam] together.
///
/// @deprecated This function has been deprecated since version 1.18.0, please use [setReverbAdvancedParam] instead.
/// @param param Reverb parameter
- (void)setReverbParam:(ZegoReverbParam *)param DEPRECATED_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
