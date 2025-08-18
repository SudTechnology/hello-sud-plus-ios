//
//  AddBotOperateView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "AddBotOperateView.h"
@interface AddBotOperateView()
@property(nonatomic, strong)UIView *operateView;
@property(nonatomic, strong)UIButton *cancelBtn;
@property(nonatomic, strong)UIButton *addRobotBtn;
@property(nonatomic, strong)UIButton *addDefaultBtn;
@property(nonatomic, strong)UIButton *addCustomBtn;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIView *lineViewH;

@property(nonatomic, strong)UILabel *addRobotLabel;
@property(nonatomic, strong)UILabel *addLlmBotLabel;
@end

@implementation AddBotOperateView

- (void)dtAddViews {
    [self addSubview:self.operateView];
    [self.operateView addSubview:self.addRobotLabel];
    [self.operateView addSubview:self.addLlmBotLabel];
    [self addSubview:self.cancelBtn];
    [self.operateView addSubview:self.lineView];
    [self.operateView addSubview:self.lineViewH];
    [self.operateView addSubview:self.addRobotBtn];
    [self.operateView addSubview:self.addDefaultBtn];
    [self.operateView addSubview:self.addCustomBtn];
}

- (void)dtLayoutViews {
    
    CGFloat bottom = kAppSafeBottom;
    
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.mas_equalTo(36);
        make.width.mas_equalTo(36);
    }];
    
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.equalTo(@(-bottom));
    }];
    
    [self.addRobotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@16);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(self.lineView.mas_leading);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.addRobotLabel.mas_trailing).offset(19);
        make.width.mas_equalTo(0.5);
        make.top.equalTo(@16);
        make.bottom.equalTo(@-16);
        make.trailing.equalTo(self.addRobotBtn.mas_leading).offset(-16);
    }];
    
    [self.addRobotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@16);
        
        make.trailing.equalTo(@-16);
        make.height.mas_equalTo(40);
        make.width.equalTo(@180);
        
    }];
    
    [self.lineViewH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addRobotBtn.mas_bottom).offset(16);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [self.addLlmBotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(self.lineViewH.mas_bottom).offset(16);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.addDefaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineViewH.mas_bottom).offset(16);
        make.leading.equalTo(self.addRobotBtn);
        make.trailing.equalTo(self.addRobotBtn);
        make.height.mas_equalTo(40);
        make.width.equalTo(@180);
        
    }];
    
    [self.addCustomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addDefaultBtn.mas_bottom).offset(16);
        make.leading.equalTo(self.addRobotBtn);
        make.trailing.equalTo(self.addRobotBtn);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(@-16);
        make.width.equalTo(@180);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = HEX_COLOR(@"#F5F6FB");
    self.operateView.backgroundColor = UIColor.whiteColor;
    [self.operateView dt_cornerRadius:8];
}



- (void)onBtnOperate:(UIButton *)sender {
    if (self.operateCallback) self.operateCallback(sender.tag);
}

- (void)onBtnCancel:(UIButton *)sender {
    if (self.cancelCallback) self.cancelCallback(sender);
}



- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setImage:[UIImage imageNamed:@"llm_close"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_cancelBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(onBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (UIButton *)addRobotBtn {
    if (_addRobotBtn == nil) {
        _addRobotBtn = UIButton.new;
        [_addRobotBtn setTitle:@"dt_llm_add_robot".dt_lan forState:UIControlStateNormal];
        _addRobotBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_addRobotBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_addRobotBtn addTarget:self action:@selector(onBtnOperate:) forControlEvents:UIControlEventTouchUpInside];
        _addRobotBtn.tag = 1;
        [_addRobotBtn dt_setGradientBackgroundWithColors:@[HEX_COLOR_A(@"#B9FFD2", 1), HEX_COLOR_A(@"#3CFFB6", 1)] locations:@[@(0), @(1.0f)] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];
        [_addRobotBtn dt_cornerRadius:4];
    }
    return _addRobotBtn;
}

- (UIButton *)addDefaultBtn {
    if (_addDefaultBtn == nil) {
        _addDefaultBtn = UIButton.new;
        [_addDefaultBtn setTitle:@"dt_llm_add_pre_avatar".dt_lan forState:UIControlStateNormal];
        _addDefaultBtn.titleLabel.font = UIFONT_REGULAR(16);
        [_addDefaultBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        _addDefaultBtn.tag = 2;
        [_addDefaultBtn addTarget:self action:@selector(onBtnOperate:) forControlEvents:UIControlEventTouchUpInside];
        [_addDefaultBtn dt_setGradientBackgroundWithColors:@[HEX_COLOR_A(@"#B9FFD2", 1), HEX_COLOR_A(@"#3CFFB6", 1)] locations:@[@(0), @(1.0f)] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];
        [_addDefaultBtn dt_cornerRadius:4];
    }
    return _addDefaultBtn;
}

- (UIButton *)addCustomBtn {
    if (_addCustomBtn == nil) {
        _addCustomBtn = UIButton.new;
        [_addCustomBtn setTitle:@"dt_llm_add_player_avatar".dt_lan  forState:UIControlStateNormal];
        _addCustomBtn.titleLabel.font = UIFONT_REGULAR(16);
        _addCustomBtn.tag = 3;
        [_addCustomBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_addCustomBtn addTarget:self action:@selector(onBtnOperate:) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomBtn dt_setGradientBackgroundWithColors:@[HEX_COLOR_A(@"#B9FFD2", 1), HEX_COLOR_A(@"#3CFFB6", 1)] locations:@[@(0), @(1.0f)] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];
        [_addCustomBtn dt_cornerRadius:4];
    }
    return _addCustomBtn;
}


- (UIView *)operateView {
    if (_operateView == nil) {
        _operateView = UIView.new;
    }
    return _operateView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HEX_COLOR(@"#D1D1D1");
    }
    return _lineView;
}

- (UIView *)lineViewH {
    if (_lineViewH == nil) {
        _lineViewH = UIView.new;
        _lineViewH.backgroundColor = HEX_COLOR(@"#D1D1D1");
    }
    return _lineViewH;
}

- (UILabel *)addRobotLabel {
    if (!_addRobotLabel) {
        _addRobotLabel = UILabel.new;
        _addRobotLabel.font = UIFONT_REGULAR(16);
        _addRobotLabel.textColor = UIColor.blackColor;
        _addRobotLabel.text = @"dt_llm_add_robot_ai".dt_lan;
    }
    return _addRobotLabel;
}

- (UILabel *)addLlmBotLabel {
    if (!_addLlmBotLabel) {
        _addLlmBotLabel = UILabel.new;
        _addLlmBotLabel.font = UIFONT_REGULAR(16);
        _addLlmBotLabel.textColor = UIColor.blackColor;
        _addLlmBotLabel.text = @"dt_llm_add_llm_ai".dt_lan;
    }
    return _addLlmBotLabel;
}

@end
