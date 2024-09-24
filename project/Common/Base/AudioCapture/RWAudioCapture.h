//
//  RWAudioCapture.h
//  SudMGPSDK_Example
//
//  Created by mihuasama on 2021/12/16.
//  Copyright © 2021 dingguanghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RWAudioCapture : NSObject
- (void)startAudioRecording:(AVAudioNodeTapBlock)audioCaptureCallback;
- (void)stopCapture;
@end

NS_ASSUME_NONNULL_END
