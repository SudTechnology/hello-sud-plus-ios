//
//  SudAudioPlayer.m
//  HelloSud-iOS
//
//  Created by kaniel on 3/19/25.
//

#import "SudAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SudAudioItem()
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation SudAudioItem

@end

@interface SudAudioPlayer()<AVAudioPlayerDelegate>
@property(nonatomic, strong)AVAudioPlayer *audioPlayer;
@property(nonatomic, strong)NSMutableArray <SudAudioItem *>*waitPlayAudioList;
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
    if (self.audioPlayer) {
        [self.audioPlayer stop];
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
    
    if (audioItem.playStateChangedBlock) {
        audioItem.playStateChangedBlock(audioItem, SudAudioItemPlayerStatePlaying);
    }
    
}

- (void)handleFinished:(AVAudioPlayer *)player {
    [self.audioPlayers removeObject:player];
    NSArray *tmpList = self.waitPlayAudioList.copy;
    for (SudAudioItem *item in tmpList) {
        if (item.audioPlayer == player) {
            if (item.playStateChangedBlock) {
                item.playStateChangedBlock(item, SudAudioItemPlayerStateFinished);
            }
            [self.waitPlayAudioList removeObject:item];
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
