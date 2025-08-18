//
//  SoundShowView.h
//  HelloSudPlus
//
//  Created by kaniel on 6/24/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SoundShowViewAudioType) {
    SoundShowViewAudioTypeEmpty = 0,
    SoundShowViewAudioTypeExist = 1,
};


@interface SoundShowView : BaseView
@property(nonatomic, strong)NSString *tipText;
/// 声音数据
@property(nonatomic, strong)NSData *audioData;
@property (nonatomic, strong)void(^clickAddBlock)(void);
@property (nonatomic, strong)void(^noAudioPlayBlock)(void);
- (void)checkAndPlay;
- (void)changeAudioType:(SoundShowViewAudioType)audioState;
@end

NS_ASSUME_NONNULL_END
