//
// Created by kaniel on 2022/4/19.
// Copyright (c) 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SuspendOneOneAudioView.h"

@interface SuspendOneOneAudioView ()

@property(nonatomic, strong) UIImageView *audioImageView;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) DTTimer *timer;
@end

@implementation SuspendOneOneAudioView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.audioImageView];
    [self addSubview:self.timeLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.audioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(38);
        make.centerX.equalTo(self);
        make.top.equalTo(@14);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.mas_greaterThanOrEqualTo(0);
        make.top.equalTo(self.audioImageView.mas_bottom).offset(4);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.timeLabel.text = @"00 : 00";
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)startDurationTimer {
    WeakSelf
    [self updateDuration];
    self.timer = [DTTimer timerWithTimeInterval:1 repeats:YES block:^(DTTimer *timer) {
        [weakSelf updateDuration];
    }];
}


- (void)updateDuration {
    self.duration++;
    NSInteger minute = self.duration / 60;
    NSInteger second = self.duration - minute * 60;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld : %02ld", minute, second];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = UIFONT_REGULAR(12);
        _timeLabel.textColor = UIColor.whiteColor;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIImageView *)audioImageView {
    if (!_audioImageView) {
        _audioImageView = UIImageView.new;
        _audioImageView.image = [UIImage imageNamed:@"oneone_suspend_audio"];
    }
    return _audioImageView;
}

@end
