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

@interface MyViewController () <UITableViewDelegate, UITableViewDataSource, ISudNFTListener>
@property(nonatomic, strong) UITableView *tableView;
/// 页面数据
@property(nonatomic, strong) NSArray <NSArray <HSSettingModel *> *> *arrData;
@property(nonatomic, strong) MyHeaderView *myHeaderView;
@property(nonatomic, strong) NSArray<SudNFTWalletModel *> *walletList;
@property(nonatomic, strong) UIView *contactUsView;
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configData];
    [self configSudNFT];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)configSudNFT {
#if DEBUG
    // 测试环境
    [ISudAPPD e:2];
#endif
//    [SudNFT initNFTWithAppId:@"1461564080052506636" appKey:@"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc" userId:@"123" universalLink:@"https://fat-links.sud.tech"  listener:self];
    [SudNFT initNFTWithAppId:@"1486637108889305089"
                      appKey:@"wVC9gUtJNIDzAqOjIVdIHqU3MY6zF6SR"
                      userId:AppService.shared.loginUserID
               universalLink:@"https://fat-links.sud.tech"
                    listener:self];
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
    CGSize size = [self.contactUsView systemLayoutSizeFittingSize:CGSizeMake(kScreenWidth, 10000)];
    CGRect targetFrame = CGRectMake(0, 0, kScreenWidth, size.height);
    self.contactUsView.frame = targetFrame;
    self.tableView.tableFooterView = self.contactUsView;
//    [self.contactUsView mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.height.equalTo(@(size.height));
//       make.width.equalTo(@(kScreenWidth));
//       make.bottom.equalTo(@0);
//    }];
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
    [SudNFT getNFTListWithWalletAddress:AppService.shared.login.walletAddress chainType:HSAppPreferences.shared.selectedEthereumChainType pageKey:nil listener:^(NSInteger errCode, NSString *errMsg, SudNFTListModel *nftListModel) {
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            [ToastUtil show:msg];
            return;
        }
        [self.myHeaderView updateNFTList:nftListModel];
        [self reloadHeadView];
    }];
    // 更新链网数据
    if (self.walletList.count == 0) {
        [SudNFT getWalletListWithListener:^(NSInteger errCode, NSString *errMsg, NSArray<SudNFTWalletModel *> *walletList) {
            if (errCode != 0) {
                [ToastUtil show:errMsg];
                return;
            }
            self.walletList = walletList;
            [self updateWalletEtherChains];
        }];
    } else {
        [self updateWalletEtherChains];
    }
}

/// 更新钱包链网类型
- (void)updateWalletEtherChains {
    for (SudNFTWalletModel *m in self.walletList) {
        if (m.type == HSAppPreferences.shared.bindWalletType) {
            [self.myHeaderView updateEthereumList:m.chains];
            break;
        }
    }
    [self reloadHeadView];
}

- (void)reloadHeadView {
    CGFloat w = kScreenWidth - 32;
    [self.myHeaderView layoutIfNeeded];
    CGSize size = [self.myHeaderView systemLayoutSizeFittingSize:CGSizeMake(w, 10000)];
    CGRect targetFrame = CGRectMake(0, 0, w, size.height);
    DDLogDebug(@"reloadHeadView size:%@", [NSValue valueWithCGSize:size]);
    self.myHeaderView.frame = targetFrame;
    self.tableView.tableHeaderView = self.myHeaderView;
    [self.myHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.top.equalTo(@0);
       make.width.equalTo(@(w));
       make.height.equalTo(@(size.height));
    }];

}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.tableView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 16, 0, 16));
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
            HSAppPreferences.shared.bindWalletType = m.type;
            AppService.shared.login.walletAddress = walletInfoModel.address;
            [weakSelf.myHeaderView dtUpdateUI];
            [weakSelf reloadHeadView];
            [weakSelf checkWalletInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
        }];
    };
    self.myHeaderView.deleteWalletBlock = ^{
        [DTAlertView showTextAlert:@"确定要解除连接钱包吗？" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
            [UserService reqWearNFT:@"" isWear:NO success:^(BaseRespModel *resp) {
                AppService.shared.login.walletAddress = nil;
                [AppService.shared useNFT:@"" tokenId:@"" add:NO];
                AppService.shared.login.loginUserInfo.headerNftUrl = nil;
                AppService.shared.login.loginUserInfo.headerType = HSUserHeadTypeNormal;
                [AppService.shared.login saveLoginUserInfo];
                [weakSelf.myHeaderView dtUpdateUI];
                [weakSelf reloadHeadView];
                [weakSelf checkWalletInfo];
                [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
            } fail:nil];
        }          onCloseCallback:nil];
    };

    [[NSNotificationCenter defaultCenter] addObserverForName:MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf checkWalletInfo];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_NFT_WEAR_CHANGE_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf.myHeaderView dtUpdateUI];
    }];

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

- (UIView *)contactUsView {
    if (_contactUsView == nil) {
        _contactUsView = UIView.new;
        UILabel *usLabel = UILabel.new;
        usLabel.numberOfLines = 0;
        usLabel.text = NSString.dt_settings_contact_us;
        usLabel.textColor = HEX_COLOR(@"#8A8A8E");
        usLabel.font = UIFONT_REGULAR(12);
        usLabel.textAlignment = NSTextAlignmentCenter;
        usLabel.numberOfLines = 0;
        [_contactUsView addSubview:usLabel];
        usLabel.preferredMaxLayoutWidth = kScreenWidth - 34;
        [usLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(17);
            make.width.equalTo(@(kScreenWidth - 34));
            make.top.mas_equalTo(0);
            make.height.mas_greaterThanOrEqualTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return _contactUsView;
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
        [AppUtil.currentViewController.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:@"关于我们"]) {
        AboutViewController *vc = AboutViewController.new;
        vc.title = model.title;
        [AppUtil.currentViewController.navigationController pushViewController:vc animated:YES];
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
    AppService.shared.login.walletAddress = nil;
    [self.myHeaderView dtUpdateUI];
    [self reloadHeadView];
    [self checkWalletInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
}
@end
