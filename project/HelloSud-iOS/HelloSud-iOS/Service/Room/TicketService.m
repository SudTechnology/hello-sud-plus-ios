//
//  TicketService.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TicketService.h"

@implementation TicketService

- (NSMutableArray <NSAttributedString *> *)getTicketRewardAttributedStrArr {
    NSArray <NSString *> *strArr = @[@"恭喜沐辰在高级场赢得900金币！", @"恭喜 安小六 在初级场赢得20金币！", @"恭喜 兔兔 在中级场赢得250金币！", @"恭喜 Toby 在高级场赢得900金币！", @"恭喜 Jennie 在高级场赢得900金币！", @"恭喜 Bell 在中级场赢得250金币！"];
    NSMutableArray <NSAttributedString *> *dataArr = [NSMutableArray array];
    for (int i = 0; i < strArr.count; i++) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strArr[i]];
        attrStr.yy_lineSpacing = 6;
        attrStr.yy_font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        attrStr.yy_color = [UIColor dt_colorWithHexString:@"#FFE77D" alpha:1];
        [dataArr addObject:attrStr];
    }
    return dataArr;
}

@end
