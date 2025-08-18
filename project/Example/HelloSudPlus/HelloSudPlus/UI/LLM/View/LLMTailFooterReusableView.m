//
//  LLMTailFooterReusableView.m
//  HelloSudPlus
//
//  Created by kaniel on 6/23/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "LLMTailFooterReusableView.h"
#import "SoundShowView.h"
#import "BotMoreView.h"
#import "SoundRecordOperateView.h"
#import "CommonStringSelectPopView.h"
#import "TagContentView.h"

/// 分身语音状态
typedef NS_ENUM(NSInteger, AiCloneVoiceStateType) {
    AiCloneVoiceStateTypeEmpty = 0,// 空
    AiCloneVoiceStateTypeAvailable = 1,// 可利用
    AiCloneVoiceStateTypeWaitForRecord = 2, // 等待录制
    AiCloneVoiceStateTypeRecorded = 3,// 已经录制
};

@interface AiConfigInfoModel : NSObject<UITextFieldDelegate>
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSArray<NSString *> *personalities;// 性格特点
@property(nonatomic, strong)NSArray<NSString *> *languageStyles;// 语言风格
@property(nonatomic, strong)NSArray<NSString *> *languageDetailStyles;// 语言详细风格
@end

@implementation AiConfigInfoModel
@end


@interface LLMTailFooterReusableView()
@property(nonatomic, strong) UIView *rootContentView;
@property(nonatomic, strong) UIView *botContentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UISwitch *switchClone;
@property(nonatomic, strong) UILabel *switchLabel;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UITextField *nameTextField;
@property(nonatomic, strong) UILabel *characterLabel;
@property(nonatomic, strong) UIButton *characterMorBtn;
@property(nonatomic, strong) TagContentView *characterMoreView;

@property(nonatomic, strong) UILabel *styleLabel;
@property(nonatomic, strong) UIButton *styleMorBtn;
@property(nonatomic, strong) TagContentView *languageStyleMoreView;

@property(nonatomic, strong) UILabel *storyLabel;
@property(nonatomic, strong) UIButton *storyMorBtn;
@property(nonatomic, strong) TagContentView *languageDetailStyleMoreView;

@property(nonatomic, strong) UILabel *voiceLabel;
@property(nonatomic, strong) SoundShowView *voiceView;

@property(nonatomic, strong) UIView *lineViewFirst;
@property(nonatomic, strong) UIView *lineViewSecond;
@property(nonatomic, strong) UIView *lineViewThird;
@property(nonatomic, strong) UIView *lineViewFourth;
@property(nonatomic, strong) UIView *lineViewFifth;


@property(nonatomic, strong) UIButton *saveBtn;

@property(nonatomic, strong) UIView *soundContentView;

@property(nonatomic, strong) SoundRecordOperateView *recordOperateView;
@property(nonatomic, strong)AiConfigInfoModel *configInfoModel;
@property(nonatomic, assign)AiCloneVoiceStateType voiceStateType;

@end

