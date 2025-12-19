//
//  ViewController.m
//  QuickStart-Runtime
//
//  Created by kaniel on 10/27/25.
//

#import "Runtime1ViewController.h"
#import "QsrCommon.h"

@interface Runtime1ViewController()

@property(nonatomic, strong)UIButton *backBtn;
@property(nonatomic, strong)UIButton *startBtn;
@property(nonatomic, strong)UIButton *destroyBtn;
@property(nonatomic, strong)UIView *gameContentView;
@property(nonatomic, strong)id<ISudRt1GameHandle> gameHandle1;
@property(nonatomic, strong)UIView *gameView;

@property(nonatomic, strong)NSDictionary *gameInfo;
@end

@implementation Runtime1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameInfo = @{@"gameId": @"sud.tech.test",
                      @"version":@"1.0.6",
                      @"path": @"https://hello-sud-plus.sudden.ltd/ad/resource/rungame/performance.sp"};
    
    [SVProgressHUD setOffsetFromCenter:UIOffsetMake(self.view.frame.size.width/2., self.view.frame.size.height/2.)];
    self.view.backgroundColor = UIColor.redColor;
    
    [self.view addSubview:self.gameContentView];
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.destroyBtn];
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.leading.equalTo(@10);
        make.width.height.equalTo(@40);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view.mas_centerX).offset(-10);
        make.height.equalTo(@44);
        make.width.equalTo(@80);
        make.bottom.equalTo(@-90);
    }];
    
    [self.destroyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_centerX).offset(10);
        make.height.equalTo(@44);
        make.width.equalTo(@80);
        make.bottom.equalTo(@-90);
    }];
    
    [self.gameContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self updateBtnStateWithIsLoadedGame:NO];
}

- (void)backClick:(id)sender {
    [self.gameHandle1 destroy];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateBtnStateWithIsLoadedGame:(BOOL)isLoadGame {
    if (isLoadGame) {
        self.startBtn.enabled = NO;
        self.destroyBtn.enabled = YES;
    } else {
        self.startBtn.enabled = YES;
        self.destroyBtn.enabled = NO;
    }
}

- (void)startClick:(UIButton *)sender {
    
    [self destroyClick:nil];
    
    [ISudAPPD e:3];
    [ISudAPPD d];
    [[SudGIP getCfg] setLogLevel:SudLogDEBUG];
    [SVProgressHUD showWithStatus:@"Login"];
    [SVProgressHUD setMaximumDismissTimeInterval:3];
    
    /// get code from app server
    [QsrCommon.shared reqGetCode:^(NSString *code) {
        [SVProgressHUD dismiss];
        
        SudRtInitSDKParamModel *paramModel = [[SudRtInitSDKParamModel alloc]init];
        paramModel.appId = SUDMGP_APP_ID;
        paramModel.appKey = SUDMGP_APP_KEY;
        paramModel.code = code;
        /// SDK will skip if initialized, so call it everytime would be ok
        [SudRuntime2 initSDK:paramModel completion:^(NSError *_Nullable error) {
            if (error) {
                NSLog(@"initSDK result:%@", error.localizedDescription);
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                [self updateBtnStateWithIsLoadedGame:NO];
                return;
            }
            [self handleLoadGame];
        }];
    } fail:^(NSInteger code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
        [self updateBtnStateWithIsLoadedGame:NO];
    }];

}

- (void)handleLoadGame {
    
    SudRt1LoadGameParamModel *paramModel = SudRt1LoadGameParamModel.new;
    paramModel.gameId = self.gameInfo[@"gameId"];
    paramModel.version = self.gameInfo[@"version"];
    paramModel.path = self.gameInfo[@"path"];
    
    [SVProgressHUD showProgress:0 status:@"Loading Game"];

    WeakSelf
    /// Loading Game
    [SudRuntime1 loadGame:paramModel progress:^(NSInteger progress) {
        NSLog(@"loadGame progress:%@", @(progress));
        [SVProgressHUD showProgress:progress/100.0 status:@"Loading Game"];
    } completion:^(id<ISudRt1GameHandle> _Nullable gameHandle, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        NSLog(@"loadGame result:%@", error);
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [weakSelf updateBtnStateWithIsLoadedGame:NO];
            return;
        }
        weakSelf.gameHandle1 = gameHandle;
        /// Running game
        [weakSelf onGameHandleCreateSuccess1:paramModel];
    }];

}

- (void)onGameHandleCreateSuccess1:(SudRt1LoadGameParamModel *)loadGamePramModel {

    UIView *gameView = [self.gameHandle1 getGameView];
    self.gameView = gameView;
    [self.gameContentView addSubview:gameView];
    [gameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.gameContentView);
    }];
    
    NSLog(@"_onGameHandleCreateSuccess:%@", loadGamePramModel.gameId);
    [_gameHandle1 start];
    
    [self updateBtnStateWithIsLoadedGame:YES];
}


- (void)destroyCurrentGame {
    if (_gameHandle1) {
        [_gameHandle1 destroy];
    }
    if (self.gameView) {
        [self.gameView removeFromSuperview];
        self.gameView = nil;
    }
}


- (void)destroyClick:(id)sender {
    [self destroyCurrentGame];
    [self updateBtnStateWithIsLoadedGame:NO];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"landscape_navi_back"] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UIView *)gameContentView {
    if (!_gameContentView) {
        _gameContentView = [[UIView alloc]init];
    }
    return _gameContentView;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setBackgroundImage:[self imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_startBtn setTitle:@"Start" forState:UIControlStateNormal];
        _startBtn.layer.cornerRadius = 15;
        _startBtn.clipsToBounds = YES;
        [_startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)destroyBtn {
    if (!_destroyBtn) {
        _destroyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_destroyBtn setBackgroundImage:[self imageWithColor:UIColor.orangeColor] forState:UIControlStateNormal];
        [_destroyBtn setTitle:@"Destroy" forState:UIControlStateNormal];
        _destroyBtn.layer.cornerRadius = 15;
        _destroyBtn.clipsToBounds = YES;
        [_destroyBtn addTarget:self action:@selector(destroyClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _destroyBtn;
}
@end

