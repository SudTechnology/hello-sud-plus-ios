//
//  ViewController.m
//  SudNFTQuickStart
//
//  Created by kaniel on 2022/9/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QuickStartViewController.h"
#import "SQSHeaderView.h"
#import "SQSBindWalletStateView.h"
#import "SQSCnAuthViewController.h"
#import "SQSCnWalletSwitchPopView.h"
#import "SQSCnWalletSelectPopView.h"
#import "SQSCnWalletDeletePopView.h"

@interface QuickStartViewController ()<ISudNFTListenerBindWallet>
@property(nonatomic, strong) NSArray<SudNFTWalletInfoModel *> *walletList;
@property(nonatomic, weak) SQSBindWalletStateView *bindWalletStateView;
/// 等待绑定钱包信息
@property(nonatomic, strong) SudNFTWalletInfoModel *waitBindWalletInfo;
@property(nonatomic, strong) SQSHeaderView *myHeaderView;
@end

@implementation QuickStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColor.orangeColor;
    self.title = @"SudNFTQuickStart";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.myHeaderView.deleteBtn];
    [self configSudNFT];
    
}

- (void)configSudNFT {
    BOOL isTestEnv = NO;
#if DEBUG
    // 测试环境
    [ISudNFTD e:3];
    isTestEnv = YES;
#endif
    NSString *sudNFTSDKVersoin = [SudNFT getVersion];
    NSLog(@"sudNFTSDKVersoin:%@", sudNFTSDKVersoin);

    SudInitNFTParamModel *paramModel = SudInitNFTParamModel.new;
    paramModel.appId = @"1486637108889305089";
    paramModel.appKey = @"wVC9gUtJNIDzAqOjIVdIHqU3MY6zF6SR";
    paramModel.userId = @"12345";
    paramModel.universalLink = @"https://links.sud.tech";
    paramModel.isTestEnv = isTestEnv;
    WeakSelf
    [SudNFT initNFT:paramModel
           listener:^(NSInteger errCode, NSString *_Nullable errMsg) {
               if (errCode != 0) {
                   DDLogError(@"initNFT: errCode:%@, errMsg:%@", @(errCode), errMsg);
                   // SDK初始失败，重试或者提示错误
                   return;
               }
               DDLogError(@"onSudNFTInitStateChanged init success");
               [weakSelf checkWalletInfo];
           }];
}

- (void)checkWalletInfo {

    BOOL bindWallet = SudNFTQSAppPreferences.shared.isBindWallet;
    if (!bindWallet) {
        // 未绑定钱包
        [SudNFT getWalletList:^(NSInteger errCode, NSString *errMsg, SudNFTGetWalletListModel *getWalletListModel) {
            if (errCode != 0) {
                [ToastUtil show:errMsg];
                return;
            }
            self.walletList = getWalletListModel.walletList;
            SudNFTQSAppPreferences.shared.walletList = self.walletList;
            [self.myHeaderView updateSupportWallet:getWalletListModel.walletList];
            [self reloadHeadView];
        }];
        return;
    }
    // 拉取NFT列表
    if (SudNFTQSAppPreferences.shared.isBindForeignWallet) {
        [self getNFTList];
    } else if (SudNFTQSAppPreferences.shared.isBindCNWallet) {
        [self getCNCollectionList];
    }
    // 更新链网数据
    if (self.walletList.count == 0) {
        [SudNFT getWalletList:^(NSInteger errCode, NSString *errMsg, SudNFTGetWalletListModel *getWalletListModel) {
            if (errCode != 0) {
                [ToastUtil show:errMsg];
                return;
            }
            self.walletList = getWalletListModel.walletList;
            SudNFTQSAppPreferences.shared.walletList = self.walletList;
            [self updateWalletEtherChains];
        }];
    } else {
        [self updateWalletEtherChains];
    }
}

