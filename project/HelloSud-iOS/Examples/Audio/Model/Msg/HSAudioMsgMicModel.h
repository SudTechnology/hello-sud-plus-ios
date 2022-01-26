//
//  HSAudioMsgMicModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 麦位操作消息model
@interface HSAudioMsgMicModel : HSAudioMsgBaseModel

/// 麦位索引
@property(nonatomic, assign)NSInteger micIndex;

/// 构建上麦消息
/// @param micIndex micIndex description
+ (instancetype)makeUpMicMsgWithMicIndex:(NSInteger)micIndex;

/// 构建下麦消息
/// @param micIndex micIndex description
+ (instancetype)makeDownMicMsgWithMicIndex:(NSInteger)micIndex;

- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END
