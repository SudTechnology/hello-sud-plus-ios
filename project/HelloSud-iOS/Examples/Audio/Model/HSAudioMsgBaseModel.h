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

/// 语音房消息基类model
@interface HSAudioMsgBaseModel : BaseModel

/// 指令值
@property(nonatomic, assign)NSInteger cmd;

/// 发送者信息
@property(nonatomic, strong)HSAudioUserModel *sendUser;

/// 获取model对应cell名称
-(NSString *)cellName;

/// 配置消息
/// @param cmd 消息指令
- (void)configBaseInfoWithCmd:(NSInteger)cmd;
@end

NS_ASSUME_NONNULL_END
