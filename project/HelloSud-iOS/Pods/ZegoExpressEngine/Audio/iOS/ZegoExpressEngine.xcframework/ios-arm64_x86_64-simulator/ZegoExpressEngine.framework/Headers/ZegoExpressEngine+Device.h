//
//  ZegoExpressEngine+Device.h
//  ZegoExpressEngine
//
//  Copyright © 2019 Zego. All rights reserved.
//

#import "ZegoExpressEngine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZegoExpressEngine (Device)

/// Mutes or unmutes the microphone.
///
/// Available since: 1.1.0
/// Description: This function is used to control whether to use the collected audio data. Mute (turn off the microphone) will use the muted data to replace the audio data collected by the device for streaming. At this time, the microphone device will still be occupied.
/// Default value: The default is `NO`, which means no muting.
/// When to call: After creating the engine [createEngine].
/// Restrictions: None.
/// Related APIs: Developers who want to control whether to use microphone on the UI should use this function to avoid unnecessary performance overhead by using the [enableAudioCaptureDevice]. You can use [isMicrophoneMuted] to check if the microphone is muted.
///
/// @param mute Whether to mute (disable) the microphone, `YES`: mute (disable) microphone, `NO`: enable microphone.
- (void)muteMicrophone:(BOOL)mute;

/// Checks whether the microphone is muted.
///
/// Available since: 1.1.0
/// Description: Used to determine whether the microphone is set to mute.
/// When to call: After creating the engine [createEngine].
/// Restrictions: None.
/// Related APIs: [muteMicrophone].
///
/// @return Whether the microphone is muted; YES: the microphone is muted; `NO`: the microphone is enable (not muted).
- (BOOL)isMicrophoneMuted;

/// Mutes or unmutes the audio output speaker.
///
/// Available since: 1.1.0
/// Description: After mute speaker, all the SDK sounds will not play, including playing stream, mediaplayer, etc. But the SDK will still occupy the output device.
/// Default value: The default is `NO`, which means no muting.
/// When to call: After creating the engine [createEngine].
/// Restrictions: None.
///
/// @param mute Whether to mute (disable) speaker audio output, `YES`: mute (disable) speaker audio output, `NO`: enable speaker audio output.
- (void)muteSpeaker:(BOOL)mute;

/// Checks whether the audio output speaker is muted.
///
/// Available since: 1.1.0
/// Description: Used to determine whether the audio output is muted.
/// When to call: After creating the engine [createEngine].
/// Restrictions: None.
/// Related APIs: [muteSpeaker].
///
/// @return Whether the speaker is muted; `YES`: the speaker is muted; `NO`: the speaker is enable (not muted).
- (BOOL)isSpeakerMuted;

#if TARGET_OS_OSX
/// Gets a list of audio devices.
///
/// Only supports desktop.
///
/// @param deviceType Audio device type
/// @return Audo device List
- (NSArray<ZegoDeviceInfo *> *)getAudioDeviceList:(ZegoAudioDeviceType)deviceType;
#endif

#if TARGET_OS_OSX
/// Get the device ID of the default audio device.
///
/// Only supports desktop.
///
/// @param deviceType Audio device type
/// @return Default Audio device ID
- (NSString *)getDefaultAudioDeviceID:(ZegoAudioDeviceType)deviceType;
#endif

#if TARGET_OS_OSX
/// Chooses to use the specified audio device.
///
/// Only supports desktop.
///
/// @param deviceID ID of a device obtained by [getAudioDeviceList]
/// @param deviceType Audio device type
- (void)useAudioDevice:(NSString *)deviceID deviceType:(ZegoAudioDeviceType)deviceType;
#endif

#if TARGET_OS_OSX
/// Get volume for the specified audio device.
///
/// Get volume for the specified audio device. Only for macOS.
///
/// @param deviceID ID of a device obtained by [getAudioDeviceList]
/// @param deviceType Audio device type
/// @return Device volume
- (int)getAudioDeviceVolume:(NSString *)deviceID deviceType:(ZegoAudioDeviceType)deviceType;
#endif

#if TARGET_OS_OSX
/// Set volume for the specified audio device.
///
/// Only for macOS. The direct operating system device may fail due to system restrictions. Please use [setCaptureVolume] and [setPlayVolume] first to adjust the volume of publish and play streams.
///
/// @param deviceID ID of a device obtained by [getAudioDeviceList]
/// @param deviceType Audio device type
/// @param volume Device volume
- (void)setAudioDeviceVolume:(NSString *)deviceID deviceType:(ZegoAudioDeviceType)deviceType volume:(int)volume;
#endif

