//
//  MediaAudioCapture.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/14.
//

#import "MediaAudioCapture.h"
#import <ZegoExpressEngine/ZegoExpressEngine.h>

@interface MediaAudioCapture()<ZegoAudioDataHandler>
@end
@implementation MediaAudioCapture

- (instancetype)init {
    if (self = [super init]) {
//        [self config];
    }
    return self;
}

- (void)config {
    // 需要的音频数据类型 Bitmask，此处示例三个回调都开启
    ZegoAudioDataCallbackBitMask bitmask = ZegoAudioDataCallbackBitMaskCaptured | ZegoAudioDataCallbackBitMaskPlayback | ZegoAudioDataCallbackBitMaskMixed;

    // 需要的音频数据参数，此处示例单声道、16K
    ZegoAudioFrameParam *param = [[ZegoAudioFrameParam alloc] init];
    param.channel = ZegoAudioChannelMono;
    param.sampleRate = ZegoAudioSampleRate16K;

    // 开启获取原始音频数据功能
    [[ZegoExpressEngine sharedEngine] startAudioDataObserver:bitmask param:param];
}

- (void)startAudioRecording:(OnAudioCallBack)audioCallBack {
    self.onAudioCallBack = audioCallBack;
    // 设置音频数据回调
    [[ZegoExpressEngine sharedEngine] setAudioDataHandler:self];
}

- (void)stopCapture {
    [[ZegoExpressEngine sharedEngine] setAudioDataHandler:nil];
}

// 根据需要实现以下三个回调，分别对应上述 Bitmask 的三个选项

- (void)onCapturedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 本地采集音频数据，推流后可收到回调
    if (self.onAudioCallBack) {
        NSData *a_data = [[NSData alloc] initWithBytes:data length:dataLength];
        self.onAudioCallBack(a_data);
    }
}

- (void)onPlaybackAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 远端拉流音频数据，开始拉流后可收到回调
}

- (void)onMixedAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param {
    // 本地采集与远端拉流声音混合后的音频数据回调
}

- (void)onPlayerAudioData:(const unsigned char *)data dataLength:(unsigned int)dataLength param:(ZegoAudioFrameParam *)param streamID:(NSString *)streamID {
    // 远端拉流音频数据，开始拉流后每条拉流数据的回调
}
@end
