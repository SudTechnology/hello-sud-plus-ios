//
//  SoundRecordOperateView.m
//  HelloSudPlus
//
//  Created by kaniel on 6/24/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SoundRecordOperateView.h"
#import "SudAudioCapture.h"
#import "SudAudioPlayer.h"
#import "DTTimer.h"
#import "SoundShowView.h"

#define kLocalAudioPathKey @"sud-local-audio-path"





@interface SoundRecordOperateView()
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIView *textContentView;

@property(nonatomic, strong) UILabel *myVoiceLabel;
@property (nonatomic, strong) SoundShowView *soundShowView;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *submitButton;



@property(nonatomic, assign)NSTimeInterval beginRecordTs;
@property(nonatomic, assign)SoundStateType stateType;
@property(nonatomic, strong)SudAudioCapture *audioCapture;
@property(nonatomic, strong)SudAudioPlayer *audioPlayer;
@property(nonatomic, strong)NSData *audioData;
@property(nonatomic, strong)DTTimer *recordLimitTimer;


@end

@implementation SoundRecordOperateView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.titleLabel];
    [self addSubview:self.textContentView];
    [self.textContentView addSubview:self.textLabel];

    [self addSubview:self.myVoiceLabel];
    [self addSubview:self.soundShowView];
    
    [self addSubview:self.recordButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.submitButton];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    
    CGFloat btnH = 44;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@0);
    }];
    
    [self.textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.trailing.equalTo(@-8);
        make.top.equalTo(@8);
        make.bottom.equalTo(@-8);
        make.height.greaterThanOrEqualTo(@0);
    }];
    

    
    [self.myVoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(self.textContentView.mas_bottom).offset(12);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(@0);
        
    }];
    
    [self.soundShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(self.myVoiceLabel.mas_bottom).offset(8);
        make.height.equalTo(@(btnH));
        
    }];
    
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.top.equalTo(self.recordButton);
        make.height.equalTo(@(btnH));
        make.trailing.equalTo(self.submitButton.mas_leading).offset(-11);
        make.width.equalTo(self.submitButton);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
        make.top.equalTo(self.recordButton);
        make.height.equalTo(@(btnH));
    }];
    
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
        make.leading.equalTo(@0);
        make.top.equalTo(self.soundShowView.mas_bottom).offset(12);
        make.height.equalTo(@(btnH));
        make.bottom.equalTo(@0);
    }];



    
}



