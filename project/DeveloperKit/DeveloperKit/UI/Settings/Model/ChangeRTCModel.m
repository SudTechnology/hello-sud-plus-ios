//
//  ChangeRTCModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "ChangeRTCModel.h"
#import "NSString+DTNSString.h"

@implementation ChangeRTCModel
+ (ChangeRTCModel *)makeModel:(NSString *)title rtcConfig:(nullable HSConfigContent *)rtcConfig {
    ChangeRTCModel *m = [[ChangeRTCModel alloc] init];
    m.title = title;
    m.rtcConfig = rtcConfig;
    if (rtcConfig) {
        m.isSlect = [AppService.shared.rtcType dt_isInsensitiveEqualToString: rtcConfig.rtcType];
    }
    return m;
}


@end
