//
//  SudAdCacheManager.m
//  HelloSudPlus
//
//  Created by kaniel on 12/18/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudAdCacheManager.h"
#import "SudAdCollectionViewCell.h"
#import "SudAdItemModel.h"
#import "SudRtWrapper.h"
#import "HttpRequest.h"
#import "GameEnv.h"

@interface SudAdCacheManager()
@property(nonatomic, strong)RespGameInfoModel *respGameInfo;
@property(nonatomic, strong)NSMutableDictionary *dicCacheWrapper;
@end


@implementation SudAdCacheManager
+(instancetype)shared {
    static dispatch_once_t onceToken;
    static id _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[SudAdCacheManager alloc]init];
    });
    return _instance;
}

-(NSMutableDictionary *)dicCacheWrapper {
    if (!_dicCacheWrapper) {
        _dicCacheWrapper = [[NSMutableDictionary alloc]init];
    }
    return _dicCacheWrapper;
}

- (void)loadAdCache {
    [self requestData:1];
}

- (void)reqRuntimeCode:(void(^)(RespGameInfoModel *respGameInfo))success {
    
    if (self.respGameInfo) {
        if (success) {
            success(self.respGameInfo);
        }
        return;
    }
    WeakSelf
    // 请求业务服务器刷新令牌 Code更新
    [GameService.shared reqGameLoginWithAppId:nil success:^(RespGameInfoModel *gameInfo) {
        weakSelf.respGameInfo = gameInfo;
        if (success) {
            success(weakSelf.respGameInfo);
        }
    }                                    fail:^(NSError *error) {
        

    }];
}

- (void)requestData:(NSInteger)page {
    WeakSelf
    NSString *url = [NSString stringWithFormat:@"https://hello-sud-plus.sudden.ltd/ad/config/ad_list_%@.json?%@", @(page), @(NSDate.date.timeIntervalSince1970)];
    [HttpRequest getRequestWithApi:url param:@{} success:^(NSDictionary *rootDict) {
        DDLogDebug(@"ad rootDict:%@", rootDict);
        if (![rootDict isKindOfClass:NSArray.class]) {
            return;
        }
        NSArray * jsonArray =  (NSArray *)rootDict;
        NSArray<SudAdItemModel *> *adModels = [SudAdItemModel mj_objectArrayWithKeyValuesArray:jsonArray];
        if (adModels.count <= 0) {
            return;
        }
        
        [weakSelf reqRuntimeCode:^(RespGameInfoModel *respGameInfo) {
                    
            NSInteger lastCount = 0;
            for (int i = 0; i < adModels.count; ++i) {
                SudAdItemModel *item = adModels[i];
                item.tag = [NSString stringWithFormat:@"page_%@_%@", @(page), @(i)];
                item.index = lastCount + i;
                item.code = respGameInfo.runtimeCode;
                [weakSelf cacheAd:item];
            }

        }];

    } failure:^(NSError * error) {
    }];

    
}

- (void)cacheAd:(SudAdItemModel *)model {
    
    SudRtWrapper *rt = [[SudRtWrapper alloc]init];
    rt.userId = AppService.shared.loginUserID;
    self.dicCacheWrapper[model.tag] = rt;
    WeakSelf
    SudRtGameInfo *gameInfo = [[SudRtGameInfo alloc]init];
    gameInfo.version = model.gameInfo.version;
    gameInfo.url = model.gameInfo.url;
    gameInfo.gameId = model.gameInfo.gameId;
    gameInfo.gameHash = model.gameInfo.gameHash ?: @"";
    gameInfo.gameTag = model.tag;
    gameInfo.code = model.code;
    [rt cacheGamePackage:gameInfo completion:^(NSError * _Nonnull error) {
        DDLogDebug(@"cacheAd finished:%@ gameId:%@, gameTag:%@", error, gameInfo.gameId, gameInfo.gameTag);
        [weakSelf.dicCacheWrapper removeObjectForKey:model.tag];
    }];
}
@end
