//
//  HSRoomViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomViewController.h"
#import "HSRoomNaviView.h"
#import "HSRoomOperatorView.h"

@interface HSRoomViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) HSRoomNaviView *naviView;
@property (nonatomic, strong) HSRoomOperatorView *operatorView;

@end

@implementation HSRoomViewController

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
@end
