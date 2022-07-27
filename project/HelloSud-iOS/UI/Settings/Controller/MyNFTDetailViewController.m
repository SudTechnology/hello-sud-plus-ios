//
//  HomeViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/24.
//

#import "MyNFTDetailViewController.h"

@interface MyNFTDetailViewController ()
@property(nonatomic, strong) UIImageView *iconImageView;

@end

@implementation MyNFTDetailViewController


- (void)dtConfigUI {
    self.view.backgroundColor = [UIColor dt_colorWithHexString:@"#F5F6FB" alpha:1];
}

- (void)dtConfigEvents {
    WeakSelf

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dtAddViews {
    [self.view addSubview:self.iconImageView];
}

- (void)dtLayoutViews {

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
}

#pragma mark - requst Data

- (void)requestData {
    WeakSelf

}

#pragma mark - 懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
@end
