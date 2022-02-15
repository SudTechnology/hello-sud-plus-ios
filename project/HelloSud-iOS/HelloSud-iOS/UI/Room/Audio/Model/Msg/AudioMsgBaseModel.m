//
//  AudioMsgBaseModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "AudioMsgBaseModel.h"

@interface AudioMsgBaseModel(){
    CGFloat _cellHeight;
}

@end

@implementation AudioMsgBaseModel

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
    AudioUserModel *userModel = AudioUserModel.new;
    userModel.userID = AppManager.shared.loginUserInfo.userID;
    userModel.name = AppManager.shared.loginUserInfo.name;
    userModel.icon = AppManager.shared.loginUserInfo.icon;
    userModel.sex = AppManager.shared.loginUserInfo.sex;
    self.sendUser = userModel;
}

/// 解码model
/// @param keyValues keyValues json对象
+ (instancetype)decodeModel:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}
@end
