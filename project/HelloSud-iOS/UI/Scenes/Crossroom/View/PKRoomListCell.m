//
// Created by kaniel_mac on 2022/5/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PKRoomListCell.h"
@interface PKRoomListCell()
@property (nonatomic, strong)UILabel *pkStatusLabel;
@end

@implementation PKRoomListCell
- (void)hsAddViews {
    [super hsAddViews];
    [self.iconImageView addSubview:self.pkStatusLabel];
}

- (void)hsLayoutViews {
    [super hsLayoutViews];
    [self.pkStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.top.equalTo(@0);
       make.height.equalTo(@16);
       make.width.equalTo(@48);
    }];
    [self.iconImageView dt_cornerRadius:10];
}


- (void)setModel:(BaseModel *)model {
    [super setModel:model];
    HSRoomInfoList *m = (HSRoomInfoList *) model;
    NSString *statusStr = @"";
    // pk状态 （1：待匹配 2：pk已匹配，未开始 3：k已匹配，已开始 4：pk匹配关闭 5：pk已结束）
    switch (m.pkStatus) {
        case 1:
            statusStr = NSString.dt_room_pk_waitting;
            self.pkStatusLabel.hidden = NO;
            break;
        case 2:
        case 3:
        case 5:{
            statusStr = NSString.dt_room_pk_status_ing;
            self.pkStatusLabel.hidden = NO;
        }
            break;
        default:
            self.pkStatusLabel.hidden = YES;
            break;
            
    }
    self.pkStatusLabel.text = statusStr;
}


- (UILabel *)pkStatusLabel {
    if (!_pkStatusLabel) {
        _pkStatusLabel = [[UILabel alloc] init];
        _pkStatusLabel.font = UIFONT_REGULAR(10);
        _pkStatusLabel.textColor = HEX_COLOR(@"#ffffff");
        _pkStatusLabel.backgroundColor = HEX_COLOR_A(@"#000000", 0.8);
        _pkStatusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pkStatusLabel;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.pkStatusLabel.hidden = nil;
}

- (void)updateEnterTitle:(NSString *)title {
    [self.enterRoomBtn setTitle:title forState:UIControlStateNormal];
}
@end
