//
//  RoomGiftcaseColCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "RoomGiftcaseRoleColCell.h"
#import "InteractiveGameBannerModel.h"

@interface RoomGiftcaseRoleColCell ()
@property(nonatomic, strong)UIView *bgView;
@property(nonatomic, strong) UIImageView *gameImageView;
@property(nonatomic, strong)UILabel *prefixLabel;
@property(nonatomic, strong)UILabel *nameLabel;

@end

@implementation RoomGiftcaseRoleColCell


- (void)dtAddViews {
    [super dtAddViews];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.gameImageView];
    [self.contentView addSubview:self.prefixLabel];
    [self.contentView addSubview:self.nameLabel];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    [self.bgView dt_setGradientBackgroundWithColors:@[HEX_COLOR_A(@"#000000", 1), HEX_COLOR_A(@"#000000", 0)] locations:@[@(0), @(1.0f)] startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
    
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
//    self.contentView.backgroundColor = UIColor.redColor;
    self.contentView.clipsToBounds = YES;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo(@32);
    }];
    [self.gameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.centerY.equalTo(self.bgView);
        make.width.height.equalTo(@32);
    }];
    [self.prefixLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.gameImageView.mas_trailing).offset(3);
        make.top.equalTo(@5);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(@0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.gameImageView.mas_trailing).offset(3);
        make.top.equalTo(self.prefixLabel.mas_bottom).offset(1);
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
    self.prefixLabel.text = nil;
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
    self.nameLabel.text = giftModel.details.desc;
    self.prefixLabel.text = @"dt_room_gift_name_prefix".dt_lan;
}

- (NSMutableAttributedString *)showAttrName:(NSString *)first second:(NSString *)second {
    NSMutableAttributedString * firstAttr = [[NSMutableAttributedString alloc]initWithString:first attributes:@{NSFontAttributeName:UIFONT_MEDIUM(6),NSForegroundColorAttributeName: HEX_COLOR(@"#ffffff")}];
    
    NSMutableAttributedString * secondAttr = [[NSMutableAttributedString alloc]initWithString:second attributes:@{NSFontAttributeName:UIFONT_SEMI_BOLD(8),NSForegroundColorAttributeName: HEX_COLOR(@"#ffffff")}];
    [firstAttr appendAttributedString:secondAttr];
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



- (UILabel *)prefixLabel {
    if (!_prefixLabel){
        _prefixLabel = UILabel.new;
        _prefixLabel.text = @"dt_room_gift_name_prefix".dt_lan;
        _prefixLabel.textColor = HEX_COLOR(@"#ffffff");
        _prefixLabel.font = UIFONT_MEDIUM(8);
    }
    return _prefixLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel){
        _nameLabel = UILabel.new;
        _nameLabel.textColor = HEX_COLOR(@"#ffffff");
        _nameLabel.font = UIFONT_SEMI_BOLD(10);
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
