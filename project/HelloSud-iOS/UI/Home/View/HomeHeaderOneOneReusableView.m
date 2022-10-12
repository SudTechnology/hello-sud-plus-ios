//
//  GameItemFullCollectionViewCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/29.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "HomeHeaderOneOneReusableView.h"

@interface HomeHeaderOneOneReusableView ()
@property(nonatomic, strong) BaseView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIImageView *audioImageView;
@property(nonatomic, strong) UIImageView *videoImageView;
@property(nonatomic, strong) UILabel *audioLabel;
@property(nonatomic, strong) UILabel *videoLabel;


@end

@implementation HomeHeaderOneOneReusableView


- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.audioImageView];
    [self.contentView addSubview:self.videoImageView];
    [self.contentView addSubview:self.audioLabel];
    [self.contentView addSubview:self.videoLabel];

}

- (void)dtConfigUI {
    [super dtConfigUI];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(15);
        make.trailing.mas_equalTo(-15);
        make.top.mas_equalTo(16);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.audioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.leading.equalTo(@13);
        make.bottom.equalTo(@-10);
    }];
    [self.audioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.audioImageView).offset(12);
        make.bottom.equalTo(self.audioImageView).offset(-8);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.videoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.audioImageView);
        make.leading.equalTo(self.audioImageView.mas_trailing).offset(10);
        make.trailing.equalTo(@-13);
        make.bottom.equalTo(@-10);
        make.width.height.equalTo(self.audioImageView);
    }];
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.videoImageView).offset(12);
        make.bottom.equalTo(self.videoImageView).offset(-8);
        make.width.height.greaterThanOrEqualTo(@0);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    UITapGestureRecognizer *audioTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAudioTap:)];
    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onVideoTap:)];
    [self.audioImageView addGestureRecognizer:audioTap];
    [self.videoImageView addGestureRecognizer:videoTap];
}

- (void)onAudioTap:(id)tap {
    [AudioRoomService reqMatchRoom:0 sceneType:self.sceneModel.sceneId gameLevel:-1 subSceneType:1];
}

- (void)onVideoTap:(id)tap {
    [AudioRoomService reqMatchRoom:0 sceneType:SceneTypeOneOneVideo gameLevel:-1 subSceneType:2];
}

- (void)setSceneModel:(HSSceneModel *)sceneModel {
    _sceneModel = sceneModel;
    WeakSelf
    self.titleLabel.text = sceneModel.sceneName;
    if (LanguageUtil.isLanguageRTL) {
        self.audioLabel.textAlignment = NSTextAlignmentRight;
    } else {
        self.audioLabel.textAlignment = NSTextAlignmentLeft;
    }
    self.audioLabel.text = @"语音";
    self.videoLabel.text = @"视频";
}

- (BaseView *)contentView {
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.backgroundColor = UIColor.whiteColor;
        [_contentView setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:8];
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
    }
    return _titleLabel;
}


- (UIImageView *)audioImageView {
    if (!_audioImageView) {
        _audioImageView = [[UIImageView alloc] init];
        _audioImageView.image = [UIImage imageNamed:@"home_audio_scene"];
        _audioImageView.contentMode = UIViewContentModeScaleAspectFill;
        _audioImageView.clipsToBounds = YES;
        _audioImageView.userInteractionEnabled = YES;
        [_audioImageView dt_cornerRadius:8];
    }
    return _audioImageView;
}


- (UILabel *)audioLabel {
    if (!_audioLabel) {
        _audioLabel = [[UILabel alloc] init];
        _audioLabel.text = @"";
        _audioLabel.textColor = UIColor.whiteColor;
        _audioLabel.font = UIFONT_SEMI_BOLD(14);
        _audioLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _audioLabel;
}

- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] init];
        _videoImageView.image = [UIImage imageNamed:@"home_video_scene"];
        _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _videoImageView.clipsToBounds = YES;
        _videoImageView.userInteractionEnabled = YES;
        [_videoImageView dt_cornerRadius:8];
    }
    return _videoImageView;
}


- (UILabel *)videoLabel {
    if (!_videoLabel) {
        _videoLabel = [[UILabel alloc] init];
        _videoLabel.text = @"";
        _videoLabel.textColor = UIColor.whiteColor;
        _videoLabel.font = UIFONT_SEMI_BOLD(14);
        _videoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _videoLabel;
}

@end
