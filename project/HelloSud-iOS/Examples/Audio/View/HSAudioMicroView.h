//
//  HSAudioMicroView.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 麦位view
@interface HSAudioMicroView : BaseView

typedef NS_ENUM(NSInteger, MicType) {
    HSAudioMic,
    HSGameMic,
};
@property (nonatomic, assign) MicType micType;

@end

NS_ASSUME_NONNULL_END