@implementation LLMTailFooterReusableView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.rootContentView];
    [self.rootContentView addSubview:self.titleLabel];
    [self.rootContentView addSubview:self.botContentView];
    [self.rootContentView addSubview:self.soundContentView];
    
    
    [self.botContentView addSubview:self.switchLabel];
    [self.botContentView addSubview:self.switchClone];
    [self.botContentView addSubview:self.lineViewFirst];
    
    [self.botContentView addSubview:self.nameLabel];
    [self.botContentView addSubview:self.nameTextField];
    [self.botContentView addSubview:self.lineViewSecond];
    
    [self.botContentView addSubview:self.characterLabel];
    [self.botContentView addSubview:self.characterMorBtn];
    [self.botContentView addSubview:self.characterMoreView];
    [self.botContentView addSubview:self.lineViewThird];
    
    [self.botContentView addSubview:self.styleLabel];
    [self.botContentView addSubview:self.styleMorBtn];
    [self.botContentView addSubview:self.languageStyleMoreView];
    [self.botContentView addSubview:self.lineViewFourth];
    
    [self.botContentView addSubview:self.storyLabel];
    [self.botContentView addSubview:self.storyMorBtn];
    [self.botContentView addSubview:self.languageDetailStyleMoreView];
    
    [self.botContentView addSubview:self.lineViewFifth];
    [self.botContentView addSubview:self.saveBtn];
    

    [self.soundContentView addSubview:self.voiceLabel];
    [self.soundContentView addSubview:self.voiceView];
    [self.soundContentView addSubview:self.recordOperateView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    
    
    CGFloat margin = 20;
    CGFloat elementHeight = 22;
    CGFloat top = 12;
    CGFloat btnH = 44;
    
    [self.rootContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(self.whiteCoverView.mas_bottom).offset(20);
        make.height.greaterThanOrEqualTo(@0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.equalTo(@20);
    }];
    [self.botContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
    }];
    
    [self.soundContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.botContentView.mas_bottom).offset(12);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.bottom.equalTo(@-12);
    }];

    
    [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.botContentView).offset(margin);
        make.top.equalTo(self.botContentView).offset(18);
        make.height.equalTo(@(elementHeight));
    }];
    
    [self.switchClone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.centerY.equalTo(self.switchLabel);
    }];
    
    [self.lineViewFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(margin));
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.switchLabel.mas_bottom).offset(16);
        make.height.equalTo(@(0.5));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.botContentView).offset(margin);
        make.top.equalTo(self.lineViewFirst.mas_bottom).offset(margin);
        make.height.equalTo(@(elementHeight));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.height.equalTo(@(36));
    }];
    
    [self.lineViewSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(margin));
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.nameTextField.mas_bottom).offset(top);
        make.height.equalTo(@(0.5));
    }];
    
    [self.characterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.botContentView).offset(margin);
        make.top.equalTo(self.lineViewSecond.mas_bottom).offset(top);
        make.height.equalTo(@(elementHeight));
    }];
    
    [self.characterMorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.centerY.equalTo(self.characterLabel);
        make.height.equalTo(@(36));
    }];
    
    [self.characterMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.top.equalTo(self.characterLabel.mas_bottom).offset(8);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.lineViewThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(margin));
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.characterMoreView.mas_bottom).offset(top);
        make.height.equalTo(@(0.5));
    }];
    
    [self.styleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.botContentView).offset(margin);
        make.top.equalTo(self.lineViewThird.mas_bottom).offset(margin);
        make.height.equalTo(@(elementHeight));
    }];
    
    [self.styleMorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.centerY.equalTo(self.styleLabel);
        make.height.equalTo(@(36));
    }];
    
    [self.languageStyleMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.top.equalTo(self.styleLabel.mas_bottom).offset(top);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.lineViewFourth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(margin));
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.languageStyleMoreView.mas_bottom).offset(top);
        make.height.equalTo(@(0.5));
    }];
    
    [self.storyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.botContentView).offset(margin);
        make.top.equalTo(self.lineViewFourth.mas_bottom).offset(top);
        make.height.equalTo(@(elementHeight));
    }];
    
    [self.storyMorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.centerY.equalTo(self.storyLabel);
        make.height.equalTo(@(36));
    }];
    
    [self.languageDetailStyleMoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.trailing.equalTo(self.botContentView).offset(-margin);
        make.top.equalTo(self.storyLabel.mas_bottom).offset(top);
        make.height.greaterThanOrEqualTo(@0);
    }];
    
    [self.lineViewFifth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(margin));
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.languageDetailStyleMoreView.mas_bottom).offset(top);
        make.height.equalTo(@(0.5));
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(margin));
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.lineViewFifth.mas_bottom).offset(top);
        make.height.equalTo(@(btnH));
        make.bottom.equalTo(@-12);
    }];
    
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(margin));
        make.top.equalTo(@18);
        make.height.equalTo(@(elementHeight));
        make.trailing.equalTo(@(-margin));
    }];

    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.voiceLabel);
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.voiceLabel.mas_bottom).offset(8);
        make.height.equalTo(@(btnH));
    }];
    
    [self.recordOperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.voiceLabel);
        make.trailing.equalTo(@(-margin));
        make.top.equalTo(self.voiceView.mas_bottom).offset(12);
        make.height.greaterThanOrEqualTo(@(0));
        make.bottom.equalTo(@-12);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
