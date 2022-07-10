//
//  AudioMsgSystemModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/8.
//

#import "RoomBaseCMDModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioMsgSystemModel : RoomBaseCMDModel
/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsgWithAttr:(NSMutableAttributedString*)content;
/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsg:(NSString*)content;

/// 设置内容
/// @param content 内容
- (void)updateContent:(NSString *)content;
- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END
