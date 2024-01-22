//
// Created by kaniel on 2022/8/6.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BindWalletStateView.h"

@interface BindWalletStateView()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *stateLabel;
@property(nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong)DTTimer *timer;
@end

@implementation BindWalletStateView
- (void)dtAddViews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.stateLabel];
    [self addSubview:self.closeBtn];
}

- (void)dtLayoutViews {
    [self dt_cornerRadius:8];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(58, 58));
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(3);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@20);
        make.bottom.equalTo(@-30);
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-12);
        make.top.equalTo(@12);
        make.width.height.equalTo(@24);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = HEX_COLOR_A(@"#ffffff", 0.9);
    [self updateStage:1 event:1];
}

- (void)updateStage:(NSInteger)stage event:(NSInteger)event {

    switch (event) {
        case 1:
            self.stateLabel.text = @"钱包连接中...";
            self.closeBtn.hidden = NO;
            self.iconImageView.image = [UIImage imageNamed:@"nft_bind_connecting"];
            break;
        case 2:
            self.stateLabel.text = @"连接成功，等待签名...";
            self.closeBtn.hidden = NO;
            self.iconImageView.image = [UIImage imageNamed:@"nft_bind_siging"];
            break;
        case 4:
            self.stateLabel.text = @"签名成功";
            self.closeBtn.hidden = YES;
            self.iconImageView.image = [UIImage imageNamed:@"nft_bind_success"];
            self.timer = [DTTimer timerWithTimeCountdown:3 progressBlock:nil endBlock:^(DTTimer *timer) {
                [DTAlertView close];
            }];
            break;
        default:
            break;
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.closeBtn addTarget:self action:@selector(onTap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onTap:(id)tap {
    NSLog(@"onTap");
    if (self.timer) {
        [self.timer stopTimer];
    }
    [DTAlertView close];
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.clipsToBounds = true;
    }
    return _iconImageView;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.text = @"";
        _stateLabel.numberOfLines = 1;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.textColor = HEX_COLOR(@"#13141A");
        _stateLabel.font = UIFONT_MEDIUM(14);
    }
    return _stateLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]init];
        [_closeBtn setImage:[UIImage imageNamed:@"nft_bind_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

@end
