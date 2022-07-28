//
//  ISudNFTPrivateListener.h
//  Pods
//
//  Created by kaniel_mac on 2022/7/24.
//
//

#ifndef ISudNFTPrivateListener_h
#define ISudNFTPrivateListener_h

#import "ProtoHeader.h"

typedef void(^ISudNFTReqNFTListListener)(NSInteger errCode, NSString *_Nullable errMsg, GetNFTListRespModel *_Nullable nftListModel);
typedef void(^ISudNFTReqBindWalletListener)(NSInteger errCode, NSString *_Nullable errMsg, BindWalletRespModel *_Nullable resp);
typedef void(^ISudNFTReqGenerateDetailNFTTokenListener)(NSInteger errCode, NSString *_Nullable errMsg, GenerateDetailsNFTTokenRespModel *_Nullable resp);

#endif /* ISudNFTPrivateListener_h */
