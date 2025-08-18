//
//  SoundShowView.m
//  HelloSudPlus
//
//  Created by kaniel on 6/24/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SoundShowView.h"
#import "SudAudioPlayer.h"

@interface SoundShowView()

@property (nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong)UILabel *textLabel;
@property (nonatomic, strong) UIImageView *soundIcon;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *soundContentView;
@property (nonatomic, strong) BaseView *gradientView;
@property(nonatomic, assign)SoundShowViewAudioType audioState;


@end

@implementation SoundShowView


- (void)setAudioData:(NSData *)audioData {
    _audioData = audioData;
    if (audioData.length > 0) {
        [self changeAudioType:SoundShowViewAudioTypeExist];
        
    } else {
        [self changeAudioType:SoundShowViewAudioTypeEmpty];
    }
}

- (void)dtAddViews {
    [self addSubview:self.soundContentView];
    [self.soundContentView addSubview:self.gradientView];
    [self.soundContentView addSubview:self.playButton];
    [self.soundContentView addSubview:self.textLabel];
    [self.soundContentView addSubview:self.soundIcon];
//    [self addSubview:self.addButton];
}

- (void)dtLayoutViews {
    
    [self.soundContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.bottom.equalTo(@0);
//        make.trailing.equalTo(self.addButton.mas_leading).offset(-6);
        make.trailing.equalTo(@0);
    }];
    
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.equalTo(self.soundContentView);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.centerY.equalTo(self);
        make.height.equalTo(self);
        make.width.greaterThanOrEqualTo(@120);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(8);
        make.trailing.equalTo(self).offset(-8);
        make.centerY.equalTo(self);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.soundIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(163, 30));
        make.trailing.equalTo(@-8);
    }];
    
//    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self).offset(0);
//        make.centerY.equalTo(self);
//        make.top.bottom.equalTo(@0);
//        make.width.equalTo(@54);
//    }];

}

- (void)dtConfigUI {
    
    self.textLabel.text = @"dt_hold_press_tip".dt_lan;
    // 设置播放按钮（带图标和文字）
    UIImage *playIcon = [UIImage imageNamed:@"sound_play"];
    
    [self.playButton setImage:playIcon forState:UIControlStateNormal];
    [self.playButton setTitle:@"dt_click_play".dt_lan forState:UIControlStateNormal];
    [self.playButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    
    // 配置按钮样式
    self.playButton.titleLabel.font = UIFONT_MEDIUM(14);
    self.playButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.playButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8); // 图标右边距
    self.playButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0); // 文字左边距
    [self.playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    
    self.soundIcon.image = [UIImage imageNamed:@"sound_icon"];
    self.soundIcon.contentMode = UIViewContentModeScaleAspectFit;

    [self.addButton setImage:[UIImage imageNamed:@"sound_add"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"sound_edit"] forState:UIControlStateSelected];
    [self.addButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.addButton.backgroundColor = HEX_COLOR(@"#000000");
    [self changeAudioType:SoundShowViewAudioTypeEmpty];

}

- (void)setTipText:(NSString *)tipText {
    _tipText = tipText;
    [self dtUpdateUI];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.textLabel.text = self.tipText;

}

- (void)changeAudioType:(SoundShowViewAudioType)audioState {
    
    switch (audioState) {
        case SoundShowViewAudioTypeEmpty:
            self.addButton.selected = NO;
            self.playButton.hidden = YES;
            self.soundIcon.hidden = YES;
            self.textLabel.hidden = NO;
            break;
            
        case SoundShowViewAudioTypeExist:
            self.textLabel.hidden = YES;
            self.playButton.hidden = NO;
            self.soundIcon.hidden = NO;
            self.addButton.selected = YES;
            break;
            
        default:
            break;
    }
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _playButton;
}

- (UIImageView *)soundIcon {
    if (!_soundIcon) {
        _soundIcon = [[UIImageView alloc] init];
    }
    return _soundIcon;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc]init];
    }
    return _addButton;
}

- (UIView *)soundContentView {
    if(!_soundContentView){
        _soundContentView = [[UIView alloc]init];
    }
    return _soundContentView;
}

- (void)playButtonTapped:(UIButton *)sender {
    NSLog(@"播放按钮被点击");
    if (!UserService.shared.checkAiCloneAuth) {
        return;
    }
    // 处理播放逻辑
    if (!self.audioData) {
        if (self.noAudioPlayBlock) {
            self.noAudioPlayBlock();
        }
        return;
    }

    [self checkAndPlay];
}

- (void)checkAndPlay {
    if (self.audioData) {
        
        SudAudioItem *item = SudAudioItem.new;
        item.audioData = self.audioData;
        WeakSelf
        item.playStateChangedBlock = ^(SudAudioItem * _Nonnull item, SudAudioItemPlayerState playerState) {
            if (playerState == SudAudioItemPlayerStatePlaying) {
//                [self.soundIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self);
//                    make.size.mas_equalTo(CGSizeMake(131, 42));
//                    make.trailing.equalTo(@-8);
//                }];
                NSString *path = [NSBundle.mainBundle pathForResource:@"sud_shenlang" ofType:@"webp" inDirectory:@"Res"];
                [WebpImageCacheService.shared loadWebp:path result:^(UIImage *image) {
                    weakSelf.soundIcon.image = image;
                }];
            } else {
//                [self.soundIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self);
//                    make.size.mas_equalTo(CGSizeMake(131, 16));
//                    make.trailing.equalTo(@-8);
//                }];
                weakSelf.soundIcon.image = [UIImage imageNamed:@"sound_icon"];
            }
        };
        [SudAudioPlayer.shared playeAudioSingle:item];
    }
}

- (void)addButtonTapped:(UIButton *)sender {
    NSLog(@"添加按钮被点击");
    // 处理添加逻辑
    if (!UserService.shared.checkAiCloneAuth) {
        return;
    }
    
    if (self.clickAddBlock) {
        self.clickAddBlock();
    }
}

- (BaseView *)gradientView {
    if (!_gradientView) {
        _gradientView = BaseView.new;
        NSArray *colorArr = @[(id)[UIColor dt_colorWithHexString:@"#D8F7FF" alpha:1].CGColor, (id)[UIColor dt_colorWithHexString:@"#D8E2FF" alpha:1].CGColor];
        [_gradientView dtAddGradientLayer:@[@(0.0f), @(0.5f)] colors:colorArr startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1) cornerRadius:0];
    }
    return _gradientView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = HEX_COLOR_A(@"#1A1A1A", 0.5);
        _textLabel.font = UIFONT_REGULAR(14);
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _textLabel;
}

@end


//// gradient
//CAGradientLayer *gl = [CAGradientLayer layer];
//gl.frame = CGRectMake(36,746,243,36);
//gl.startPoint = CGPointMake(0, 0);
//gl.endPoint = CGPointMake(1, 1);
//gl.colors = @[(__bridge id)[UIColor colorWithRed:216/255.0 green:247/255.0 blue:255/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:216/255.0 green:226/255.0 blue:255/255.0 alpha:1].CGColor];
//gl.locations = @[@(0), @(1.0f)];
