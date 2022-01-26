//
//  HSAudioMsgBaseModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "HSAudioMsgBaseModel.h"

@interface HSAudioMsgBaseModel(){
    CGFloat _cellHeight;
}

@end

@implementation HSAudioMsgBaseModel

-(NSString *)cellName {
    return @"cell";
}
/// cell高度
- (CGFloat)cellHeight {
    return _cellHeight;
}

/// 计算cell高度，子类覆盖返回
- (CGFloat)caculateHeight {

    CGFloat bottomMargin = 4;
    return bottomMargin;
}

/// 触发计算属性
- (void)prepare {
    _cellHeight = ceil([self caculateHeight]);
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
