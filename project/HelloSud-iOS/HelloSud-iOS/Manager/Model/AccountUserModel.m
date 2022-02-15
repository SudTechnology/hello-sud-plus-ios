//
//  AccountUserModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "AccountUserModel.h"

@implementation AccountUserModel

/// 判断是否是自己
/// @param userID 用户ID
- (BOOL)isMeByUserID:(NSString *)userID {
    if (userID.length > 0 && self.userID.length > 0 && [self.userID isEqualToString:userID]) {
        return YES;
    }
    return NO;
}
@end