#if TARGET_OS_OSX
/// Turn on audio device volume monitoring.
///
/// Only for macOS.
///
/// @param deviceID ID of a device obtained by [getAudioDeviceList]
/// @param deviceType Audio device type
- (void)startAudioDeviceVolumeMonitor:(NSString *)deviceID deviceType:(ZegoAudioDeviceType)deviceType;
#endif

#if TARGET_OS_OSX
/// Turn off audio device volume monitoring.
///
/// Only for macOS.
///
/// @param deviceID ID of a device obtained by [getAudioDeviceList]
/// @param deviceType Audio device type
- (void)stopAudioDeviceVolumeMonitor:(NSString *)deviceID deviceType:(ZegoAudioDeviceType)deviceType;
#endif

#if TARGET_OS_OSX
/// Mutes or unmutes the audio device.
///
/// Only for macOS.
///
/// @param deviceID ID of a device obtained by [getAudioDeviceList]
/// @param deviceType Audio device type
/// @param mute Whether to mute the audio device; YES means to mute the audio device; NO means to unmute the audio device.
- (void)muteAudioDevice:(NSString *)deviceID deviceType:(ZegoAudioDeviceType)deviceType mute:(BOOL)mute;
#endif

#if TARGET_OS_OSX
/// Check if the audio device is muted.
///
/// Check if the audio device is muted. Only for macOS.
///
/// @param deviceID ID of a device obtained by [getAudioDeviceList]
/// @param deviceType Audio device type
/// @return Whether the audio device is muted; YES means the audio device is muted; NO means the audio device is not muted.
- (BOOL)isAudioDeviceMuted:(NSString *)deviceID deviceType:(ZegoAudioDeviceType)deviceType;
#endif

/// Enables or disables the audio capture device.
///
/// Available since: 1.1.0
/// Description: This function is used to control whether to release the audio collection device. When the audio collection device is turned off, the SDK will no longer occupy the audio device. Of course, if the stream is being published at this time, there is no audio data.
/// Use cases: When the user never needs to use the audio, you can call this function to close the audio collection.
/// Default value: The default is `NO`.
/// When to call: After creating the engine [createEngine].
/// Restrictions: None.
/// Related APIs: Turning off or turning on the microphone on the hardware is a time-consuming operation, and there is a certain performance overhead when the user performs frequent operations. [muteMicrophone] is generally recommended.
///
/// @param enable Whether to enable the audio capture device, `YES`: disable audio capture device, `NO`: enable audio capture device.
- (void)enableAudioCaptureDevice:(BOOL)enable;

#if TARGET_OS_IPHONE
/// get current audio route type.
///
/// Available since: 1.1.0
/// Description: Audio routing refers to the audio output device that an app uses to play audio, and common audio routes are: speakers, handsets, headphones, Bluetooth devices, and so on.
/// When to call: After creating the engine [createEngine].
/// Restrictions: None.
/// Related APIs: Set audio route to speaker [setAudioRouteToSpeaker].
- (ZegoAudioRoute)getAudioRouteType;
#endif

#if TARGET_OS_IPHONE
/// Whether to use the built-in speaker to play audio.
///
/// Available since: 1.1.0
/// Description: Whether to use the speaker to play audio, when you choose not to use the built-in speaker to play the sound, the SDK will select the audio output device with the highest current priority to play the sound according to the system schedule, and common audio routes are: handsets, headphones, Bluetooth devices, and so on.
/// When to call: After creating the engine [createEngine].
/// Restrictions: None.
/// Related APIs: Get the current audio route [getAudioRouteType].
///
/// @param defaultToSpeaker Whether to use the built-in speaker to play sound, `YES`: use the built-in speaker to play sound, `NO`: use the highest priority audio output device scheduled by the current system to play sound
- (void)setAudioRouteToSpeaker:(BOOL)defaultToSpeaker;
#endif

/// Starts sound level monitoring.
///
/// Available since: 1.1.0
/// Description: After starting monitoring, you can receive local audio sound level via [onCapturedSoundLevelUpdate] callback, and receive remote audio sound level via [onRemoteSoundLevelUpdate] callback. Before entering the room, you can call [startPreview] with this function and combine it with [onCapturedSoundLevelUpdate] callback to determine whether the audio device is working properly.
/// Use cases: During the publishing and playing process, determine who is talking on the wheat and do a UI presentation, in the host K song scene, has been published or played under the premise that the host or audience to see the tone and volume change animation.
/// When to call: After the engine is created [createEngine].
/// Caution: [onCapturedSoundLevelUpdate] and [onRemoteSoundLevelUpdate] callback notification period is 100 ms.
- (void)startSoundLevelMonitor;

