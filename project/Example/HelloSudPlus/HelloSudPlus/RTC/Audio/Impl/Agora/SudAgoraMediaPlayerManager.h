//
//  SudAgoraMediaPlayerManager.h
//  HelloSudPlus
//
//  Created by kaniel on 4/28/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioCommon.h"
NS_ASSUME_NONNULL_BEGIN

@interface SudAgoraMediaPlayerManager : NSObject
- (void)playLocalAudio:(SudRtcAudioItem *)item;
- (void)setupAgoraEngine:(id)engine;
@end

NS_ASSUME_NONNULL_END
