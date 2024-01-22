//
//  QuickSendColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DanmakuActionColCell.h"

@interface DanmakuActionColCell ()
@property(nonatomic, strong) MarqueeLabel *titleLabel;
@property(nonatomic, strong) UIImageView *bgImageView;

@end

@implementation DanmakuActionColCell
- (void)dtAddViews {

    [super dtAddViews];
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.bgImageView);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.bgImageView);
    }];

    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.height.equalTo(@25);
        make.width.equalTo(@92);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    if (![self.model isKindOfClass:DanmakuActionListeItemModel.class]) {
        return;
    }
    DanmakuActionListeItemModel *m = (DanmakuActionListeItemModel *) self.model;
    self.titleLabel.text = m.title;
    if (m.titleColor.length > 0) {
        self.titleLabel.textColor = HEX_COLOR(m.titleColor);
    }
    [self.bgImageView sd_setImageWithURL:m.backgroundUrl.dt_toURL];

}



- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCallView:)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)onTapCallView:(id)tap {
    DanmakuCallWarcraftModel *m = (DanmakuCallWarcraftModel *) self.model;
    if (m.callMode == DanmakuCallWarcraftModelTypeDanmuka) {
        // 弹幕
        [kDanmakuRoomService.currentRoomVC sendContentMsg:m.content];
    } else if (m.callMode == DanmakuCallWarcraftModelTypeGift) {
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
            [ToastUtil show:@"主播不在线"];
            DDLogError(@"找不到房主发送,mic count:%@", @(micList.count));
            for (int i = 0; i < micList.count; ++i) {
                AudioUserModel *user = micList[i].user;
                DDLogError(@"mic users name:%@,userId:%@,roleType:%@", user.name, user.userID, @(user.roleType));
            }
            return;
        }

        RoomCmdSendGiftModel *giftMsg = [RoomCmdSendGiftModel makeMsgWithGiftID:m.giftId giftCount:m.giftAmount toUser:toUser];
        giftMsg.type = 1;// 后台礼物
        giftMsg.giftUrl = m.giftUrl;
        giftMsg.animationUrl = m.animationUrl;
        giftMsg.giftName = m.name;
        [kAudioRoomService.currentRoomVC sendMsg:giftMsg isAddToShow:YES finished:nil];
    }

}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}


- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.font = UIFONT_MEDIUM(15);
        _titleLabel.textColor = HEX_COLOR(@"#C0B8A0");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
