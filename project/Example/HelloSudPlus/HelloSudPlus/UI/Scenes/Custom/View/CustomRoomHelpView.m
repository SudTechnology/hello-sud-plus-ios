//
//  CustomRoomHelpView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/21.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CustomRoomHelpView.h"

@implementation CustomRoomHelpView

- (void)dtConfigUI {
    self.backgroundColor = UIColor.whiteColor;
    NSArray *titleArr = @[NSString.dt_room_join_status, NSString.dt_room_custom_ready, NSString.dt_room_custom_cancel_ready,
                          NSString.dt_room_custom_quit_game, NSString.dt_room_custom_start_game, NSString.dt_room_custom_escape,
                          NSString.dt_room_custom_dissolve_game];
    NSArray *subTitleArr = @[@"app_common_self_in, \"isIn\": true",
                             @"app_common_self_ready, \"isReady\": true",
                             @"app_common_self_ready, \"isReady\": false",
                             @"app_common_self_in, \"isIn\": false",
                             @"app_common_self_playing, \"isPlaying\": true",
                             @"app_common_self_playing, \"isPlaying\": false",
                             @"app_common_self_end,{}"];
    for (int i = 0; i < titleArr.count; i++) {
        UIView *node = UIView.new;
        
        UILabel *titleLabel = UILabel.new;
        titleLabel.text = titleArr[i];
        titleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        titleLabel.font = UIFONT_REGULAR(14);
        
        UILabel *subTitleLabel = UILabel.new;
        subTitleLabel.text = subTitleArr[i];
        subTitleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        subTitleLabel.font = UIFONT_REGULAR(14);
        
        [self addSubview:node];
        [node addSubview:titleLabel];
        [node addSubview:subTitleLabel];
        
        [node mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.mas_equalTo(self);
            make.height.mas_equalTo(64);
            make.top.mas_equalTo(i * 64);
            if (i == titleArr.count - 1) {
                make.bottom.mas_equalTo(-20 - kAppSafeBottom);
            }
        }];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(16);
            make.top.mas_equalTo(20);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        }];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(16);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(4);
            make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        }];
    }
}

@end