//    self.backgroundColor = UIColor.redColor;
    self.voiceView.tipText = @"dt_hold_press_tip".dt_lan;
    self.switchClone.onTintColor = HEX_COLOR(@"#000000");
    [self.switchClone addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    self.nameTextField.borderStyle = UITextBorderStyleNone;
    self.nameTextField.placeholder = @"dt_ai_input_name".dt_lan;
    self.nameTextField.layer.borderColor = HEX_COLOR(@"#979797").CGColor;
    self.nameTextField.layer.borderWidth = 0.5;
    self.nameTextField.font = UIFONT_REGULAR(14);
    self.nameTextField.textColor = HEX_COLOR(@"#1A1A1A");
    // 创建一个透明的占位视图，宽度为 15pt
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 36)];
    self.nameTextField.leftView = paddingView;
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.delegate = self;

    
    NSArray<UILabel *> *labels = @[self.switchLabel, self.nameLabel, self.characterLabel, self.styleLabel, self.storyLabel, self.voiceLabel];
    for (UILabel *label in labels) {
        label.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        label.font = UIFONT_REGULAR(16);
    }
    
    self.switchLabel.text = @"dt_ai_open_clone".dt_lan;
    self.nameLabel.text = @"dt_ai_clone_name".dt_lan;
    self.characterLabel.text = @"dt_ai_clone_character_title".dt_lan;
    self.styleLabel.text = @"dt_ai_clone_language_style".dt_lan;
    self.storyLabel.text = @"dt_ai_clone_language_detail_style".dt_lan;
    self.voiceLabel.text = @"dt_ai_voice".dt_lan;
    
    [self changeAiCloneVoiceState:AiCloneVoiceStateTypeEmpty];
    
}

