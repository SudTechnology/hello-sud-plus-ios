//
//  SudAgoraMediaPlayerManager.m
//  HelloSudPlus
//
//  Created by kaniel on 4/28/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudAgoraMediaPlayerManager.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

@interface SudAgoraMediaPlayTaskItem : NSObject
@property(nonatomic, strong)id<AgoraRtcMediaPlayerProtocol> mediaPlayer;
@property(nonatomic, strong)NSString *path;
@property(nonatomic, strong)SudRtcAudioItem *audioItem;
@end

@implementation SudAgoraMediaPlayTaskItem

- (void)handleFinished {
    if (self.path){
        [NSFileManager.defaultManager removeItemAtPath:self.path error:nil];
    }
    if (self.audioItem.playStateChangedBlock) {
        self.audioItem.playStateChangedBlock(self.audioItem, SudRtcAudioItemPlayerStateFinished);
    }
}

@end

@interface SudAgoraMediaPlayerManager()<AgoraRtcMediaPlayerDelegate>
@property(nonatomic, weak)AgoraRtcEngineKit *engine;
@property(nonatomic, strong)NSMutableArray *taskList;
@end

@implementation SudAgoraMediaPlayerManager

- (void)setupAgoraEngine:(id)engine {
    self.engine = engine;
}

- (void)playLocalAudio:(SudRtcAudioItem *)item {
    
    if (self.engine != nil) {
        
        SudAgoraMediaPlayTaskItem *taskItem = SudAgoraMediaPlayTaskItem.new;
        
        NSString *tempFilePath = [NSTemporaryDirectory() stringByAppendingFormat:@"%@.mp3", @(arc4random())];
        [item.audioData writeToFile:tempFilePath atomically:YES];
        NSURL *fileUrl = [NSURL fileURLWithPath:tempFilePath];
        id<AgoraRtcMediaPlayerProtocol> mediaPlayer = [self.engine createMediaPlayerWithDelegate:self];
//        [mediaPlayer playPreloadedSrc:fileUrl.absoluteString];
        [mediaPlayer open:fileUrl.absoluteString startPos:0];
        
        taskItem.audioItem = item;
        taskItem.mediaPlayer = mediaPlayer;
        taskItem.path = tempFilePath;
        [self.taskList addObject:taskItem];
    }
}

- (NSMutableArray *)taskList {
    if(!_taskList) {
        _taskList = NSMutableArray.new;
    }
    return _taskList;
}

- (void)AgoraRtcMediaPlayer:(id<AgoraRtcMediaPlayerProtocol> _Nonnull)playerKit
          didChangedToState:(AgoraMediaPlayerState)state
                      error:(AgoraMediaPlayerError)error{
    DDLogDebug(@"didChangedToState:%@", @(state));
    switch (state) {
        case AgoraMediaPlayerStateOpenCompleted:{
            // 资源打开完毕，开始播放
            [playerKit play];
            NSArray *tempList = self.taskList.copy;
            for (SudAgoraMediaPlayTaskItem *item in self.taskList) {
                if (item.mediaPlayer == playerKit) {
                    item.audioItem.playStateChangedBlock(item.audioItem, SudRtcAudioItemPlayerStatePlaying);
                    break;
                }
            }
        }
            break;
        case AgoraMediaPlayerStatePlayBackCompleted:
        case AgoraMediaPlayerStatePlayBackAllLoopsCompleted:
        case AgoraMediaPlayerStateFailed:{
            // 播放结束
            NSArray *tempList = self.taskList.copy;
            for (SudAgoraMediaPlayTaskItem *item in tempList) {
                if (item.mediaPlayer == playerKit) {
                    [item handleFinished];
                    [self.engine destroyMediaPlayer:playerKit];
                    [self.taskList removeObject:item];
                    break;
                }
            }
        }
            
        default:
            break;
    }
    
}
@end
