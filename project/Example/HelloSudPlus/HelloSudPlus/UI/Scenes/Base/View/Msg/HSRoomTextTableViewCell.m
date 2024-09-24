//
//  HSRoomTextTableViewCell.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomTextTableViewCell.h"

@interface HSRoomTextTableViewCell ()

@end

@implementation HSRoomTextTableViewCell

- (void)dtAddViews {
    [super dtAddViews];
    [self.msgContentView addSubview:self.headImageView];
    [self.msgContentView addSubview:self.msgLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.headImageView dt_cornerRadius:8];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@3);
        make.top.equalTo(@3);
        make.width.height.equalTo(@16);
    }];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headImageView.mas_trailing).offset(3);
        make.top.equalTo(@3);
        make.trailing.equalTo(@-5);
        make.bottom.equalTo(@3);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];

}

- (void)dtConfigUI {
    self.msgContentView.backgroundColor = [UIColor dt_colorWithHexString:@"#000000" alpha:0.3];
}

- (void)setModel:(BaseModel *)model {
    [super setModel:model];
    if (![model isKindOfClass:RoomCmdChatTextModel.class]) {
        return;
    }
    RoomCmdChatTextModel *m = (RoomCmdChatTextModel *) model;
    [self setMsgContent:m];
    if (m.sendUser.icon) {
        [NSURL URLWithString:m.sendUser.icon];
        [self.headImageView sd_setImageWithURL:[[NSURL alloc] initWithString:m.sendUser.icon] placeholderImage:[UIImage imageNamed:@"default_head"] options:SDWebImageRetryFailed context:nil progress:nil completed:^(UIImage *_Nullable image, NSError *_Nullable error, SDImageCacheType cacheType, NSURL *_Nullable imageURL) {

        }];
    } else {
        self.headImageView.image = [UIImage imageNamed:@"default_head"];
    }
}

/// 设置文本消息
- (void)setMsgContent:(RoomCmdChatTextModel *)m {
    WeakSelf
    self.msgLabel.attributedText = m.attrContent;
    __weak typeof(m) weakM = m;
    [m refreshAttrContent:^{
        if (weakSelf.model == weakM) {
            weakSelf.msgLabel.attributedText = weakM.attrContent;
        }
    }];

}

- (YYLabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[YYLabel alloc] init];
        _msgLabel.numberOfLines = 0;
        _msgLabel.preferredMaxLayoutWidth = 260 - 8;
        _msgLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    }
    return _msgLabel;
}

- (SDAnimatedImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[SDAnimatedImageView alloc] init];
        _headImageView.shouldCustomLoopCount = YES;
        _headImageView.animationRepeatCount = NSIntegerMax;
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

@end