- (void)relayoutContent {
    [UIView animateWithDuration:0.25 animations:^{
        [self.colView reloadData];
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
//    [self.characterMoreView dt_onTap:^(UITapGestureRecognizer * _Nonnull tap) {
//        if (!UserService.shared.checkAiCloneAuth) {
//            return;
//        }
//        [weakSelf showCharacterSelectView];
//    }];
//    [self.languageStyleMoreView dt_onTap:^(UITapGestureRecognizer * _Nonnull tap) {
//        if (!UserService.shared.checkAiCloneAuth) {
//            return;
//        }
//        [weakSelf showLanguageStyleSelectView];
//    }];
//    [self.languageDetailStyleMoreView dt_onTap:^(UITapGestureRecognizer * _Nonnull tap) {
//        if (!UserService.shared.checkAiCloneAuth) {
//            return;
//        }
//        [weakSelf showLanguageDetailStyleSelectView];
//    }];
    [self.characterMorBtn dt_onClick:^(UIButton *sender) {
        if (!UserService.shared.checkAiCloneAuth) {
            return;
        }
        sender.selected = !sender.selected;
        [weakSelf relayoutContent];
        
    }];
    
    [self.styleMorBtn dt_onClick:^(UIButton *sender) {
        if (!UserService.shared.checkAiCloneAuth) {
            return;
        }
        sender.selected = !sender.selected;
        [weakSelf relayoutContent];
    }];
    
    [self.storyMorBtn dt_onClick:^(UIButton *sender) {
        if (!UserService.shared.checkAiCloneAuth) {
            return;
        }
        sender.selected = !sender.selected;
        [weakSelf relayoutContent];
    }];
    
    [self.saveBtn dt_onClick:^(UIButton *sender) {
        if (!UserService.shared.checkAiCloneAuth) {
            return;
        }
        [weakSelf handleSave];
    }];
    
    self.characterMoreView.clickTagBlock = ^(NSArray * _Nonnull tagList) {
//        if (tagList.count == 0) {
//            return;
//        }
//        NSString *str = [tagList componentsJoinedByString:@","];
//        weakSelf.configInfoModel.personality = str;
        weakSelf.configInfoModel.personalities = tagList;
    };
    self.languageStyleMoreView.clickTagBlock = ^(NSArray * _Nonnull tagList) {
//        if (tagList.count == 0) {
//            return;
//        }
//        NSString *str = [tagList componentsJoinedByString:@","];
//        weakSelf.configInfoModel.languageStyle = str;
        weakSelf.configInfoModel.languageStyles = tagList;
    };
    self.languageDetailStyleMoreView.clickTagBlock = ^(NSArray * _Nonnull tagList) {
//        if (tagList.count == 0) {
//            return;
//        }
//        NSString *str = [tagList componentsJoinedByString:@","];
//        weakSelf.configInfoModel.languageDetailStyle = str;
        weakSelf.configInfoModel.languageDetailStyles = tagList;
    };
    
    /// 没有声音可播放
    self.voiceView.noAudioPlayBlock = ^{
        [ToastUtil showProgress:nil];
        [UserService.shared refreshAiCloneInfo:^(RespAiCloneInfoModel * _Nonnull aiCloneInfoModel) {
            [ToastUtil dimiss];
            [weakSelf dtUpdateUI];
            // 点击按钮，刷新到音频则播放
            if (weakSelf.voiceView.audioData) {
                [weakSelf.voiceView checkAndPlay];
            } else if (aiCloneInfoModel.aiInfo.voiceStatus == 1) {
                [ToastUtil show:@"dt_voice_training".dt_lan];
            } else if (aiCloneInfoModel.aiInfo.voiceStatus == 3) {
                [ToastUtil show:@"dt_voice_training_failed".dt_lan];
            }
            
        }];
    };
    

//    self.voiceView.clickAddBlock = ^{
//        // 去录制
//        [weakSelf changeAiCloneVoiceState:AiCloneVoiceStateTypeWaitForRecord];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf.colView reloadData];
//        });
//    };
    
    self.recordOperateView.submitClick = ^(NSData * _Nonnull audioData) {
        
        [weakSelf handleSubmit:audioData];
        
    };
    
}

/// 处理提交数据
- (void)handleSave {
    
    
    if (self.configInfoModel.personalities.count == 0 ||
        self.configInfoModel.languageStyles.count == 0 ||
        self.configInfoModel.languageDetailStyles.count == 0) {
        [ToastUtil show:@"dt_llm_pls_select_tip".dt_lan];
        return;
    }
    
    ReqSaveAiCloneInfoModel *reqModel = ReqSaveAiCloneInfoModel.new;

    reqModel.nickname = self.nameTextField.text;
    reqModel.personalities = self.configInfoModel.personalities;
    reqModel.languageStyles = self.configInfoModel.languageStyles;
    reqModel.languageDetailStyles = self.configInfoModel.languageDetailStyles;
    reqModel.birthday = @"2000-05-20";
    NSString *bloodType = @"";
    NSString *mbti = @"";
    
    NSArray *tempBloodTypeArr = UserService.shared.aiCloneInfoModel.bloodTypeOptions;
    if (tempBloodTypeArr.count > 0) {
        NSInteger count = tempBloodTypeArr.count;
        bloodType = tempBloodTypeArr[arc4random()%count];
    }
    NSArray *tempMbtiArr = UserService.shared.aiCloneInfoModel.mbtiOptions;
    if (tempMbtiArr.count > 0) {
        NSInteger count = tempMbtiArr.count;
        mbti = tempMbtiArr[arc4random()%count];
    }
    reqModel.bloodType = bloodType;
    reqModel.mbti = mbti;
    reqModel.audioFormat = @"wav";
    WeakSelf
    [ToastUtil showProgress:@"dt_llm_save_tip".dt_lan];
    [UserService.shared reqSaveAiCloneInfo:reqModel success:^(BaseRespModel * _Nonnull resp) {
        [ToastUtil show:@"dt_llm_save_success".dt_lan];
    } fail:nil];
}

/// 处理提交数据
- (void)handleSubmit:(NSData *)audioData {
    
    
    if (self.configInfoModel.personalities.count == 0 ||
        self.configInfoModel.languageStyles.count == 0 ||
        self.configInfoModel.languageDetailStyles.count == 0) {
        [ToastUtil show:@"dt_llm_pls_select_tip".dt_lan];
        return;
    }
    
    ReqSaveAiCloneInfoModel *reqModel = ReqSaveAiCloneInfoModel.new;

    reqModel.nickname = self.nameTextField.text;
    reqModel.personalities = self.configInfoModel.personalities;
    reqModel.languageStyles = self.configInfoModel.languageStyles;
    reqModel.languageDetailStyles = self.configInfoModel.languageDetailStyles;
    reqModel.birthday = @"2000-05-20";
    NSString *bloodType = @"";
    NSString *mbti = @"";
    
    NSArray *tempBloodTypeArr = UserService.shared.aiCloneInfoModel.bloodTypeOptions;
    if (tempBloodTypeArr.count > 0) {
        NSInteger count = tempBloodTypeArr.count;
        bloodType = tempBloodTypeArr[arc4random()%count];
    }
    NSArray *tempMbtiArr = UserService.shared.aiCloneInfoModel.mbtiOptions;
    if (tempMbtiArr.count > 0) {
        NSInteger count = tempMbtiArr.count;
        mbti = tempMbtiArr[arc4random()%count];
    }
    reqModel.bloodType = bloodType;
    reqModel.mbti = mbti;
    reqModel.audioData = [audioData base64EncodedStringWithOptions:0];
    reqModel.audioFormat = @"wav";
    WeakSelf
    [ToastUtil showProgress:@"dt_llm_submit_tip".dt_lan];
    [UserService.shared reqSaveAiCloneInfo:reqModel success:^(BaseRespModel * _Nonnull resp) {
        [ToastUtil dimiss];
        [weakSelf changeAiCloneVoiceState:AiCloneVoiceStateTypeAvailable];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf.colView reloadData];
//        });
    } fail:nil];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];

    RespAiCloneInfoModel *aiCloneInfoModel = UserService.shared.aiCloneInfoModel;
    if (aiCloneInfoModel) {
        self.configInfoModel.nickname = self.configInfoModel.nickname ?: aiCloneInfoModel.aiInfo.nickname;
        self.configInfoModel.personalities = self.configInfoModel.personalities ?: aiCloneInfoModel.aiInfo.personalities;
        self.configInfoModel.languageStyles = self.configInfoModel.languageStyles ?: aiCloneInfoModel.aiInfo.languageStyles;
        self.configInfoModel.languageDetailStyles = self.configInfoModel.languageDetailStyles ?: aiCloneInfoModel.aiInfo.languageDetailStyles;
    }
    
    NSString *emptyStr = @"dt_selected_empty".dt_lan;
    NSString *nickName = [NSString stringWithFormat:@"%@",AppService.shared.login.loginUserInfo.name];
    if (self.nameTextField.text.length == 0) {
        self.nameTextField.text = self.configInfoModel.nickname ?: nickName;
        if (!self.configInfoModel.nickname) {
            self.configInfoModel.nickname = nickName;
        }
    }
//    self.characterMoreView.text = self.configInfoModel.personality ?: emptyStr;
//    self.languageStyleMoreView.text = self.configInfoModel.languageStyle ?: emptyStr;
//    self.languageDetailStyleMoreView.text = self.configInfoModel.languageDetailStyle ?: emptyStr;
    
    CGFloat contentWidth = kScreenWidth - 40 - 36;
    NSArray * characterMoreViewList = aiCloneInfoModel.personalityOptions;// @[@"你好",@"可爱",@"我是中国人",@"你好，你是谁呀"];
    self.characterMoreView.limitLines = self.characterMorBtn.selected ? 0 : 2;
    self.characterMoreView.defaultSelectedList = self.configInfoModel.personalities;
    [self.characterMoreView updateTagList:characterMoreViewList contentWidth:contentWidth];
    
    NSArray * languageStyleMoreViewList = aiCloneInfoModel.languageStyleOptions;// @[@"你好",@"可爱",@"我是中国人",@"你好，你是谁呀"];
    self.languageStyleMoreView.limitLines = self.styleMorBtn.selected ? 0 : 2;
    self.languageStyleMoreView.defaultSelectedList = self.configInfoModel.languageStyles;
    [self.languageStyleMoreView updateTagList:languageStyleMoreViewList contentWidth:contentWidth];
    
    NSArray * languageDetailStyleMoreViewList = aiCloneInfoModel.languageDetailStyleOptions;// @[@"你好",@"可爱",@"我是中国人",@"你好，你是谁呀"];
    self.languageDetailStyleMoreView.limitLines = self.storyMorBtn.selected ? 0 : 2;
    self.languageDetailStyleMoreView.defaultSelectedList = self.configInfoModel.languageDetailStyles;
    [self.languageDetailStyleMoreView updateTagList:languageDetailStyleMoreViewList contentWidth:contentWidth];
    
    
    self.switchClone.on = UserService.shared.isAiCloneOpen;
    // 声音可用
    if (aiCloneInfoModel.aiInfo.demoAudioData.length > 0) {
        if (self.voiceStateType == AiCloneVoiceStateTypeEmpty) {
            
            [self changeAiCloneVoiceState:AiCloneVoiceStateTypeAvailable];
        }
        NSData *audioData = [[NSData alloc]initWithBase64EncodedString:aiCloneInfoModel.aiInfo.demoAudioData options:0];
        self.voiceView.audioData =  audioData;
    }
    if (aiCloneInfoModel.aiInfo.voiceStatus == 1 ||
        aiCloneInfoModel.aiInfo.voiceStatus == 2) {
        [self.voiceView changeAudioType:SoundShowViewAudioTypeExist];
    }
}

