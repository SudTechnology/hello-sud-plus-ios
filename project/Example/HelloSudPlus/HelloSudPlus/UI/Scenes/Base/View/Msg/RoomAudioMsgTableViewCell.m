//
//  RoomAudioMsgTableViewCell.m
//  HelloSudPlus
//
//  Created by kaniel on 9/7/24.
//  Copyright © 2024 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomAudioMsgTableViewCell.h"

@interface RoomAudioMsgTableViewCell()
@property(nonatomic, strong)UIImageView *audioBgImageView;
@property(nonatomic, strong)UIImageView *audioIconImageView;
@end

@implementation RoomAudioMsgTableViewCell
- (void)dtAddViews {
    [super dtAddViews];
    [self.msgContentView addSubview:self.audioBgImageView];
    [self.audioBgImageView addSubview:self.audioIconImageView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headImageView.mas_trailing).offset(3);
        make.top.equalTo(@3);

        make.bottom.equalTo(@3);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
        
    }];
    
    [self.audioBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.msgLabel.mas_trailing).offset(5);
        make.centerY.equalTo(self.msgContentView);
        make.trailing.equalTo(@-5);
        make.width.equalTo(@110);
        make.height.equalTo(@16);
    }];
    
    [self.audioIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.centerY.equalTo(self.audioBgImageView);
        make.width.equalTo(@12);
        make.height.equalTo(@12);
    }];


}


- (UIImageView *)audioBgImageView {
    if (!_audioBgImageView) {
        _audioBgImageView = UIImageView.new;
        _audioBgImageView.image = [UIImage imageNamed:@"image-yuyintiao"];
    }
    return _audioBgImageView;
}

- (UIImageView *)audioIconImageView {
    if (!_audioIconImageView) {
        _audioIconImageView = UIImageView.new;
        _audioIconImageView.image = [UIImage imageNamed:@"icon-yuyin"];
    }
    return _audioIconImageView;
}

@end
