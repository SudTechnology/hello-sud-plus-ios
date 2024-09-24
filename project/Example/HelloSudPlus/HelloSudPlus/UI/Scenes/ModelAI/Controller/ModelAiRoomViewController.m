//
//  AudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "ModelAiRoomViewController.h"
#import "EnterRoomModel.h"
#import "ModelAiRoomOperatorView.h"
#import "RWAudioCapture.h"

@interface ModelAiRoomViewController (){
    ModelAiRoomOperatorView *_modelAiRoomOperatorView;
}

@property(nonatomic, strong)NSMutableData *audioData;
@property (nonatomic, strong) RWAudioCapture *audioCapture;
@end

@implementation ModelAiRoomViewController
- (void)dtAddViews {
    [super dtAddViews];
    
    

}

/// 发送公屏文本消息
/// @param content content
- (void)sendContentMsg:(NSString *)content {
    [super sendContentMsg:content];
    [self sendTextToGame:content];
}

- (NSMutableData *)audioData {
    if (!_audioData) {
        _audioData = NSMutableData.new;
    }
    return _audioData;
}

- (RWAudioCapture *)audioCapture {
    if (!_audioCapture) {
        _audioCapture = [[RWAudioCapture alloc]init];
    }
    return _audioCapture;
}

- (void)handleRecordDown {
    WeakSelf
    [self.audioCapture startAudioRecording:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        /// pcm
        NSData * data = [NSData dataWithBytes:buffer.int16ChannelData[0] length:buffer.frameLength * buffer.format.streamDescription->mBytesPerFrame];
        [self.audioData appendData:data];
        
    }];
}


- (void)handleRecordUp {
    [self.audioCapture stopCapture];
    NSData *pcmData =self.audioData.copy;
    [self.audioData replaceBytesInRange:NSMakeRange(0, self.audioData.length) withBytes:nil length:0];
    /// 发送语音消息
    RoomCmdChatTextModelV2 *m = [RoomCmdChatTextModelV2 makeAudioMsg];
    m.skipParseGameKey = YES;
    [kDiscoRoomService.currentRoomVC sendMsg:m isAddToShow:YES finished:nil];
    [self sendAudioToGame:pcmData];
}

- (void)sendAudioToGame:(NSData *)pcmData {
    
    DDLogDebug(@"sendAudioToGame:%@", pcmData);
    NSMutableDictionary *payload = [[NSMutableDictionary alloc]init];
    payload[@"type"] = @"1";
    NSMutableDictionary *audioDic = NSMutableDictionary.new;
    audioDic[@"audio_base64"] = [pcmData base64EncodedStringWithOptions:0];
    audioDic[@"audio_format"] = @"PCM";
    audioDic[@"sample_rate"] = @"16k";
    payload[@"audio"] = audioDic;

    [self.gameEventHandler.sudFSTAPPDecorator notifyStateChange:@"app_happy_goat_chat" dataJson:payload.mj_JSONString];
}


- (void)sendTextToGame:(NSString *)content {
    DDLogDebug(@"sendTextToGame:%@", content);
    if (content.length == 0) {
        DDLogWarn(@"sendTextToGame, but content is empty, skip it !!!");
        return;
    }
    NSMutableDictionary *payload = [[NSMutableDictionary alloc]init];
    payload[@"type"] = @"0";
    NSMutableDictionary *textDic = NSMutableDictionary.new;
    textDic[@"text"] = content;
    payload[@"text"] = textDic;

    [self.gameEventHandler.sudFSTAPPDecorator notifyStateChange:@"app_happy_goat_chat" dataJson:payload.mj_JSONString];
}

- (RoomOperatorView *)operatorView {
    if (!_modelAiRoomOperatorView) {
        _modelAiRoomOperatorView = [[ModelAiRoomOperatorView alloc] init];
        WeakSelf;
        _modelAiRoomOperatorView.recordTouchUpBlock = ^{
            [weakSelf handleRecordUp];
        };
        
        _modelAiRoomOperatorView.recordTouchDownBlock = ^{
            [weakSelf handleRecordDown];
        };
    }
    return _modelAiRoomOperatorView;
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];


}

- (BOOL)isShowAddRobotBtn {
    return NO;
}

///// 是否展示火箭
- (BOOL)shouldShowRocket {
    return NO;
}
@end
