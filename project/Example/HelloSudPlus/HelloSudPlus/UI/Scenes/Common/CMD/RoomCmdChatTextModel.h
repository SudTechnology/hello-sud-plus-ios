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
/// 是否跳过解析
@property (nonatomic, assign)BOOL skipParseGameKey;

/// 构建消息
/// @param content 消息内容
+ (instancetype)makeMsg:(NSString *)content;
- (NSAttributedString *)attrContent;
- (void)refreshAttrContent:(void (^)(void))completed;
@end

/// 公屏消息V2 支持多媒体
@interface RoomCmdChatTextModelV2 : RoomCmdChatTextModel

typedef NS_ENUM(NSInteger, RoomScreenMsgType) {
    RoomScreenMsgTypeText = 0,/// 普通文本
    RoomScreenMsgTypeVoice = 1,/// 不可读语音
};
@property(nonatomic, assign)RoomScreenMsgType msgType;

/// 构建语音消息
+ (instancetype)makeAudioMsg;
@end

NS_ASSUME_NONNULL_END
