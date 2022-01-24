//
//  HSAudioMsgTextModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "BaseModel.h"
#import "HSAudioMsgBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 公屏文本消息
@interface HSAudioMsgTextModel : HSAudioMsgBaseModel

/// 消息内容
@property(nonatomic, copy)NSString *content;
@end

NS_ASSUME_NONNULL_END