/// 获取NFT列表
- (void)getNFTList {
    SudNFTGetNFTListParamModel *paramModel = SudNFTGetNFTListParamModel.new;
    paramModel.walletToken = SudNFTQSAppPreferences.shared.walletToken;
    paramModel.walletAddress = SudNFTQSAppPreferences.shared.walletAddress;
    paramModel.chainType = SudNFTQSAppPreferences.shared.selectedEthereumChainType;
    paramModel.pageKey = nil;
    [SudNFT getNFTList:paramModel listener:^(NSInteger errCode, NSString *errMsg, SudNFTGetNFTListModel *nftListModel) {
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            [ToastUtil show:msg];
            if (errCode == 1008) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_BIND_TOKEN_EXPIRED_NTF object:nil userInfo:nil];
            }
            return;
        }
        SudNFTQSAppPreferences.shared.nftListPageKey = nftListModel.pageKey;
        [self.myHeaderView updateNFTList:nftListModel];
        [self reloadHeadView];
    }];
}

/// 获取国内收藏品
- (void)getCNCollectionList {
    SudNFTGetCnNFTListParamModel *paramModel = SudNFTGetCnNFTListParamModel.new;
    paramModel.pageSize = 20;
    paramModel.pageNumber = 0;
    paramModel.walletType = SudNFTQSAppPreferences.shared.currentSelectedWalletType;
    paramModel.walletToken = [SudNFTQSAppPreferences.shared getBindUserTokenByWalletType:paramModel.walletType];
    [SudNFT getCnNFTList:paramModel listener:^(NSInteger errCode, NSString *errMsg, SudNFTGetCnNFTListModel *resp) {
        if (errCode != 0) {
            NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
            [ToastUtil show:msg];
            if (errCode == 1008) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WALLET_BIND_TOKEN_EXPIRED_NTF object:nil userInfo:nil];
            }
            return;
        }
        [self.myHeaderView updateCardList:resp];
        [self reloadHeadView];
    }];
}

/// 更新钱包链网类型
- (void)updateWalletEtherChains {
    for (SudNFTWalletInfoModel *m in self.walletList) {
        if (m.type == SudNFTQSAppPreferences.shared.bindWalletType) {
            [self.myHeaderView updateEthereumList:m.chainList];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_WALLET_LIST_UPDATE_NTF object:nil userInfo:nil];
    [self reloadHeadView];
}

- (void)reloadHeadView {

}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.myHeaderView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self reloadHeadView];
    CGFloat w = kScreenWidth - 32;
    [self.myHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.width.equalTo(@(w));
        make.height.greaterThanOrEqualTo(@0);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    WeakSelf
    self.myHeaderView.clickWalletBlock = ^(SudNFTWalletInfoModel *m) {

        weakSelf.waitBindWalletInfo = m;
        if (m.zoneType == 1) {
            [weakSelf handleCNWalletClick:m selectView:nil];
            return;
        }
        // 海外 绑定三方钱包
        SQSBindWalletStateView *bindWalletStateView = [[SQSBindWalletStateView alloc] init];
        [DTAlertView show:bindWalletStateView rootView:nil clickToClose:NO showDefaultBackground:YES onCloseCallback:^{

        }];

        weakSelf.bindWalletStateView = bindWalletStateView;

        SudNFTBindWalletParamModel *paramModel = SudNFTBindWalletParamModel.new;
        paramModel.walletType = m.type;
        [SudNFT bindWallet:paramModel listener:self];
    };
    self.myHeaderView.deleteWalletBlock = ^{
        if (SudNFTQSAppPreferences.shared.bindZoneType == 1) {
            // 绑定的是国内
            SQSCnWalletSelectPopView *v = SQSCnWalletSelectPopView.new;
            __weak typeof(v) weakV = v;
            v.selectedWalletBlock = ^(SudNFTWalletInfoModel *walletInfoModel) {
                [weakSelf handleCNWalletClick:walletInfoModel selectView:weakV];
            };
            [DTSheetView show:v onCloseCallback:nil];
            [DTSheetView addPanGesture];
            NSMutableArray *cnWalletList = NSMutableArray.new;
            for (SudNFTWalletInfoModel *m in weakSelf.walletList) {
                if (m.zoneType == 1) {
                    [cnWalletList addObject:m];
                }
            }
            [v updateDataList:cnWalletList];
            return;
        }

        [DTAlertView showTextAlert:@"确定要解除连接钱包吗？" sureText:@"确定" cancelText:@"取消" onSureCallback:^{
//            [UserService reqWearNFT:@"" isWear:NO success:^(BaseRespModel *resp) {
//                HSAppPreferences.shared.walletAddress = nil;
//                HSAppPreferences.shared.bindWalletType = -1;
//                HSAppPreferences.shared.currentSelectedWalletType = -1;
//                HSAppPreferences.shared.bindZoneType = -1;
//                [AppService.shared useNFT:@"" tokenId:@"" add:NO];
//                AppService.shared.login.loginUserInfo.headerNftUrl = nil;
//                AppService.shared.login.loginUserInfo.headerType = HSUserHeadTypeNormal;
//                [AppService.shared.login saveLoginUserInfo];
//                [weakSelf.myHeaderView dtUpdateUI];
//                [weakSelf reloadHeadView];
//                [weakSelf checkWalletInfo];
//                [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
//            }                  fail:nil];
        }          onCloseCallback:nil];
    };

    [[NSNotificationCenter defaultCenter] addObserverForName:MY_ETHEREUM_CHAINS_SELECT_CHANGED_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf checkWalletInfo];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:MY_NFT_WEAR_CHANGE_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf.myHeaderView dtUpdateUI];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:WALLET_BIND_TOKEN_EXPIRED_NTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf onSudNFTBindWalletTokenExpired];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:NFT_REFRESH_NFT object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        id temp = note.userInfo[@"nft"];
        id cardTemp = note.userInfo[@"card"];
        if (temp && [temp isKindOfClass:[SudNFTGetNFTListModel class]]) {
            SudNFTGetNFTListModel *nft = (SudNFTGetNFTListModel *)temp;
            [self.myHeaderView updateNFTList:nft];
            [self reloadHeadView];
        } else if (cardTemp && [cardTemp isKindOfClass:[SudNFTGetCnNFTListModel class]]) {
            SudNFTGetCnNFTListModel *card = (SudNFTGetCnNFTListModel *)cardTemp;
            [self.myHeaderView updateCardList:card];
            [self reloadHeadView];
        }
    }];

}

