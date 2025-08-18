//
//  SudAudioCapture.m
//  SudMGPSDK_Example
//
//  Created by mihuasama on 2021/12/16.
//  Copyright © 2021 dingguanghui. All rights reserved.
//

#import "SudAudioCapture.h"
#import <AVFoundation/AVFoundation.h>

#define Audio_SampleRate 16000
#define bitW             16
#define channels         1

@interface SudAudioCapture () <AVAudioRecorderDelegate>
@property (nonatomic,strong) AVAudioEngine *audioEngine;
@property(nonatomic, strong)AVAudioFormat *recordingFormat;
@property(nonatomic, strong)AVAudioFile *outputFile;
@property(nonatomic, strong) void(^resultFileBlock)(NSString *filePath);
@property(nonatomic, strong)NSString *tempFilePath;


@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) NSURL *audioFileURL;
@end

@implementation SudAudioCapture

/// 转换到data数据
/// - Parameter audioFrameData: audioFrameData description
- (void)startAudioRecordingWithFrameData:(void(^)(NSData *audioFrameData))audioFrameDataBlock {
    [self startAudioRecording:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        /// pcm
        NSData * data = [NSData dataWithBytes:buffer.int16ChannelData[0] length:buffer.frameLength * buffer.format.streamDescription->mBytesPerFrame];
        if (audioFrameDataBlock) {
            audioFrameDataBlock(data);
        }
    }];
}


/// 录制语音文件
/// - Parameter audioFileBlock: audioFileBlock description
- (void)startAudioRecordingWithTempFile:(void(^)(NSString *filePath))audioFileBlock {
    
    self.resultFileBlock = audioFileBlock;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setActive:YES error:&error];
    
    // Check for errors
    if (error) {
        NSLog(@"Error setting up audio session: %@", error.localizedDescription);
    }
    
    // Set the audio file URL
    NSString *path = [NSTemporaryDirectory() stringByAppendingFormat:@"%@.wav", NSUUID.UUID.UUIDString];
    self.tempFilePath = path;
    self.audioFileURL = [NSURL fileURLWithPath:path];
    
    // Set up the audio recording settings
    NSDictionary *settings = @{
        AVFormatIDKey: @(kAudioFormatLinearPCM),
        AVSampleRateKey: @44100.0,
        AVNumberOfChannelsKey: @1,
        AVLinearPCMBitDepthKey: @16,
        AVLinearPCMIsFloatKey: @NO,
        AVEncoderAudioQualityKey: @(AVAudioQualityHigh)
    };
    
    
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:self.audioFileURL settings:settings error:&error];
    
    if (error) {
        NSLog(@"Error initializing audio recorder: %@", error.localizedDescription);
    } else {
        self.audioRecorder.delegate = self;
        [self.audioRecorder prepareToRecord];
    }
    
    [self.audioRecorder record];

}

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

- (void)setupAudioEngine {
    self.audioEngine = [[AVAudioEngine alloc] init];
    
    // 获取输入节点（麦克风）
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    
    // 设置录音格式为 PCM (WAV 的基础)
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    
    // 创建 WAV 格式设置
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                              nil];
    
    self.recordingFormat = [[AVAudioFormat alloc] initWithSettings:settings];
    

}

- (void)stopCapture {
    DDLogDebug(@"stopCapture");
    if (self.audioEngine.isRunning) {
        [self.audioEngine stop];
        AVAudioInputNode *inputNode = self.audioEngine.inputNode;
        [inputNode removeTapOnBus:0];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        [audioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
        NSParameterAssert(!error);
        [audioSession setMode:AVAudioSessionModeDefault error:&error];
        NSParameterAssert(!error);
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        NSParameterAssert(!error);
        
        if (self.resultFileBlock) {
            self.resultFileBlock(self.tempFilePath);
        }
    }
    
    if (self.audioRecorder) {
        [self.audioRecorder stop];
    }
}

#pragma mark - =======Lazy=======
- (AVAudioEngine *)audioEngine {
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"Recording finished successfully.");
        // You can handle the recorded file here (e.g., playback or save)
    } else {
        NSLog(@"Recording failed.");
    }
    DDLogDebug(@"audioRecorderDidFinishRecording tempFilePath:%@",self.tempFilePath);
    if (self.resultFileBlock) {
        self.resultFileBlock(self.tempFilePath);
    }
}

@end