/// 性格特点列表
- (void)showCharacterSelectView {
//    RespAiCloneInfoModel *aiCloneInfoModel = UserService.shared.aiCloneInfoModel;
//    CommonStringSelectPopView *v = CommonStringSelectPopView.new;
//    NSArray *list = aiCloneInfoModel.personalityOptions;
//    NSMutableArray <CommonListStringCellModel *>*modelList = [[NSMutableArray alloc]init];
//    NSInteger index = -1;
//    for (int i = 0; i < list.count; ++i) {
//        NSString *title = list[i];
//        CommonListStringCellModel *m = [[CommonListStringCellModel alloc]init];
//        m.title = title;
//        if ([self.configInfoModel.personality isEqualToString:title]) {
//            m.isSelected = YES;
//            index = i;
//        }
//        [modelList addObject:m];
//    }
//    WeakSelf
//    [v updateCellModelList:modelList selectedIndex:index];
//    v.selectedBlock = ^(NSInteger selectedIndex) {
//        weakSelf.configInfoModel.personality = modelList[selectedIndex].title;
//        [weakSelf dtUpdateUI];
//    };
//    [DTSheetView show:v onCloseCallback:nil];
    
}

/// 分身语音状态
- (void)changeAiCloneVoiceState:(AiCloneVoiceStateType)stateType {

    self.voiceStateType = stateType;
    switch (stateType) {
        case AiCloneVoiceStateTypeEmpty:{
            /// 无语音
        }
            
            break;
        case AiCloneVoiceStateTypeAvailable:{
            /// 可利用

            [self.voiceView changeAudioType:SoundShowViewAudioTypeExist];
            [self.recordOperateView changeStateType: SoundStateTypeExist];
            [self.recordOperateView dtUpdateUI];
        }
            break;
        case AiCloneVoiceStateTypeWaitForRecord: {
            // 等待录制
            [self.recordOperateView clearAudioData];
            [self.recordOperateView dtUpdateUI];
        }
            
        case AiCloneVoiceStateTypeRecorded:{
            // 已经录制
        }
            
        default:
            break;
    }
}

