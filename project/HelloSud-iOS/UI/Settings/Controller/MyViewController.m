//
//  HSSettingViewController.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "MyViewController.h"
#import "MyCell.h"
#import "HSSettingModel.h"
#import "ChangeRTCViewController.h"
#import "MyHeaderView.h"
#import "HSSettingViewController.h"
#import "AboutViewController.h"
#import <SudMGP/SudNFT.h>

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource, ISudNFTListener>
@property(nonatomic, strong) UITableView *tableView;
/// 页面数据
@property(nonatomic, strong) NSArray <NSArray <HSSettingModel *> *> *arrData;
@property(nonatomic, strong) MyHeaderView *myHeaderView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self configSudNFT];
}

- (void)configSudNFT {
    [SudNFT initNFTWithAppId:@"1461564080052506636" appKey:@"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc" userId:@"123" universalLink:@"https://fat-links.sud.tech" env:1 listener:self];
}

- (BOOL)dtIsHiddenNavigationBar {
    return YES;
}

/// 配置页面数据
- (void)configData {

    HSSettingModel *settingModel = [HSSettingModel new];
    settingModel.title = @"设置";
    settingModel.subTitle = nil;
    settingModel.isMore = YES;
    settingModel.pageURL = @"";

    HSSettingModel *aboutModel = [HSSettingModel new];
    aboutModel.title = @"关于我们";
    aboutModel.subTitle = nil;
    aboutModel.isMore = YES;
    aboutModel.pageURL = @"";

    self.arrData = @[@[settingModel], @[aboutModel]];
    [self.tableView reloadData];
}

- (void)checkWalletInfo {

    BOOL bindWallet = AppService.shared.login.walletAddress.length > 0;
    if (!bindWallet) {
        // 未绑定钱包
        [SudNFT getWalletListWithListener:^(NSInteger errCode, NSString *errMsg, NSArray<SudNFTWalletModel *> *walletList) {
            if (errCode != 0) {
                [ToastUtil show:errMsg];
                return;
            }
            [self.myHeaderView updateSupportWallet:walletList];
            [self reloadHeadView];
        }];
        return;
    }
    // 拉取NFT列表
    [SudNFT getNFTListWithWalletAddress:AppService.shared.login.walletAddress chainType:SudENFTEthereumChainsTypeGoerli pageKey:nil listener:^(NSInteger errCode, NSString *errMsg, SudNFTListModel *nftListModel) {
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            [ToastUtil show:msg];
            return;
        }
        [self.myHeaderView updateNFTList:nftListModel];
        [self reloadHeadView];
    }];
}

- (void)reloadHeadView {
    CGSize size = [self.myHeaderView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth, 10000)];
    CGRect targetFrame = CGRectMake(0, 0, kScreenWidth, size.height);
    self.myHeaderView.frame = targetFrame;
    self.tableView.tableHeaderView = self.myHeaderView;
}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.tableView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 16, 0, 16));
    }];

    [self reloadHeadView];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.myHeaderView.clickWalletBlock = ^(SudNFTWalletModel *m) {
        [SudNFT bindWallet:m.type listener:^(NSInteger errCode, NSString *errMsg, SudNFTBindWalletInfoModel *walletInfoModel) {
            if (errCode != 0) {
                NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
                [ToastUtil show:msg];
                return;
            }
            // 绑定钱包成功
            AppService.shared.login.walletAddress = walletInfoModel.address;
            [weakSelf.myHeaderView dtUpdateUI];
            [weakSelf checkWalletInfo];
        }];
    };
    self.myHeaderView.deleteWalletBlock = ^{
        [DTAlertView showTextAlert:@"确定要接触连接钱包吗？" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
            AppService.shared.login.walletAddress = nil;
            [weakSelf.myHeaderView dtUpdateUI];
            [weakSelf reloadHeadView];
            [weakSelf checkWalletInfo];
        }          onCloseCallback:nil];
    };
}

#pragma makr lazy

- (MyHeaderView *)myHeaderView {
    if (!_myHeaderView) {
        _myHeaderView = [[MyHeaderView alloc] init];
        _myHeaderView.backgroundColor = HEX_COLOR(@"#F5F6FB");
    }
    return _myHeaderView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[MyCell class] forCellReuseIdentifier:@"MyCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;

    }
    return _tableView;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCell *c = (MyCell *) cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.arrData[indexPath.section][indexPath.row];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HSSettingModel *model = self.arrData[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"设置"]) {
        HSSettingViewController *vc = HSSettingViewController.new;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:@"关于我们"]) {
        AboutViewController *vc = AboutViewController.new;
        vc.title = model.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    HSSettingModel *model = self.arrData[indexPath.section][indexPath.row];
    return model.isMore;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}
#pragma mark ISudNFTListener
/// SudNFT初始化状态
/// @param errCode 0 成功，非0 失败
/// @param errMsg 失败描述
- (void)onSudNFTInitStateChanged:(NSInteger)errCode errMsg:(NSString *_Nullable)errMsg {
    if (errCode != 0) {
        DDLogError(@"onSudNFTInitStateChanged: errCode:%@, errMsg:$@", @(errCode), errMsg);
        // SDK初始失败，重试或者提示错误
        return;
    }
    DDLogError(@"onSudNFTInitStateChanged init success");
    [self checkWalletInfo];
}

/// 绑定钱包token过期，需要重新验证绑定
- (void)onSudNFTBindWalletTokenExpired {
    DDLogWarn(@"onSudNFTBindWalletTokenExpired");
}
@end
