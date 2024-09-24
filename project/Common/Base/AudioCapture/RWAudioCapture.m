//
//  RWAudioCapture.m
//  SudMGPSDK_Example
//
//  Created by mihuasama on 2021/12/16.
//  Copyright © 2021 dingguanghui. All rights reserved.
//

#import "RWAudioCapture.h"

#define Audio_SampleRate 16000
#define bitW             16
#define channels         1

@interface RWAudioCapture ()
@property (nonatomic,strong) AVAudioEngine *audioEngine;

@end

@implementation RWAudioCapture

- (void)startAudioRecording:(AVAudioNodeTapBlock)audioCaptureCallback {
    if (self.audioEngine.isRunning) {
        return;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    [audioSession setPreferredSampleRate:Audio_SampleRate error:&error];
    NSParameterAssert(!error);
    [audioSession setPreferredIOBufferDuration:(0.0016) error:&error];
    NSParameterAssert(!error);
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    AVAudioFormat *format = [inputNode inputFormatForBus:0];
    NSMutableDictionary * settings = [NSMutableDictionary dictionaryWithDictionary:format.settings];
    settings[AVLinearPCMBitDepthKey] = @(bitW);
    settings[AVSampleRateKey]        = @(Audio_SampleRate);
    settings[AVLinearPCMIsFloatKey]  = @(0);
    settings[AVNumberOfChannelsKey]  = @(channels);
    AVAudioFormat * audioFormat = [[AVAudioFormat alloc]initWithSettings:settings];
    
    @try {
        [inputNode removeTapOnBus:0];
    } @catch (NSException *exception) {
        NSLog(@"removeTapOnBus exception");
    }
    
    @try {
        [inputNode installTapOnBus:0 bufferSize:1024 format:audioFormat block:audioCaptureCallback];
    } @catch (NSException *exception) {
        NSLog(@"installTapOnBus exception");
    }

    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
}

- (void)stopCapture {
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
        NSParameterAssert(!error);
        [audioSession setMode:AVAudioSessionModeDefault error:&error];
        NSParameterAssert(!error);
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        NSParameterAssert(!error);
    }
}

#pragma mark - =======Lazy=======
- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}

@end
