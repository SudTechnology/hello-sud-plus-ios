//
//  SudAudioPlayer.m
//  HelloSud-iOS
//
//  Created by kaniel on 3/19/25.
//

#import "SudAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "DTTimer.h"

@interface SudAudioItem()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic, strong)DTTimer *volumeTimer;
@end

@implementation SudAudioItem


- (void)handleAudioStateChanged:(SudAudioItemPlayerState)stateType {
    WeakSelf
    switch (stateType) {
        case SudAudioItemPlayerStatePlaying:{
            
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
        case SudAudioItemPlayerStateFinished:{
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

@interface SudAudioPlayer()<AVAudioPlayerDelegate>
@property(nonatomic, strong)AVAudioPlayer *audioPlayer;
@property(nonatomic, strong)NSMutableArray <SudAudioItem *>*waitPlayAudioList;
@property(nonatomic, strong)NSMutableArray <SudAudioItem *>*audioPlayerItems;
@property (nonatomic, strong) NSMutableArray<AVAudioPlayer *> *audioPlayers;
@property(nonatomic, assign)BOOL isQueuePlayer;
@end

@implementation SudAudioPlayer

+(instancetype)shared {
    static SudAudioPlayer *g_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_instance = SudAudioPlayer.new;
        [g_instance setupAudioSession];
    });
    return g_instance;
}


- (NSMutableArray *)audioPlayers {
    if (!_audioPlayers) {
        _audioPlayers = NSMutableArray.new;
    }
    return _audioPlayers;
}

- (NSMutableArray *)waitPlayAudioList {
    if (!_waitPlayAudioList) {
        _waitPlayAudioList = NSMutableArray.new;
    }
    return _waitPlayAudioList;
}

- (NSMutableArray *)audioPlayerItems {
    if (!_audioPlayerItems) {
        _audioPlayerItems = NSMutableArray.new;
    }
    return _audioPlayerItems;
}



- (void)playeAudio:(SudAudioItem *)audioData {
    if (!audioData) {
        NSLog(@"addPlayAudio is empty");
        return;
    }

    self.isQueuePlayer = YES;
    [self.waitPlayAudioList addObject:audioData];
    [self checkToPlayer];
}

- (void)playeAudioMulti:(SudAudioItem *)audioData {
    if (!audioData) {
        NSLog(@"addPlayAudio is empty");
        return;
    }
    [self.waitPlayAudioList addObject:audioData];
    [self play:audioData];
}

// 一直单次播放
- (void)playeAudioSingle:(SudAudioItem *)audioData {
    NSArray *arr = self.audioPlayers.copy;
    for (AVAudioPlayer *player in arr) {
        [player stop];
    }
    [self play:audioData];
}

- (void)setupAudioSession {
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSError *error = nil;
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
//    if (error) {
//        NSLog(@"Error setting up audio session category: %@", error.localizedDescription);
//    }
//    [audioSession setActive:YES error:&error];
//    if (error) {
//        NSLog(@"Error activating audio session: %@", error.localizedDescription);
//    }
}

- (void)play:(SudAudioItem *)audioItem {
    
    NSError *error = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];

    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc]initWithData:audioItem.audioData error:&error];
    audioItem.audioPlayer = audioPlayer;
    audioPlayer .delegate = self;
    if (error) {
        NSLog(@"audioPlayer error:%@", error);
        return;
    }
    [audioPlayer prepareToPlay];
    BOOL bPlaySate = [audioPlayer  play];
    if (!bPlaySate) {
        NSLog(@"audioPlayer prepareToPlay failed");
    }
    [self.audioPlayers addObject:audioPlayer];
    NSLog(@"audioPlayers count:%@", @(self.audioPlayers.count));
    [audioItem handleAudioStateChanged:SudAudioItemPlayerStatePlaying];
    [self.audioPlayerItems addObject:audioItem];
}

- (void)handleFinished:(AVAudioPlayer *)player {
    [self.audioPlayers removeObject:player];
    NSArray *tmpList = self.waitPlayAudioList.copy;
    for (SudAudioItem *item in tmpList) {
        if (item.audioPlayer == player) {
            [item handleAudioStateChanged:SudAudioItemPlayerStateFinished];
            [self.waitPlayAudioList removeObject:item];
            break;
        }
    }
    
    tmpList = self.audioPlayerItems.copy;
    for (SudAudioItem *item in tmpList) {
        if (item.audioPlayer == player) {
            [item handleAudioStateChanged:SudAudioItemPlayerStateFinished];
            [self.audioPlayerItems removeObject:item];
            break;
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self handleFinished:player];
    [self checkToPlayer];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    [self handleFinished:player];
    [self checkToPlayer];
    NSLog(@"audioPlayerDecodeErrorDidOccur:%@", error);
}

- (void)checkToPlayer {
    if (!self.isQueuePlayer) {
        return;
    }
    if (self.waitPlayAudioList.count == 0) {
        return;
    }
    if (self.audioPlayers.count > 0) {
        return;
    }
    SudAudioItem * audioItem = [self.waitPlayAudioList objectAtIndex:0];
    [self play:audioItem];
    
}
@end
