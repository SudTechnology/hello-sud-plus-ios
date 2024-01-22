//
//  ConfigModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "ConfigModel.h"

@implementation HSConfigContent
- (BOOL)isSameRtc:(NSString *)rtcType {
    if (rtcType) {
        return [self.rtcType dt_isInsensitiveEqualToString: rtcType];
    }
    return NO;
}


@end

@implementation ConfigModel

@end