/// Starts sound level monitoring. Support setting the listening interval.
///
/// Available since: 1.15.0
/// Description: After starting monitoring, you can receive local audio sound level via [onCapturedSoundLevelUpdate] callback, and receive remote audio sound level via [onRemoteSoundLevelUpdate] callback. Before entering the room, you can call [startPreview] with this function and combine it with [onCapturedSoundLevelUpdate] callback to determine whether the audio device is working properly.
/// Use cases: During the publishing and playing process, determine who is talking on the wheat and do a UI presentation.
/// When to call: After the engine is created [createEngine].
/// Caution: [onCapturedSoundLevelUpdate] and [onRemoteSoundLevelUpdate] callback notification period is the value set by the parameter. If you want to use advanced feature of sound level, please use the function of the same name (the parameter type is ZegoSoundLevelConfig) instead.
///
/// @param millisecond Monitoring time period of the sound level, in milliseconds, has a value range of [100, 3000]. Default is 100 ms.
- (void)startSoundLevelMonitor:(unsigned int)millisecond;

/// Starts sound level monitoring. Support enable some advanced feature.
///
/// Available since: 2.10.0
/// Description: After starting monitoring, you can receive local audio sound level via [onCapturedSoundLevelUpdate] callback, and receive remote audio sound level via [onRemoteSoundLevelUpdate] callback. Before entering the room, you can call [startPreview] with this function and combine it with [onCapturedSoundLevelUpdate] callback to determine whether the audio device is working properly.
/// Use cases: During the publishing and playing process, determine who is talking on the wheat and do a UI presentation.
/// When to call: After the engine is created [createEngine].
/// Caution: [onCapturedSoundLevelUpdate] and [onRemoteSoundLevelUpdate] callback notification period is the value set by the parameter.
///
/// @param config Configuration for starts the sound level monitor.
- (void)startSoundLevelMonitorWithConfig:(ZegoSoundLevelConfig *)config;

/// Stops sound level monitoring.
///
/// Available since: 1.1.0
/// Description: After the monitoring is stopped, the callback of the local/remote audio sound level will be stopped.
/// When to call: After the engine is created [createEngine].
/// Related APIs: Soundwave monitoring can be initiated via [startSoundLevelMonitor].
- (void)stopSoundLevelMonitor;

/// Starts audio spectrum monitoring.
///
/// Available since: 1.1.0
/// Description: After starting monitoring, you can receive local audio spectrum via [onCapturedAudioSpectrumUpdate] callback, and receive remote audio spectrum via [onRemoteAudioSpectrumUpdate] callback.
/// Use cases: In the host K song scene, has been published or played under the premise that the host or audience to see the tone and volume change animation.
/// When to call: After the engine is created [createEngine].
/// Caution: [onCapturedAudioSpectrumUpdate] and [onRemoteAudioSpectrumUpdate] callback notification period is 100 ms.
- (void)startAudioSpectrumMonitor;

/// Starts audio spectrum monitoring. Support setting the listening interval.
///
/// Available since: 1.15.0
/// Description: After starting monitoring, you can receive local audio spectrum via [onCapturedAudioSpectrumUpdate] callback, and receive remote audio spectrum via [onRemoteAudioSpectrumUpdate] callback.
/// Use cases: In the host K song scene, has been published or played under the premise that the host or audience to see the tone and volume change animation.
/// When to call: After the engine is created [createEngine].
/// Caution: [onCapturedAudioSpectrumUpdate] and [onRemoteAudioSpectrumUpdate] callback notification period is the value set by the parameter.
///
/// @param millisecond Monitoring time period of the audio spectrum, in milliseconds, has a value range of [100, 3000]. Default is 100 ms.
- (void)startAudioSpectrumMonitor:(unsigned int)millisecond;

/// Stops audio spectrum monitoring.
///
/// Available since: 1.1.0
/// Description: After the monitoring is stopped, the callback of the local/remote audio spectrum will be stopped.
/// When to call: After the engine is created [createEngine].
/// Related APIs: Audio spectrum monitoring can be initiated via [startAudioSpectrumMonitor].
- (void)stopAudioSpectrumMonitor;

/// Enables or disables headphone monitoring.
///
/// Available since: 1.9.0
/// Description: Enable/Disable headphone monitor, and users hear their own voices as they use the microphone to capture sounds.
/// When to call: After the engine is created [createEngine].
/// Default value: Disable.
/// Caution: This setting does not actually take effect until both the headset and microphone are connected.
///
/// @param enable Whether to use headphone monitor, YES: enable, NO: disable
- (void)enableHeadphoneMonitor:(BOOL)enable;

