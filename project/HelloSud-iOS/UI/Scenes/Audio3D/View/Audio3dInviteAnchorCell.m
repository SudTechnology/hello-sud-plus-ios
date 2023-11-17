//
//  DiscoRankTableViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "Audio3dInviteAnchorCell.h"
#import "Audio3dInviteAnchorModel.h"

@interface Audio3dInviteAnchorCell ()
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UIButton *inviteBtn;
@end

@implementation Audio3dInviteAnchorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dtAddViews {
    [super dtAddViews];

    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.inviteBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];


    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@36);
        make.centerY.equalTo(self.contentView);
        make.leading.equalTo(@15);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headImageView.mas_trailing).offset(16);
        make.width.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
    }];
    [self.inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@80);
        make.height.equalTo(@24);
        make.centerY.equalTo(self.contentView);
        make.trailing.equalTo(@-16);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:Audio3dInviteAnchorModel.class]) {
        return;
    }
    Audio3dInviteAnchorModel *m = (Audio3dInviteAnchorModel *) self.model;
    [self.headImageView sd_setImageWithURL:m.avatar.dt_toURL];
    self.nameLabel.text = m.name;
    self.inviteBtn.enabled = !m.isInvited;
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf;
    [self.inviteBtn dt_onClick:^(UIButton *sender) {
        if (weakSelf.inviteClickBlock) {
            weakSelf.inviteClickBlock((Audio3dInviteAnchorModel *)weakSelf.model);
        }
    }];
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = UIFONT_BOLD(16);
        _nameLabel.textColor = HEX_COLOR(@"#000000");
    }
    return _nameLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.clipsToBounds = YES;
        [_headImageView dt_cornerRadius:18];
    }
    return _headImageView;
}

- (UIButton *)inviteBtn {
    if (!_inviteBtn) {
        _inviteBtn = [[UIButton alloc] init];
        _inviteBtn.titleLabel.font = UIFONT_MEDIUM(12);
        [_inviteBtn setTitle:@"dt_room_invite_ta".dt_lan forState:UIControlStateNormal];
        [_inviteBtn setTitle:@"dt_room_invite_exist".dt_lan forState:UIControlStateDisabled];
        [_inviteBtn setBackgroundImage:HEX_COLOR(@"#000000").dt_toImage forState:UIControlStateNormal];
    }
    return _inviteBtn;
}

@end
