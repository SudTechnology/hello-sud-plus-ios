//
//  QuickSendColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickSendEffectColCell.h"

@interface QuickSendEffectColCell ()
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@property(nonatomic, strong) UIView *iconContentView;
@property(nonatomic, strong) BaseView *callView;
@property(nonatomic, strong) YYLabel *giftLabel;
@property(nonatomic, strong) MarqueeLabel *callLabel;
@end

@implementation QuickSendEffectColCell
- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.iconContentView];
    [self.contentView addSubview:self.callView];
    [self.callView addSubview:self.giftLabel];
    [self.callView addSubview:self.callLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@6);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@17);
    }];

    [self.iconContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@30);
    }];
    [self.callView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconContentView.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@90);
        make.height.equalTo(@20);
    }];
    [self.giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@0);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(self.callView);
    }];
    [self.callLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.giftLabel.mas_trailing).offset(2);
        make.trailing.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(self.callView);
    }];
    [self.giftLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.callLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)dtConfigUI {
    [super dtConfigUI];


}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    if (![self.model isKindOfClass:DanmakuCallWarcraftModel.class]) {
        return;
    }
    DanmakuCallWarcraftModel *m = (DanmakuCallWarcraftModel *) self.model;
    self.titleLabel.text = m.title;
    if (m.titleColor.length > 0) {
        self.titleLabel.tintColor = HEX_COLOR(m.titleColor);
    }
    [self relayoutImages:m];
    [self showCallViewContent:m];

}


- (void)relayoutImages:(DanmakuCallWarcraftModel *)model {

    NSArray <UIView *> *arrSubviews = self.iconContentView.subviews;
    for (int i = 0; i < arrSubviews.count; ++i) {
        [arrSubviews[i] removeFromSuperview];
    }
    NSArray *imageList = model.warcraftImageList;
    NSMutableArray *arrImageView = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageList.count; ++i) {
        NSString *imageURL = imageList[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;

        [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:imageURL]];
        [arrImageView addObject:imageView];
        [self.iconContentView addSubview:imageView];
    }
    CGFloat itemW = 30;
    CGFloat cellWidth = model.cellWidth;
    CGFloat marginX = (cellWidth - imageList.count * itemW - (imageList.count - 1) * 10) / 2;
    [arrImageView dt_mas_distributeSudokuViewsWithFixedLineSpacing:10 fixedInteritemSpacing:10 warpCount:arrImageView.count topSpacing:0 bottomSpacing:0 leadSpacing:marginX tailSpacing:marginX];
}

- (void)showCallViewContent:(DanmakuCallWarcraftModel *)model {
    if (model.callMode == 2) {
        // 礼物
        [self showGiftIcon:model];
        self.callLabel.text = [NSString stringWithFormat:@"%@金币", @(model.giftPrice)];
        [self.giftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@8);
            make.width.greaterThanOrEqualTo(@0);
        }];
        [self.callLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-5);
        }];
        self.callLabel.textAlignment = NSTextAlignmentRight;
    } else {
        self.callLabel.text = model.name;
        [self.giftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.width.equalTo(@0);
        }];
        [self.callLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@0);
        }];
        self.callLabel.textAlignment = NSTextAlignmentCenter;
    }

}

- (void)showGiftIcon:(DanmakuCallWarcraftModel *)model {
    [self loadImage:model.giftUrl completed:^(UIImage *image) {
        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] init];
        UIImage *iconImage = image;
        if (!iconImage) {
            iconImage = [UIImage imageNamed:@"guess_award_coin"];
        }
        NSMutableAttributedString *attrIcon = [NSAttributedString yy_attachmentStringWithContent:iconImage contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(16, 16) alignToFont:[UIFont systemFontOfSize:10 weight:UIFontWeightRegular] alignment:YYTextVerticalAlignmentCenter];
        [full appendAttributedString:attrIcon];

        NSMutableAttributedString *attrAwardValue = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" x%@", @(model.giftAmount)]];
        attrAwardValue.yy_font = UIFONT_MEDIUM(10);
        attrAwardValue.yy_color = HEX_COLOR(@"#ffffff");
        [full appendAttributedString:attrAwardValue];
        self.giftLabel.attributedText = full;
    }];

}

- (void)loadImage:(NSString *)imageURL completed:(void (^)(UIImage *image))completed {
    if (imageURL.length == 0) {
        if (completed) {
            completed(nil);
        }
        return;
    }
    if (![imageURL hasPrefix:@"http"]) {
        if (completed) {
            completed([UIImage imageNamed:imageURL]);
        }
        return;
    }
    [[SDWebImageManager sharedManager] loadImageWithURL:[[NSURL alloc] initWithString:imageURL] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (completed) {
            completed(image);
        }
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCallView:)];
    [self.callView addGestureRecognizer:tap];

}

- (void)onTapCallView:(id)tap {
    DanmakuCallWarcraftModel *m = (DanmakuCallWarcraftModel *) self.model;
    if (m.callMode == 1) {
        // 弹幕
        [kDanmakuRoomService.currentRoomVC sendContentMsg:m.content];
    } else if (m.callMode == 2) {
        // 礼物
        AudioUserModel *toUser = nil;

        // 找到房主，发送给房主
        NSArray<AudioRoomMicModel *> *micList = kAudioRoomService.currentRoomVC.dicMicModel.allValues;
        for (int i = 0; i < micList.count; ++i) {
            AudioUserModel *user = micList[i].user;
            if (user && user.roleType == 1) {
                toUser = user;
                break;
            }
        }
        if (!toUser) {
            toUser = [[AudioUserModel alloc] init];
        }

        RoomCmdSendGiftModel *giftMsg = [RoomCmdSendGiftModel makeMsgWithGiftID:m.giftId giftCount:m.giftAmount toUser:toUser];
        giftMsg.type = 1;// 后台礼物
        giftMsg.giftUrl = m.giftUrl;
        giftMsg.animationUrl = m.animationUrl;
        giftMsg.giftName = m.name;
        [kAudioRoomService.currentRoomVC sendMsg:giftMsg isAddToShow:YES];
    }

}

- (UIView *)iconContentView {
    if (!_iconContentView) {
        _iconContentView = [[UIView alloc] init];
    }
    return _iconContentView;
}

- (YYLabel *)giftLabel {
    if (!_giftLabel) {
        _giftLabel = [[YYLabel alloc] init];
    }
    return _giftLabel;
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.text = @"弹幕魔兽";
        _titleLabel.font = UIFONT_REGULAR(12);
        _titleLabel.textColor = HEX_COLOR(@"#C0B8A0");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (BaseView *)callView {
    if (!_callView) {
        _callView = [[BaseView alloc] init];
        [_callView dt_cornerRadius:2];
        [_callView dtAddGradientLayer:@[@0, @1] colors:@[(id) HEX_COLOR(@"#F09701").CGColor, (id) HEX_COLOR(@"#FAB300").CGColor] startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) cornerRadius:0];
    }
    return _callView;
}


- (MarqueeLabel *)callLabel {
    if (!_callLabel) {
        _callLabel = [[MarqueeLabel alloc] init];
        _callLabel.text = @"弹幕666";
        _callLabel.font = UIFONT_MEDIUM(10);
        _callLabel.textColor = HEX_COLOR(@"#ffffff");
        _callLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _callLabel;
}
@end