/// 语言风格列表
- (void)showLanguageStyleSelectView {
//    RespAiCloneInfoModel *aiCloneInfoModel = UserService.shared.aiCloneInfoModel;
//    CommonStringSelectPopView *v = CommonStringSelectPopView.new;
//    NSArray *list = aiCloneInfoModel.languageStyleOptions;
//    NSMutableArray <CommonListStringCellModel *>*modelList = [[NSMutableArray alloc]init];
//    NSInteger index = -1;
//    for (int i = 0; i < list.count; ++i) {
//        NSString *title = list[i];
//        CommonListStringCellModel *m = [[CommonListStringCellModel alloc]init];
//        m.title = title;
//        if ([self.configInfoModel.languageStyle isEqualToString:title]) {
//            m.isSelected = YES;
//            index = i;
//        }
//        [modelList addObject:m];
//    }
//    WeakSelf
//    [v updateCellModelList:modelList selectedIndex:index];
//    v.selectedBlock = ^(NSInteger selectedIndex) {
//        weakSelf.configInfoModel.languageStyle = modelList[selectedIndex].title;
//        [weakSelf dtUpdateUI];
//    };
//    [DTSheetView show:v onCloseCallback:nil];
    
}

/// 语言详细风格
- (void)showLanguageDetailStyleSelectView {
//    RespAiCloneInfoModel *aiCloneInfoModel = UserService.shared.aiCloneInfoModel;
//    CommonStringSelectPopView *v = CommonStringSelectPopView.new;
//    NSArray *list = aiCloneInfoModel.languageDetailStyleOptions;
//    NSMutableArray <CommonListStringCellModel *>*modelList = [[NSMutableArray alloc]init];
//    NSInteger index = -1;
//    for (int i = 0; i < list.count; ++i) {
//        NSString *title = list[i];
//        CommonListStringCellModel *m = [[CommonListStringCellModel alloc]init];
//        m.title = title;
//        if ([self.configInfoModel.languageDetailStyle isEqualToString:title]) {
//            m.isSelected = YES;
//            index = i;
//        }
//        [modelList addObject:m];
//    }
//    WeakSelf
//    [v updateCellModelList:modelList selectedIndex:index];
//    v.selectedBlock = ^(NSInteger selectedIndex) {
//        weakSelf.configInfoModel.languageDetailStyle = modelList[selectedIndex].title;
//        [weakSelf dtUpdateUI];
//    };
//    [DTSheetView show:v onCloseCallback:nil];
    
}



