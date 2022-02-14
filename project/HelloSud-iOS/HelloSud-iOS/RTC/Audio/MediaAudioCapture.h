//
//  MediaAudioCapture.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 音频采集
@interface MediaAudioCapture : NSObject
typedef void(^OnAudioCallBack)(NSData *data);
@property (nonatomic, copy) OnAudioCallBack onAudioCallBack;

- (void)startAudioRecording:(OnAudioCallBack)audioCallBack;
- (void)stopCapture;
@end

NS_ASSUME_NONNULL_END
