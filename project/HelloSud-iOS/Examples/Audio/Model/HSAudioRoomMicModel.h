//
//  HSAudioRoomMicModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 房间麦位信息
@interface HSAudioRoomMicModel : BaseModel
/// 麦上用户
@property(nonatomic, strong, nullable)HSAudioUserModel *user;
/// 麦位索引
@property(nonatomic, assign)NSInteger micIndex;
/// 麦位推流ID
@property(nonatomic, assign)NSString * streamID;

/// 是否选中
@property(nonatomic, assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