- (UIView *)rootContentView {
    if (!_rootContentView) {
        _rootContentView = UIView.new;
    }
    return _rootContentView;
}

- (UIView *)botContentView {
    if (!_botContentView) {
        _botContentView = UIView.new;
        _botContentView.backgroundColor = UIColor.whiteColor;
        [_botContentView dt_cornerRadius:8];
    }
    return _botContentView;
}

- (UIView *)soundContentView {
    if (!_soundContentView) {
        _soundContentView = UIView.new;
        _soundContentView.backgroundColor = UIColor.whiteColor;
        [_soundContentView dt_cornerRadius:8];
    }
    return _soundContentView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = UIFONT_MEDIUM(14);
        _titleLabel.text = @"dt_create_clone".dt_lan;
    }
    return _titleLabel;
}

- (UISwitch *)switchClone {
    if (!_switchClone) {
        _switchClone = [[UISwitch alloc] init];
        _switchClone.on = NO;
    }
    return _switchClone;
}

- (UILabel *)switchLabel {
    if (!_switchLabel) {
        _switchLabel = [[UILabel alloc] init];
    }
    return _switchLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
}

- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
    }
    return _nameTextField;
}

- (UILabel *)characterLabel {
    if (!_characterLabel) {
        _characterLabel = [[UILabel alloc] init];
    }
    return _characterLabel;
}

- (UILabel *)styleLabel {
    if (!_styleLabel) {
        _styleLabel = [[UILabel alloc] init];
    }
    return _styleLabel;
}

- (UILabel *)storyLabel {
    if (!_storyLabel) {
        _storyLabel = [[UILabel alloc] init];
    }
    return _storyLabel;
}

- (UILabel *)voiceLabel {
    if (!_voiceLabel) {
        _voiceLabel = [[UILabel alloc] init];
    }
    return _voiceLabel;
}

- (SoundShowView *)voiceView {
    if (!_voiceView) {
        _voiceView = [[SoundShowView alloc] init];
        [_voiceView dt_cornerRadius:4];
    }
    return _voiceView;
}


