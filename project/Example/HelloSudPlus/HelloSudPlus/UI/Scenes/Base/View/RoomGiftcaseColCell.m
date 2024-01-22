//
//  RoomGiftcaseColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "RoomGiftcaseColCell.h"
#import "InteractiveGameBannerModel.h"

@interface RoomGiftcaseColCell ()
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong) UIImageView *gameImageView;
@property(nonatomic, strong)UILabel *nameLabel;

@end

@implementation RoomGiftcaseColCell


- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.gameImageView];
    [self.contentView addSubview:self.nameLabel];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self.bgView dt_setGradientBackgroundWithColors:@[HEX_COLOR_A(@"#000000", 1), HEX_COLOR_A(@"#000000", 0)] locations:@[@(0), @(1.0f)] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    self.contentView.clipsToBounds = YES;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(@0);
    }];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.gameImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.contentView);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(@0);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.gameImageView.image = nil;
    self.nameLabel.text = nil;
}

- (void)setModel:(BaseModel *)model {
    [super setModel:model];
    WeakSelf
    if (![model isKindOfClass:[GiftModel class]]) {
        return;
    }
    GiftModel *giftModel = (GiftModel *)model;
    if (giftModel.isEmptyModel) {
        self.bgView.hidden = YES;
        return;
    }
    self.bgView.hidden = NO;
    [self.gameImageView sd_setImageWithURL:giftModel.smallGiftURL.dt_toURL];
    
    if (giftModel.isDanmu) {
        self.gameImageView.hidden = YES;
        self.nameLabel.attributedText = [self showDanmuAttrName:@"dt_room_danmu_prefix".dt_lan second:giftModel.details.content third:giftModel.details.title];
        [self.gameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    } else {
        self.nameLabel.attributedText = [self showAttrName:@"dt_room_gift_name_prefix".dt_lan second:giftModel.giftName];
        self.gameImageView.hidden = NO;
        [self.gameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
        }];
    }
}

- (NSMutableAttributedString *)showAttrName:(NSString *)first second:(NSString *)second {
    NSMutableAttributedString * firstAttr = [[NSMutableAttributedString alloc]initWithString:first attributes:@{NSFontAttributeName:UIFONT_MEDIUM(6),NSForegroundColorAttributeName: HEX_COLOR(@"#ffffff")}];
    
    NSMutableAttributedString * secondAttr = [[NSMutableAttributedString alloc]initWithString:second attributes:@{NSFontAttributeName:UIFONT_SEMI_BOLD(8),NSForegroundColorAttributeName: HEX_COLOR(@"#ffffff")}];
    [firstAttr appendAttributedString:secondAttr];
    return firstAttr;
}

- (NSMutableAttributedString *)showDanmuAttrName:(NSString *)first second:(NSString *)second third:(NSString *)third {
    NSMutableAttributedString * firstAttr = [[NSMutableAttributedString alloc]initWithString:first attributes:@{NSFontAttributeName:UIFONT_SEMI_BOLD(8),NSForegroundColorAttributeName: HEX_COLOR(@"#FFFFFF")}];
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 2;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
    shadow.shadowOffset =CGSizeMake(0,1);

    NSMutableAttributedString * secondAttr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@ ",second] attributes:@{
        NSFontAttributeName:UIFONT_SEMI_BOLD(12),
        NSForegroundColorAttributeName: HEX_COLOR(@"#ffffff"),
        NSStrokeWidthAttributeName:@-5,
        NSStrokeColorAttributeName:HEX_COLOR(@"#BF9D03"),
        NSShadowAttributeName: shadow}];
    [firstAttr appendAttributedString:secondAttr];
    NSMutableAttributedString * thirdAttr = [[NSMutableAttributedString alloc]initWithString:third attributes:@{NSFontAttributeName:UIFONT_SEMI_BOLD(8),NSForegroundColorAttributeName: HEX_COLOR(@"#FFFFFF")}];
    [firstAttr appendAttributedString:thirdAttr];

    return firstAttr;
}

- (UIImageView *)gameImageView {
    if (!_gameImageView) {
        _gameImageView = [[UIImageView alloc] init];
        _gameImageView.contentMode = UIViewContentModeScaleAspectFill;
        _gameImageView.clipsToBounds = YES;
        _gameImageView.userInteractionEnabled = YES;
        //        [_gameImageView dt_cornerRadius:8];
    }
    return _gameImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel){
        _nameLabel = UILabel.new;
    }
    return _nameLabel;
}

- (UIView *)bgView {
    if (!_bgView){
        _bgView = UIView.new;
        _bgView.alpha = 0.2;
    }
    return _bgView;
}
@end