/// 处理国内钱包选择
- (void)handleCNWalletClick:(SudNFTWalletInfoModel *)walletInfoModel selectView:(SQSCnWalletSelectPopView *)selectView {

    WeakSelf
    BOOL isBind = [SudNFTQSAppPreferences.shared getBindUserTokenByWalletType:walletInfoModel.type].length > 0;
    // 未绑定
    if (!isBind) {
        [DTSheetView close];
        // 国内钱包授权
        SQSCnAuthViewController *vc = SQSCnAuthViewController.new;
        vc.bindSuccessBlock = ^{
            [weakSelf.myHeaderView dtUpdateUI];
            [weakSelf reloadHeadView];
            [weakSelf checkWalletInfo];

            [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
        };
        vc.walletInfoModel = walletInfoModel;
        [AppUtil.currentViewController.navigationController pushViewController:vc animated:YES];
        return;
    }
    // 已绑定，解除绑定

    SQSCnWalletDeletePopView *v = SQSCnWalletDeletePopView.new;
    v.walletInfoModel = walletInfoModel;
    [v dtUpdateUI];
    UIView *coverView = UIView.new;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCover:)];
    [coverView addGestureRecognizer:tap];
    coverView.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
    [AppUtil.currentWindow addSubview:coverView];
    [coverView addSubview:v];
    [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.greaterThanOrEqualTo(@0);
    }];
    __weak typeof(coverView) weakCoverView = coverView;
    v.cancelBlock = ^{
        [weakCoverView removeFromSuperview];
    };
    v.sureBlock = ^{
        SudNFTUnBindCnWalletParamModel *paramModel = SudNFTUnBindCnWalletParamModel.new;
        paramModel.walletType = SudNFTQSAppPreferences.shared.currentSelectedWalletType;
        paramModel.userId = SudNFTQSAppPreferences.shared.userId;
        paramModel.phone = [SudNFTQSAppPreferences.shared getBindUserPhoneByWalletType:paramModel.walletType];
        [SudNFT unbindCnWallet:paramModel listener:^(NSInteger errCode, NSString *_Nullable errMsg) {
            DDLogDebug(@"unbind user errcode:%@, msg:%@", @(errCode), errMsg);
        }];

        [weakCoverView removeFromSuperview];
        [DTSheetView close];
        [SudNFTQSAppPreferences.shared clearBindUserInfoWithWalletType:walletInfoModel.type];
        SudNFTQSAppPreferences.shared.walletAddress = nil;
        [weakSelf.myHeaderView dtUpdateUI];
        [weakSelf reloadHeadView];
        [weakSelf checkWalletInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
    };
}

