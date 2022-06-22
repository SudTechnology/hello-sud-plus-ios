//
//  GiftService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "GiftService.h"

@interface GiftService ()
@property(nonatomic, strong) NSDictionary<NSString *, GiftModel *> *dicGift;
@end

@implementation GiftService

+ (instancetype)shared {
    static GiftService *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = GiftService.new;
    });
    return g_manager;
}

/// 从磁盘加载礼物
- (void)loadFromDisk {

    GiftModel *giftSvga = GiftModel.new;
    giftSvga.giftID = 1;
    giftSvga.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    giftSvga.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    giftSvga.animateURL = [NSBundle.mainBundle pathForResource:@"sud_svga" ofType:@"svga" inDirectory:@"Res"];
    giftSvga.animateType = @"svga";
    giftSvga.giftName = @"svga";

    GiftModel *giftLottie = GiftModel.new;
    giftLottie.giftID = 2;
    giftLottie.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    giftLottie.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    giftLottie.animateURL = [NSBundle.mainBundle pathForResource:@"sud_lottie" ofType:@"json" inDirectory:@"Res"];
    giftLottie.animateType = @"lottie";
    giftLottie.giftName = @"lottie";

    GiftModel *giftWebp = GiftModel.new;
    giftWebp.giftID = 3;
    giftWebp.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    giftWebp.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    giftWebp.animateURL = [NSBundle.mainBundle pathForResource:@"sud_webp" ofType:@"webp" inDirectory:@"Res"];
    giftWebp.animateType = @"webp";
    giftWebp.giftName = @"webp";
    [giftWebp loadWebp:nil];

    GiftModel *giftMP4 = GiftModel.new;
    giftMP4.giftID = 4;
    giftMP4.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    giftMP4.giftURL = [NSBundle.mainBundle pathForResource:@"mp4_600" ofType:@"png" inDirectory:@"Res"];
    NSString *testResourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Res"];
    NSString *directory = [testResourcePath stringByAppendingPathComponent:@"mp4_600"];
    giftMP4.animateURL = directory;
//    giftMP4.animateURL = [NSBundle.mainBundle pathForResource:@"mp4_600" ofType:@"mp4" inDirectory:@"Res"];
    giftMP4.animateType = @"mp4";
    giftMP4.giftName = @"mp4";
    _giftList = @[giftSvga, giftLottie, giftWebp, giftMP4];
    self.dicGift = @{[NSString stringWithFormat:@"%ld", (long) giftSvga.giftID]: giftSvga,
            [NSString stringWithFormat:@"%ld", (long) giftLottie.giftID]: giftLottie,
            [NSString stringWithFormat:@"%ld", (long) giftWebp.giftID]: giftWebp,
            [NSString stringWithFormat:@"%ld", (long) giftMP4.giftID]: giftMP4,
    };

}

/// 获取礼物信息
/// @param giftID 礼物ID
- (nullable GiftModel *)giftByID:(NSInteger)giftID {
    NSString *strGiftID = [NSString stringWithFormat:@"%ld", giftID];
    return self.dicGift[strGiftID];
}

/// 拉取礼物列表
/// @param gameId gameId
/// @param sceneId sceneId
/// @param finished finished
/// @param failure failure
+ (void)reqGiftListWithGameId:(int64_t)gameId sceneId:(NSInteger)sceneId finished:(void (^)(NSArray<GiftModel *> *modelList))finished failure:(void (^)(NSError *error))failure {
    NSDictionary *dicParam = @{@"gameId": @(gameId), @"sceneId": @(sceneId)};
    [HSHttpService postRequestWithURL:kINTERACTURL(@"gift/list/v1") param:dicParam respClass:RespGiftListModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        if (finished) {
            RespGiftListModel *m = (RespGiftListModel *) resp;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (int i = 0; i < m.giftList.count; ++i) {
                RespGiftModel *item = m.giftList[i];
                GiftModel *giftModel = [[GiftModel alloc] init];
                giftModel.giftID = item.giftId;
                giftModel.animateType = item.animationUrl.dt_toURL.pathExtension;
                giftModel.type = 1;
                giftModel.price = item.giftPrice;
                giftModel.giftURL = item.giftUrl;
                giftModel.smallGiftURL = item.smallGiftUrl;
                giftModel.animateURL = item.animationUrl;
                giftModel.giftName = item.name;
                [arr addObject:giftModel];
            }
            finished(arr);
        }
    }                         failure:failure];
}
@end