- (void)dtConfigUI {
    [super dtConfigUI];
    
    WeakSelf
    self.titleLabel.text = @"dt_ai_pls_read".dt_lan;
    self.myVoiceLabel.text = @"dt_llm_my_voice".dt_lan;
    self.soundShowView.tipText = @"dt_llm_press_tip".dt_lan;
    
    [self.cancelButton setTitle:@"dt_common_cancel".dt_lan forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = UIFONT_MEDIUM(14);
    [self.cancelButton setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = HEX_COLOR(@"#FFFFFF");
    self.cancelButton.layer.borderColor = HEX_COLOR(@"#000000").CGColor;
    self.cancelButton.layer.borderWidth = 0.5;
    [self.cancelButton dt_onClick:^(UIButton *sender) {
        if (!UserService.shared.checkAiCloneAuth) {
            return;
        }
        
        [weakSelf clearAudioData];
        if (weakSelf.cancelClick) {
            weakSelf.cancelClick();
        }
    }];
    
    [self.submitButton setTitle:@"dt_ai_submit".dt_lan forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = UIFONT_MEDIUM(14);
    [self.submitButton setTitleColor:HEX_COLOR(@"#FFFFFF") forState:UIControlStateNormal];
    self.submitButton.backgroundColor = HEX_COLOR(@"#000000");
    [self.submitButton dt_onClick:^(UIButton *sender) {
        if (!UserService.shared.checkAiCloneAuth) {
            return;
        }
        if (weakSelf.submitClick) {
            weakSelf.submitClick(weakSelf.audioData);
        }
    }];


    [self.recordButton setTitle:@"dt_ai_press_tip".dt_lan forState:UIControlStateNormal];
//    [self.recordButton setTitle:@"按住 录制" forState:UIControlStateSelected];
    [self.recordButton setBackgroundImage:HEX_COLOR(@"#000000").dt_toImage forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:HEX_COLOR(@"#666666").dt_toImage forState:UIControlStateSelected];
    [self.recordButton setBackgroundImage:HEX_COLOR(@"#666666").dt_toImage forState:UIControlStateHighlighted];

    self.recordButton.titleLabel.font = UIFONT_MEDIUM(14);
    [self.recordButton setTitleColor:HEX_COLOR(@"#FFFFFF") forState:UIControlStateNormal];
    [self.recordButton addTarget:self action:@selector(recordButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.recordButton.backgroundColor = HEX_COLOR(@"#000000");

    [self.recordButton addTarget:self action:@selector(onRecordTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self action:@selector(onRecordTouchCancel:) forControlEvents:UIControlEventTouchDragOutside];
    [self changeStateType:SoundStateTypeEmpty];
    [self checkAudioData];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.textLabel.text = UserService.shared.aiCloneInfoModel.audioText;
    
}

- (void)setAudioData:(NSData *)audioData {
    _audioData = audioData;
    self.soundShowView.audioData = self.audioData;
    
}

- (void)removeLastFile {
    NSString *fileName = [NSUserDefaults.standardUserDefaults objectForKey:kLocalAudioPathKey];
    if (fileName) {
        NSString *localPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), fileName];
        [NSFileManager.defaultManager removeItemAtPath:localPath error:nil];
    }
}

- (void)checkAudioData {
    
    // 测试
    NSString *fileName = [NSUserDefaults.standardUserDefaults objectForKey:kLocalAudioPathKey];
    if (fileName) {
        NSString *localPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), fileName];
        NSData *audioData = [NSData dataWithContentsOfFile:localPath];
        if (audioData.length > 0) {
            self.audioData = audioData;
            [self changeStateType:SoundStateTypeExist];
        }
    }
}

- (void)onRecordTouchDown:(id)sender {
    DDLogDebug(@"onRecordTouchDown");
    if (!UserService.shared.checkAiCloneAuth) {
        return;
    }
    [self startRecord];
}

- (void)onRecordTouchCancel:(id)sender {
    DDLogDebug(@"onRecordTouchCancel");
    if (!UserService.shared.checkAiCloneAuth) {
        return;
    }
    [self stopRecord];
}

- (void)playButtonTapped:(UIButton *)sender {
    DDLogDebug(@"播放按钮被点击");
    if (!UserService.shared.checkAiCloneAuth) {
        return;
    }
    // 处理播放逻辑
    [self handlePlayer];
}

- (void)recordButtonTapped:(UIButton *)sender {
    DDLogDebug(@"添加按钮被点击");
    if (!UserService.shared.checkAiCloneAuth) {
        return;
    }
    // 处理添加逻辑
    [self stopRecord];
}

- (void)startRecord {
    self.beginRecordTs = NSDate.date.timeIntervalSince1970;
    WeakSelf
    [self changeStateType:SoundStateTypeRecording];
    if (self.audioCapture) {
        [self.audioCapture stopCapture];
    }
    self.audioData = [[NSMutableData alloc]init];
    self.audioCapture = [[SudAudioCapture alloc]init];
    self.recordLimitTimer = [DTTimer timerWithTimeInterval:15 repeats:NO block:^(DTTimer *timer) {
        [weakSelf stopRecord];
    }];
    
//    [self.audioCapture startAudioRecordingWithFrameData:^(NSData * _Nonnull audioFrameData) {
//        [weakSelf.audioData appendData:audioFrameData];
//    }];
    
    [self.audioCapture startAudioRecordingWithTempFile:^(NSString * _Nonnull filePath) {
        [weakSelf removeLastFile];
        NSString *fileName = filePath.lastPathComponent;
        NSString *localPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), fileName];
        [NSFileManager.defaultManager removeItemAtPath:localPath error:nil];
        [NSFileManager.defaultManager copyItemAtPath:filePath toPath:localPath error:nil];
        [NSUserDefaults.standardUserDefaults setObject:fileName forKey:kLocalAudioPathKey];
        [NSUserDefaults.standardUserDefaults synchronize];
        
        NSData *fileData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMapped error:nil];
        weakSelf.audioData = fileData;
        
    }];
    
}

