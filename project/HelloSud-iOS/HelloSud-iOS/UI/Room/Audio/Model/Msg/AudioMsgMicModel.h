//
//  AudioMsgMicModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "AudioMsgBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 麦位操作消息model
@interface AudioMsgMicModel : AudioMsgBaseModel

/// 麦位索引
@property(nonatomic, assign)NSInteger micIndex;
/// 麦位角色
@property(nonatomic, assign)NSInteger roleType;
/// 流ID
@property(nonatomic, copy, nullable)NSString *streamID;

/// 构建上麦消息
/// @param micIndex micIndex description
+ (instancetype)makeUpMicMsgWithMicIndex:(NSInteger)micIndex;

/// 构建下麦消息
/// @param micIndex micIndex description
+ (instancetype)makeDownMicMsgWithMicIndex:(NSInteger)micIndex;

- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END