//
//  AudioUserModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/24.
//

#import "AudioUserModel.h"

@implementation AudioUserModel
+ (instancetype)makeUserWithUserID:(NSString *)userID name:(NSString *)name icon:(NSString *)icon sex:(NSInteger)sex {
    AudioUserModel *m = AudioUserModel.new;
    m.userID = userID;
    m.name = name;
    m.icon = icon;
    m.sex = sex;
    return m;
}
@end
