//
//  RoomBaseCMDModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "RoomBaseCMDModel.h"

@interface RoomBaseCMDModel () {
    CGFloat _cellHeight;
}

@end

@implementation RoomBaseCMDModel

- (NSString *)cellName {
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
    userModel.userID = AppService.shared.login.loginUserInfo.userID;
    userModel.name = AppService.shared.login.loginUserInfo.name;
    userModel.icon = AppService.shared.login.loginUserInfo.icon;
    userModel.sex = AppService.shared.login.loginUserInfo.sex;
    self.sendUser = userModel;
}

/// 解码model
/// @param keyValues keyValues json对象
+ (instancetype)fromJSON:(id)keyValues {
    return [self mj_objectWithKeyValues:keyValues];
}

/// 解码服务器返回的model
/// @param keyValues keyValues json对象
+ (instancetype)fromServerJSON:(NSString *)keyValues {
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:[keyValues dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    RoomBaseCMDModel *base = [self mj_objectWithKeyValues:dicData[@"content"]];
    base.cmd = [dicData[@"cmd"] integerValue];
    return base;
}

/// 解码服务器返回的model
/// @param keyValues keyValues json对象
+ (id)parseInstance:(Class)cls fromServerJSON:(NSString *)keyValues {
    NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:[keyValues dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    id temp = [cls mj_objectWithKeyValues:dicData[@"content"]];
    return temp;
}
@end


@implementation RoomGameMonopolyCardGiftNotifyCMDModel


@end


@implementation RoomGamePropsCardGiftNotifyCMDModel
@end
