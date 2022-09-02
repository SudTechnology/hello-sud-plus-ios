//
//  LoginViewController.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
/// 国内三方钱包登录授权页面
@interface SQSCnAuthViewController : BaseViewController
@property (nonatomic, copy)void(^bindSuccessBlock)(void);
@property (nonatomic, strong)SudNFTWalletInfoModel *walletInfoModel;
@end

NS_ASSUME_NONNULL_END
