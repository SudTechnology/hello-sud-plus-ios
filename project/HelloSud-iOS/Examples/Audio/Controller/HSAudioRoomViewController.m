//
//  HSAudioRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSAudioRoomViewController.h"
#import "HSRoomNaviView.h"
#import "HSRoomOperatorView.h"
#import "HSRoomMsgBgView.h"
#import "HSRoomMsgTableView.h"
#import "HSAudioMicContentView.h"

@interface HSAudioRoomViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) HSRoomNaviView *naviView;
@property (nonatomic, strong) HSRoomOperatorView *operatorView;
@property (nonatomic, strong) HSRoomMsgBgView *msgBgView;
@property (nonatomic, strong) HSRoomMsgTableView *msgTableView;
@property (nonatomic, strong) HSAudioMicContentView *micContentView;

@end

@implementation HSAudioRoomViewController

- (BOOL)hsIsHidenNavigationBar {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)hsAddViews {
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.naviView];
    [self.view addSubview:self.operatorView];
    [self.view addSubview:self.micContentView];
    [self.view addSubview:self.msgBgView];
    [self.msgBgView addSubview:self.msgTableView];
}

- (void)hsLayoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(kStatusBarHeight);
        make.height.mas_equalTo(44);
    }];
    [self.operatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-kAppSafeBottom);
        make.height.mas_equalTo(44);
    }];
    [self.micContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.naviView.mas_bottom).offset(20);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.msgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.micContentView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.operatorView.mas_top).offset(-20);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.msgBgView);
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"room_bg"];
    }
    return _bgImageView;
}

- (HSRoomNaviView *)naviView {
    if (!_naviView) {
        _naviView = [[HSRoomNaviView alloc] init];
    }
    return _naviView;
}

- (HSRoomOperatorView *)operatorView {
    if (!_operatorView) {
        _operatorView = [[HSRoomOperatorView alloc] init];
    }
    return _operatorView;
}

- (HSRoomMsgBgView *)msgBgView {
    if (!_msgBgView) {
        _msgBgView = [[HSRoomMsgBgView alloc] init];
    }
    return _msgBgView;
}

- (HSRoomMsgTableView *)msgTableView {
    if (!_msgTableView) {
        _msgTableView = [[HSRoomMsgTableView alloc] init];
    }
    return _msgTableView;
}

- (HSAudioMicContentView *)micContentView {
    if (!_micContentView) {
        _micContentView = [[HSAudioMicContentView alloc] init];
    }
    return _micContentView;
}

@end
