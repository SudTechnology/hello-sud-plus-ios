//
// Created by kaniel_mac on 2022/5/3.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "CrossAppRoomListCell.h"

@interface CrossAppRoomListCell ()
@property(nonatomic, strong) DTPaddingLabel *statusLabel;
@property(nonatomic, strong) UIImageView *tagImageView;
@end

@implementation CrossAppRoomListCell
- (void)dtAddViews {
    [super dtAddViews];
    [self.iconImageView addSubview:self.tagImageView];
    [self.iconImageView addSubview:self.statusLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@0);
        make.height.equalTo(@16);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@0);
        make.height.equalTo(@16);
        make.width.equalTo(@42);
    }];
    [self.iconImageView dt_cornerRadius:10];
}


- (void)setModel:(BaseModel *)model {
    [super setModel:model];
    HSRoomInfoList *m = (HSRoomInfoList *) model;
    NSString *statusStr = @"";
    self.tagImageView.hidden = YES;
    self.statusLabel.hidden = NO;
    switch (m.teamStatus) {
        case 2:
            statusStr = @"组队中";
            self.tagImageView.hidden = NO;
            self.statusLabel.backgroundColor = UIColor.clearColor;
            break;
        default:
            self.statusLabel.hidden = YES;
            break;
    }
    self.statusLabel.text = statusStr;
}


- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[DTPaddingLabel alloc] init];
        _statusLabel.paddingX = 7;
        _statusLabel.font = UIFONT_REGULAR(10);
        _statusLabel.textColor = HEX_COLOR(@"#ffffff");
        _statusLabel.backgroundColor = HEX_COLOR_A(@"#000000", 0.8);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.image = [UIImage imageNamed:@"cross_app_group_tag"];
    }
    return _tagImageView;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.statusLabel.hidden = nil;
}

- (void)updateEnterTitle:(NSString *)title {
    [self.enterRoomBtn setTitle:title forState:UIControlStateNormal];
}
@end
