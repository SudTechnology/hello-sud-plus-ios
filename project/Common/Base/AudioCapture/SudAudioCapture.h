//
//  SudAudioCapture.h
//  SudMGPSDK_Example
//
//  Created by mihuasama on 2021/12/16.
//  Copyright © 2021 dingguanghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SudAudioCapture : NSObject

/// 原始音频数据
/// - Parameter audioCaptureCallback: audioCaptureCallback description
- (void)startAudioRecording:(AVAudioNodeTapBlock)audioCaptureCallback;

/// 转换到data数据
/// - Parameter audioFrameData: audioFrameData description
- (void)startAudioRecordingWithFrameData:(void(^)(NSData *audioFrameData))audioFrameDataBlock;
/// 录制语音文件
/// - Parameter audioFileBlock: audioFileBlock description
- (void)startAudioRecordingWithTempFile:(void(^)(NSString *filePath))audioFileBlock;

- (void)stopCapture;
@end

NS_ASSUME_NONNULL_END