- (void)onTapCover:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
}

- (void)showBindErrorAlert:(NSString *)msg {
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", @"连接失败"]];
    attrTitle.yy_lineSpacing = 16;
    attrTitle.yy_font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    attrTitle.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    attrTitle.yy_alignment = NSTextAlignmentCenter;

    NSMutableAttributedString *attrStr_0 = [[NSMutableAttributedString alloc] initWithString:msg];
    attrStr_0.yy_lineSpacing = 6;
    attrStr_0.yy_font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    attrStr_0.yy_color = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
    attrStr_0.yy_alignment = NSTextAlignmentCenter;
    [attrTitle appendAttributedString:attrStr_0];
    [DTAlertView showAttrTextAlert:attrTitle sureText:@"确定" cancelText:nil rootView:nil onSureCallback:^{
        [DTAlertView close];
    }              onCloseCallback:nil];
    return;
}

#pragma makr lazy

- (SQSHeaderView *)myHeaderView {
    if (!_myHeaderView) {
        _myHeaderView = [[SQSHeaderView alloc] init];
        _myHeaderView.backgroundColor = HEX_COLOR(@"#F5F6FB");
    }
    return _myHeaderView;
}

#pragma mark ISudNFTListener

/// 绑定钱包token过期，需要重新验证绑定
- (void)onSudNFTBindWalletTokenExpired {
    DDLogWarn(@"onSudNFTBindWalletTokenExpired");
    SudNFTQSAppPreferences.shared.walletAddress = nil;
    NSInteger walletType = SudNFTQSAppPreferences.shared.currentSelectedWalletType;
    [SudNFTQSAppPreferences.shared clearBindUserInfoWithWalletType:walletType];
    SudNFTQSAppPreferences.shared.bindZoneType = -1;
    [self.myHeaderView dtUpdateUI];
    [self reloadHeadView];
    [self checkWalletInfo];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
}

/// 绑定钱包成功回调
/// @param walletInfoModel 成功回调
- (void)onSuccess:(SudNFTBindWalletModel *_Nullable)walletInfoModel {

    // 绑定钱包成功
    SudNFTQSAppPreferences.shared.bindWalletType = self.waitBindWalletInfo.type;
    SudNFTQSAppPreferences.shared.bindZoneType = self.waitBindWalletInfo.zoneType;
    SudNFTQSAppPreferences.shared.walletAddress = walletInfoModel.walletAddress;
    [SudNFTQSAppPreferences.shared cacheWalletToken:walletInfoModel walletAddress:walletInfoModel.walletAddress];
    [self.myHeaderView dtUpdateUI];
    [self reloadHeadView];
    [self checkWalletInfo];

    [[NSNotificationCenter defaultCenter] postNotificationName:MY_NFT_BIND_WALLET_CHANGE_NTF object:nil userInfo:nil];
//    [DTAlertView close];
}

/// 绑定钱包
- (void)onFailure:(NSInteger)errCode errMsg:(NSString *_Nullable)errMsg {

    [DTAlertView close];
    if (errCode != 0) {
        NSString *msg = [NSString stringWithFormat:@"%@(%@)", errMsg, @(errCode)];
        DDLogError(@"bind wallet err:%@", msg);
        [self showBindErrorAlert:msg];
        return;
    }
}

/// 钱包绑定事件通知，可以使用此状态做交互状态展示
/// @param stage 1: 连接；2：签名
/// @param event 1：连接开始；2 成功连接钱包；3：签名开始；4:签名结束
- (void)onBindStageEvent:(NSInteger)stage event:(NSInteger)event {
    DDLogDebug(@"onBindStageEvent:%@, event:%@", @(stage), @(event));
    [self.bindWalletStateView updateStage:stage event:event];
}

/// 绑定步骤顺序列表
/// @param stageList 对应状态事件列表，如：["1", "2"]
- (void)onBindStageList:(NSArray <NSNumber *> *_Nullable)stageList {

}
@end
