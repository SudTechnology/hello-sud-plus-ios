//
//  SudAudioPlayer.h
//  HelloSud-iOS
//
//  Created by kaniel on 3/19/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SudAudioItemPlayerState) {
    SudAudioItemPlayerStatePlaying = 0, // 播放中
    SudAudioItemPlayerStateFinished = 1// 结束
};

@interface SudAudioItem : NSObject
@property(nonatomic, strong)NSData *audioData;
@property(nonatomic, strong)void(^playStateChangedBlock)(SudAudioItem*item, SudAudioItemPlayerState playerState);
@property(nonatomic, strong)id extra;
@end

/// 语音播放
@interface SudAudioPlayer : NSObject
+(instancetype)shared;

- (void)playeAudio:(SudAudioItem *)audioData;
// 一直单次播放
- (void)playeAudioSingle:(SudAudioItem *)audioData;
// 并发播放
- (void)playeAudioMulti:(SudAudioItem *)audioData;
@end

NS_ASSUME_NONNULL_END
