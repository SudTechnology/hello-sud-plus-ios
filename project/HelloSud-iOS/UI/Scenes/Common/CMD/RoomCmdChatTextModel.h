//
//  RoomCmdChatTextModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "BaseModel.h"
#import "RoomBaseCMDModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 公屏文本消息model
@interface RoomCmdChatTextModel : RoomBaseCMDModel

/// 消息内容
@property(nonatomic, copy)NSString *content;

/// 是否隐藏头像
@property(nonatomic, assign)BOOL hiddeHeadIcon;

/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsg:(NSString *)content;
- (NSAttributedString *)attrContent;
@end

NS_ASSUME_NONNULL_END
