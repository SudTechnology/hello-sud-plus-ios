//
//  RespGetWalletListModel.h
//  SudMGP
//
//  Created by kaniel on 2022/7/23.
//

#import <Foundation/Foundation.h>
#import "BaseRespModel.h"
#import "SudNFTModels.h"

NS_ASSUME_NONNULL_BEGIN
/// 响应获取钱包列表数据
@interface GetWalletListRespModel : BaseRespModel
@property(nonatomic, copy)NSArray<SudNFTWalletModel *> *wallets;
@end

NS_ASSUME_NONNULL_END
