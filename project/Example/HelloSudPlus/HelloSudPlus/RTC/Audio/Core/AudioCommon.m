//
//  MediaAudioCommon.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "AudioCommon.h"


/// 媒体流信息
@implementation AudioStream
@end

@interface SudRtcAudioItem()

@property(nonatomic, strong)DTTimer *volumeTimer;
@end


@implementation SudRtcAudioItem


- (void)handleAudioStateChanged:(SudRtcAudioItemPlayerState)stateType {
    WeakSelf
    switch (stateType) {
        case SudRtcAudioItemPlayerStatePlaying:{
            
            NSString *userId = @"";
            if ([self.extra isKindOfClass:NSString.class]) {
                userId = self.extra;
            }
            NSInteger soundLevel =  arc4random() % 100;
            [[NSNotificationCenter defaultCenter] postNotificationName:NTF_REMOTE_VOICE_VOLUME_CHANGED object:nil userInfo:@{@"dicVolume": @{userId:@(soundLevel)}}];
            if (!self.volumeTimer) {
                self.volumeTimer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
                    NSInteger soundLevel =  arc4random() % 100;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NTF_REMOTE_VOICE_VOLUME_CHANGED object:nil userInfo:@{@"dicVolume": @{userId:@(soundLevel)}}];
                }];
            }
        }
            break;
        case SudRtcAudioItemPlayerStateFinished:{
            if (self.volumeTimer) {
                [self.volumeTimer stopTimer];
            }
        }
            
        default:
            break;
    }

    if (self.playStateChangedBlock) {
        self.playStateChangedBlock(self, stateType);
    }
}

- (void)dealloc {
    if (self.volumeTimer) {
        [self.volumeTimer stopTimer];
    }
}
@end
