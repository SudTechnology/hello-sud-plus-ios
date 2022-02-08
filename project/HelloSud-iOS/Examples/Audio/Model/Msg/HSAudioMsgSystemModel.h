//
//  HSAudioMsgSystemModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/8.
//

#import "HSAudioMsgBaseModel.h"
#import "GamePublicMsgModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSAudioMsgSystemModel : HSAudioMsgBaseModel

/// 消息内容
@property(nonatomic, strong)GamePublicMsgModel *msgModel;
@property(nonatomic, copy)NSString *language;

/// 构建消息
/// @param msgModel 消息内容
/// @param language 语言
+ (instancetype)makeMsg:(GamePublicMsgModel *)msgModel language: (NSString *)language;
- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END
