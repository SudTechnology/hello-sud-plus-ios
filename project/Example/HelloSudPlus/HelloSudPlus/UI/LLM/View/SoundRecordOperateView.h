//
//  SoundRecordOperateView.h
//  HelloSudPlus
//
//  Created by kaniel on 6/24/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SoundStateType) {
    SoundStateTypeEmpty = 0,
    SoundStateTypeExist = 1,
    SoundStateTypeRecording = 2,
    SoundStateTypeRecordEnd = 3,
};
/// 声音录制
@interface SoundRecordOperateView : BaseView
@property(nonatomic, strong)void(^submitClick)(NSData *audioData);
@property(nonatomic, strong)void(^cancelClick)();
- (void)clearAudioData;
- (void)changeStateType:(SoundStateType)stateType;
@end

NS_ASSUME_NONNULL_END