- (UIView *)lineViewFirst {
    if (!_lineViewFirst) {
        _lineViewFirst = [[UIView alloc]init];
        _lineViewFirst.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineViewFirst;
}

- (UIView *)lineViewSecond {
    if (!_lineViewSecond) {
        _lineViewSecond = [[UIView alloc]init];
        _lineViewSecond.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineViewSecond;
}

- (UIView *)lineViewThird {
    if (!_lineViewThird) {
        _lineViewThird = [[UIView alloc]init];
        _lineViewThird.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineViewThird;
}



- (UIView *)lineViewFourth {
    if (!_lineViewFourth) {
        _lineViewFourth = [[UIView alloc]init];
        _lineViewFourth.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineViewFourth;
}

- (UIView *)lineViewFifth {
    if (!_lineViewFifth) {
        _lineViewFifth = [[UIView alloc]init];
        _lineViewFifth.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineViewFifth;
}

- (TagContentView *)characterMoreView {
    if (!_characterMoreView) {
        _characterMoreView = [[TagContentView alloc]init];
    }
    return _characterMoreView;
}

- (TagContentView *)languageStyleMoreView {
    if (!_languageStyleMoreView) {
        _languageStyleMoreView = [[TagContentView alloc]init];
    }
    return _languageStyleMoreView;
}

- (TagContentView *)languageDetailStyleMoreView {
    if (!_languageDetailStyleMoreView) {
        _languageDetailStyleMoreView = [[TagContentView alloc]init];
    }
    return _languageDetailStyleMoreView;
}

- (SoundRecordOperateView *)recordOperateView {
    if (!_recordOperateView) {
        _recordOperateView = [[SoundRecordOperateView alloc]init];
    }
    return _recordOperateView;
}

- (UIButton *)storyMorBtn {
    if (!_storyMorBtn) {
        _storyMorBtn = UIButton.new;
        [_storyMorBtn setTitle:@"dt_llm_more".dt_lan forState:UIControlStateNormal];
        [_storyMorBtn setTitle:@"dt_llm_hidden".dt_lan forState:UIControlStateSelected];
        _storyMorBtn.titleLabel.font = UIFONT_REGULAR(12);
        [_storyMorBtn setTitleColor:HEX_COLOR(@"#666666") forState:UIControlStateNormal];
    }
    return _storyMorBtn;
}

- (UIButton *)characterMorBtn {
    if (!_characterMorBtn) {
        _characterMorBtn = UIButton.new;
        [_characterMorBtn setTitle:@"dt_llm_more".dt_lan forState:UIControlStateNormal];
        [_characterMorBtn setTitle:@"dt_llm_hidden".dt_lan forState:UIControlStateSelected];
        _characterMorBtn.titleLabel.font = UIFONT_REGULAR(12);
        [_characterMorBtn setTitleColor:HEX_COLOR(@"#666666") forState:UIControlStateNormal];
    }
    return _characterMorBtn;
}

- (UIButton *)styleMorBtn {
    if (!_styleMorBtn) {
        _styleMorBtn = UIButton.new;
        [_styleMorBtn setTitle:@"dt_llm_more".dt_lan forState:UIControlStateNormal];
        [_styleMorBtn setTitle:@"dt_llm_hidden".dt_lan forState:UIControlStateSelected];
        _styleMorBtn.titleLabel.font = UIFONT_REGULAR(12);
        [_styleMorBtn setTitleColor:HEX_COLOR(@"#666666") forState:UIControlStateNormal];
    }
    return _styleMorBtn;
}


- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = UIButton.new;
        [_saveBtn setTitle:@"dt_llm_save".dt_lan forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = UIFONT_MEDIUM(14);
        [_saveBtn setTitleColor:HEX_COLOR(@"#FFFFFF") forState:UIControlStateNormal];
        _saveBtn.backgroundColor = HEX_COLOR(@"#000000");
        [_saveBtn dt_cornerRadius:4];
    }
    return _saveBtn;
}




- (void)switchValueChanged:(UISwitch *)sender {
    BOOL isOn = sender.isOn;
    NSLog(@"Switch状态改变: %@", isOn ? @"开启" : @"关闭");
    // 可以在这里添加处理switch状态变化的逻辑
    WeakSelf
    ReqAiSwitchStateModel *reqModel = ReqAiSwitchStateModel.new;
    reqModel.status = isOn ? 1 : 0;
    [UserService.shared reqChangeAiState:reqModel success:^(BaseRespModel * _Nonnull resp) {
        UserService.shared.isAiCloneOpen = isOn;
        [weakSelf dtUpdateUI];
        if (!isOn) {
            [ToastUtil show:@"dt_close_clone_tip".dt_lan];
        }
    } fail:^(NSError *error) {
        sender.on = isOn ? NO : YES;
    }];
}

- (AiConfigInfoModel *)configInfoModel {
    if (!_configInfoModel) {
        _configInfoModel = [[AiConfigInfoModel alloc]init];
    }
    return _configInfoModel;
}


- (CGFloat)perferHeight {
    [self layoutIfNeeded];
    CGRect rect = self.rootContentView.frame;
    return rect.size.height + rect.origin.y;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return UserService.shared.checkAiCloneAuth;
}

@end