/// Sets the headphone monitor volume.
///
/// Available since: 1.9.0
/// Description: set headphone monitor volume.
/// When to call: After the engine is created [createEngine].
/// Caution: This setting does not actually take effect until both the headset and microphone are connected.
/// Related APIs: Enables or disables headphone monitoring via [enableHeadphoneMonitor].
///
/// @param volume headphone monitor volume, range from 0 to 200, 100 as default.
- (void)setHeadphoneMonitorVolume:(int)volume;

#if TARGET_OS_OSX
/// Enable or disable system audio capture.
///
/// Available since: 1.9.0
/// Description: Enable sound card capture to mix sounds played by the system into the publishing stream, such as sounds played by the browser, sounds played by the third-party player, etc.
/// Default value: Default is disable.
/// When to call: Called this function after calling [startPublishingStream] or [startPreview].
/// Restrictions: None.
/// Caution: The system sound card sound does not include streaming sound, media player sound and sound effect player sound.
/// Related APIs: [setMixSystemPlayoutVolume] function can set system audio capture volume.
/// Platform differences: Only supports Windows and macOS.
///
/// @param enable Whether to mix system playout.
- (void)enableMixSystemPlayout:(BOOL)enable;
#endif

#if TARGET_OS_OSX
/// set system audio capture volume.
///
/// only for macOS
///
/// @param volume the volume. Valid range [0, 200], default is 100.
- (void)setMixSystemPlayoutVolume:(int)volume;
#endif

#if TARGET_OS_OSX
/// Enable or disable mix SDK playout to stream publishing.
///
/// Enable mix SDK playout sounds into the stream publishing... only for macOS.
///
/// @param enable Whether to mix engine playout
- (void)enableMixEnginePlayout:(BOOL)enable;
#endif

/// Start audio VAD stable state monitoring.
///
/// Available: since 2.14.0
/// Description: After monitoring is started, you can use the [onAudioVADStateUpdate] callback to receive the specified type of audio VAD callback.
/// Use cases: For example, when you specify the type of collection and use the microphone to collect, you can check whether the host has continuous and stable voice input through this interface.
/// When to call: Before publish stream, you can call [startPreview] with this function and combine it with [onAudioVADStateUpdate] callback to determine whether the audio device is working properly.
/// Restrictions: [onAudioVADStateUpdate] callback notification period is 3 seconds.
/// Related APIs: [stopAudioVADStableStateMonitor].
///
/// @param type audio VAD monitor type.
- (void)startAudioVADStableStateMonitor:(ZegoAudioVADStableStateMonitorType)type;

/// Stop audio VAD stable state monitoring.
///
/// Available: since 2.14.0
/// Description: After calling this interface, the specified type of [onAudioVADStateUpdate] callback can no longer be received.
/// When to call: None.
/// Restrictions: [onAudioVADStateUpdate] callback notification period is 3 seconds.
/// Related APIs: [startAudioVADStableStateMonitor].
///
/// @param type audio VAD monitor type.
- (void)stopAudioVADStableStateMonitor:(ZegoAudioVADStableStateMonitorType)type;

#if TARGET_OS_OSX
/// Get the audio device information currently in use.
///
/// Available since: 2.12.0
/// Description: Get the audio device information currently in use.
/// Use cases: Used for scenes that need to manually switch between multiple audio devices.
/// When to call: Called this function after calling [startPublishingStream] or [startPreview].
/// Restrictions: Only supports Windows and macOS.
/// Related APIs: The default audio device ID can be obtained through [getDefaultAudioDeviceID].
///
/// @param deviceType Audio device type.Required:Yes.
/// @return Audio device information.
- (ZegoDeviceInfo *)getCurrentAudioDevice:(ZegoAudioDeviceType)deviceType;
#endif

#if TARGET_OS_IPHONE
/// [Deprecated] Whether to use the built-in speaker to play audio.This function has been deprecated since version 2.3.0 Please use [setAudioRouteToSpeaker] instead.
///
/// This function has been deprecated since version 2.3.0 Please use [setAudioRouteToSpeaker] instead.
/// When you choose not to use the built-in speaker to play sound, that is, set to NO, the SDK will select the currently highest priority audio output device to play the sound according to the system schedule
///
/// @deprecated This function has been deprecated since version 2.3.0 Please use [setAudioRouteToSpeaker] instead.
/// @param enable Whether to use the built-in speaker to play sound, YES: use the built-in speaker to play sound, NO: use the highest priority audio output device scheduled by the current system to play sound
- (void)setBuiltInSpeakerOn:(BOOL)enable DEPRECATED_ATTRIBUTE;
#endif

@end

NS_ASSUME_NONNULL_END
