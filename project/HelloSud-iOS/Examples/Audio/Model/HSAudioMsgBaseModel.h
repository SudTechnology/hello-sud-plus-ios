//
//  HSAudioMsgBaseModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import <Foundation/Foundation.h>
#import "HSAudioUserModel.h"
#import "HSAudioMsgConst.h"
NS_ASSUME_NONNULL_BEGIN

/// 语音房消息model
@interface HSAudioMsgBaseModel : BaseModel

/// 指令值
@property(nonatomic, assign)NSInteger cmd;

/// 发送者信息
@property(nonatomic, strong)HSAudioUserModel *sendUser;
-(NSString *)cellName;
@end

NS_ASSUME_NONNULL_END