- (void)changeStateType:(SoundStateType)stateType {
    self.stateType = stateType;
    
    switch (stateType) {
        case SoundStateTypeEmpty:{
            [self.recordButton setTitle:@"dt_ai_press_tip".dt_lan forState:UIControlStateNormal];
            self.recordButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.submitButton.hidden = YES;
        }
            
            break;
        case SoundStateTypeExist:{
            self.recordButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.submitButton.hidden = YES;
            [self.recordButton setTitle:@"dt_llm_re_record".dt_lan forState:UIControlStateNormal];
        }
            
            break;
        case SoundStateTypeRecordEnd:{
            self.recordButton.hidden = YES;
            self.cancelButton.hidden = NO;
            self.submitButton.hidden = NO;
            [self.recordButton setTitle:@"dt_llm_re_record".dt_lan forState:UIControlStateNormal];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)stopRecord {
    if (self.audioCapture) {
        [self.audioCapture stopCapture];
    }
    if (self.recordLimitTimer) {
        [self.recordLimitTimer stopTimer];
        self.recordLimitTimer = nil;
    }
    NSTimeInterval currentTs = NSDate.date.timeIntervalSince1970;
    NSTimeInterval limit = 5;
    if ((currentTs - self.beginRecordTs) < limit) {
        [ToastUtil show:@"dt_ai_short_time_tip".dt_lan];
        [self changeStateType:SoundStateTypeEmpty];
        return;
    }
    [self changeStateType:SoundStateTypeRecordEnd];

}

- (void)handlePlayer {
    if (!self.audioData) {
        return;
    }
    SudAudioItem *item = [[SudAudioItem alloc]init];
    item.audioData = self.audioData;
    [SudAudioPlayer.shared playeAudioSingle:item];
}

- (UILabel *)titleLabel {
    if (!_textLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_REGULAR(16);
        _titleLabel.textColor = HEX_COLOR(@"1A1A1A");
    }
    return _titleLabel;
}

- (UILabel *)myVoiceLabel {
    if (!_myVoiceLabel) {
        _myVoiceLabel = [[UILabel alloc] init];
        _myVoiceLabel.font = UIFONT_REGULAR(16);
        _myVoiceLabel.textColor = HEX_COLOR(@"1A1A1A");
    }
    return _myVoiceLabel;
}



- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}


- (UIView *)textContentView {
    if (!_textContentView) {
        _textContentView = [[UIView alloc]init];
        _textContentView.backgroundColor = HEX_COLOR(@"#F5F5F5");
    }
    return _textContentView;
}


- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[UIButton alloc]init];
        [_recordButton dt_cornerRadius:4];
    }
    return _recordButton;
}


- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]init];
        [_cancelButton dt_cornerRadius:4];
    }
    return _cancelButton;
}


- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc]init];
        [_submitButton dt_cornerRadius:4];
    }
    return _submitButton;
}

- (SoundShowView *)soundShowView {
    if(!_soundShowView){
        _soundShowView = [[SoundShowView alloc]init];
        [_soundShowView dt_cornerRadius:4];
    }
    return _soundShowView;
}

- (void)clearAudioData {
    self.audioData = nil;
    [self changeStateType:SoundStateTypeEmpty];
}

@end
