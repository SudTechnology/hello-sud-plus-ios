//
//  ModelAiRoomOperatorView.m
//  HelloSudPlus
//
//  Created by kaniel on 9/7/24.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "ModelAiRoomOperatorView.h"


@interface ModelAiRoomOperatorView()
@property(nonatomic, strong)UIView *recordView;
@end

@implementation ModelAiRoomOperatorView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.voiceBtn];
    [self addSubview:self.recordView];
    [self.recordView addSubview:self.recordLabel];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.voiceUpBtn.hidden = YES;
    self.recordView.hidden = YES;
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.voiceUpBtn);
        make.center.equalTo(self.voiceUpBtn);
    }];
    [self.voiceUpBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.inputLabel);
    }];
    
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(self.recordView);
    }];
    
    
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.voiceBtn addTarget:self action:@selector(onVoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onRecordTap:)];
    tap.minimumPressDuration = 0;
    [self.recordView addGestureRecognizer:tap];
}

- (void)onVoiceBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.inputLabel.hidden = YES;
        self.recordView.hidden = NO;
    } else {
        self.inputLabel.hidden = NO;
        self.recordView.hidden = YES;
    }
}

- (void)onRecordTap:(UITapGestureRecognizer *)tap {

    switch (tap.state) {
        case UIGestureRecognizerStateBegan:
            self.recordLabel.text = @"dt_operator_record_end_tip".dt_lan;

            if (self.recordTouchDownBlock) {
                self.recordTouchDownBlock();
            }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            self.recordLabel.text = @"dt_operator_record_tip".dt_lan;
            if (self.recordTouchUpBlock) {
                self.recordTouchUpBlock();
            }
        default:
            break;
    }
}



- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc]init];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon-laba"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon-jianpan"] forState:UIControlStateSelected];
        _voiceBtn.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
        _voiceBtn.layer.cornerRadius = 16;
    }
    return _voiceBtn;
}

- (UIView *)recordView {
    if (!_recordView) {
        _recordView = UIView.new;
        _recordView.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
        _recordView.layer.cornerRadius = 16;
        _recordView.layer.masksToBounds = true;
    }
    return _recordView;
}


- (UILabel *)recordLabel {
    if (!_recordLabel) {
        _recordLabel = [[UILabel alloc]init];
        _recordLabel.text = @"dt_operator_record_tip".dt_lan;
        _recordLabel.textColor = [UIColor dt_colorWithHexString:@"#FFFFFF" alpha:1];
        _recordLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
        _recordLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _recordLabel;
}



@end
