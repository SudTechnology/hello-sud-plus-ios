//
//  AccountUserModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "AccountUserModel.h"

@interface AccountUserModel()
@property(nonatomic, copy)NSString *icon;
@end

@implementation AccountUserModel

/// 判断是否是自己
/// @param userID 用户ID
- (BOOL)isMeByUserID:(NSString *)userID {
    if (userID.length > 0 && self.userID.length > 0 && [self.userID isEqualToString:userID]) {
        return YES;
    }
    return NO;
}

- (BOOL)isWearNFT {
    return _headerType == HSUserHeadTypeNFT;
}

- (NSString *)icon {
    return _headerType == HSUserHeadTypeNFT ? _headerNftUrl : _avatar;
}

- (void)setIcon:(NSString *)icon {
    _avatar = icon;
}
@end
