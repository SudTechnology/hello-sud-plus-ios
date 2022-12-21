//
//  AudioRoomMicModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 互动礼物banner
@interface InteractiveGameBannerModel : BaseModel
/// 麦上用户
@property(nonatomic, strong, nullable) NSString *image;
@property(nonatomic, assign) int64_t gameId;
@end

NS_ASSUME_NONNULL_END
