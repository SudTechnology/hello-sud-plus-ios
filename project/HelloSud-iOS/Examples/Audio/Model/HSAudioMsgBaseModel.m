//
//  HSAudioMsgBaseModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgBaseModel.h"

@implementation HSAudioMsgBaseModel
-(NSString *)cellName {
    return @"cell";
}

/// 配置消息
/// @param cmd 消息指令
- (void)configBaseInfoWithCmd:(NSInteger)cmd {
    self.cmd = cmd;
    HSAudioUserModel *userModel = HSAudioUserModel.new;
    userModel.userID = HSAppManager.shared.loginUserInfo.userID;
    userModel.name = HSAppManager.shared.loginUserInfo.name;
    userModel.icon = HSAppManager.shared.loginUserInfo.icon;
    userModel.sex = HSAppManager.shared.loginUserInfo.sex;
    self.sendUser = userModel;
}
@end
