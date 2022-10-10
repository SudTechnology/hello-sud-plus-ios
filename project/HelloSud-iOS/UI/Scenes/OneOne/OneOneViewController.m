//
//  OneOneViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/9.
//

#import "OneOneViewController.h"
#import "OneOneAudioContentView.h"

@interface OneOneViewController ()
@property(nonatomic, strong) OneOneAudioContentView *audioContentView;
@end

@implementation OneOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (Class)serviceClass {
    return AudioRoomService.class;
}


- (void)dtAddViews {
    [super dtAddViews];
    [self.sceneView addSubview:self.audioContentView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.audioContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.bottom.trailing.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.naviView.hidden = YES;
    self.operatorView.hidden = YES;
    self.msgBgView.hidden = YES;
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.audioContentView.hangupBlock = ^{
        [DTAlertView showTextAlert:@"确定要挂断通话吗？" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
            [DTAlertView close];
            [weakSelf exitRoomFromSuspend:NO finished:nil];
        }          onCloseCallback:nil];
    };
}

/// 是否显示添加通用机器人按钮
- (BOOL)isShowAddRobotBtn {
    return NO;
}

- (OneOneAudioContentView *)audioContentView {
    if (!_audioContentView) {
        _audioContentView = OneOneAudioContentView.new;
    }
    return _audioContentView;
}

@end
