//
//  GiftService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "GiftService.h"

@interface GiftService ()
@property(nonatomic, strong) NSMutableDictionary<NSString *, GiftModel *> *dicGift;
@property(nonatomic, strong) NSArray<GiftModel *> *discoGiftList;
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSArray<GiftModel *> *> *cacheMap;
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
    giftSvga.price = 100;

    GiftModel *giftLottie = GiftModel.new;
    giftLottie.giftID = 2;
    giftLottie.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    giftLottie.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    giftLottie.animateURL = [NSBundle.mainBundle pathForResource:@"sud_lottie" ofType:@"json" inDirectory:@"Res"];
    giftLottie.animateType = @"lottie";
    giftLottie.giftName = @"lottie";
    giftLottie.price = 1;
    giftLottie.tagList = @[NSString.dt_room_disco_tag_special];

    GiftModel *giftWebp = GiftModel.new;
    giftWebp.giftID = 3;
    giftWebp.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    giftWebp.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    giftWebp.animateURL = [NSBundle.mainBundle pathForResource:@"sud_webp" ofType:@"webp" inDirectory:@"Res"];
    giftWebp.animateType = @"webp";
    giftWebp.giftName = @"webp";
    giftWebp.price = 10;
    giftWebp.tagList = @[NSString.dt_room_disco_tag_special];
    [giftWebp loadWebp:nil];

    GiftModel *giftMP4 = GiftModel.new;
    giftMP4.giftID = 4;
    giftMP4.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    giftMP4.giftURL = [NSBundle.mainBundle pathForResource:@"mp4_600" ofType:@"png" inDirectory:@"Res"];
    NSString *testResourcePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Res"];
    NSString *directory = [testResourcePath stringByAppendingPathComponent:@"mp4_600"];
    giftMP4.animateURL = directory;
    giftMP4.animateType = @"mp4";
    giftMP4.giftName = @"mp4";
    giftMP4.price = 50;
    giftMP4.tagList = @[NSString.dt_room_disco_tag_special, NSString.dt_room_disco_tag_effect];



    /// disco
    GiftModel *gift1 = GiftModel.new;
    gift1.giftID = 5;
    gift1.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    gift1.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    gift1.animateURL = [NSBundle.mainBundle pathForResource:@"sud_svga" ofType:@"svga" inDirectory:@"Res"];
    gift1.animateType = @"svga";
    gift1.giftName = [NSString stringWithFormat:NSString.dt_room_disco_dancing_minute_fmt, @"一"];
    gift1.price = 50;

    GiftModel *gift2 = GiftModel.new;
    gift2.giftID = 6;
    gift2.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    gift2.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    gift2.animateURL = [NSBundle.mainBundle pathForResource:@"sud_svga" ofType:@"svga" inDirectory:@"Res"];
    gift2.animateType = @"svga";
    gift2.giftName = [NSString stringWithFormat:NSString.dt_room_disco_dancing_minute_fmt, @"三"];
    gift2.price = 150;

    GiftModel *gift3 = GiftModel.new;
    gift3.giftID = 7;
    gift3.smallGiftURL = [NSBundle.mainBundle pathForResource:@"sud_128" ofType:@"png" inDirectory:@"Res"];
    gift3.giftURL = [NSBundle.mainBundle pathForResource:@"sud_600" ofType:@"png" inDirectory:@"Res"];
    gift3.animateURL = [NSBundle.mainBundle pathForResource:@"sud_svga" ofType:@"svga" inDirectory:@"Res"];
    gift3.animateType = @"svga";
    gift3.giftName = NSString.dt_room_disco_dance_insert;
    gift3.price = 1500;

    GiftModel *gift9 = GiftModel.new;
    gift9.giftID = 9;
    gift9.smallGiftURL = [NSBundle.mainBundle pathForResource:@"gift_rocket" ofType:@"png" inDirectory:@"Res"];
    gift9.giftURL = [NSBundle.mainBundle pathForResource:@"gift_rocket" ofType:@"png" inDirectory:@"Res"];
    gift9.animateURL = [NSBundle.mainBundle pathForResource:@"sud_svga" ofType:@"svga" inDirectory:@"Res"];
    NSString *localRocketImage = [self getRocketImagePath];
    // 本地缓存火箭截图
    if (localRocketImage.length != 0) {
        gift9.smallGiftURL = localRocketImage;
        gift9.giftURL = localRocketImage;
    }
    gift9.animateType = @"svga";
    gift9.giftName = @"定制火箭";
    gift9.leftTagImage = @"gift_rocket_flag_bg";
    gift9.leftTagName = @"定制";
    gift9.price = 19888;


    _giftList = @[giftLottie, giftWebp, giftMP4, giftSvga,gift9];
    [self.dicGift setDictionary:@{[NSString stringWithFormat:@"%ld", (long) giftSvga.giftID]: giftSvga,
            [NSString stringWithFormat:@"%ld", (long) giftLottie.giftID]: giftLottie,
            [NSString stringWithFormat:@"%ld", (long) giftWebp.giftID]: giftWebp,
            [NSString stringWithFormat:@"%ld", (long) giftMP4.giftID]: giftMP4,
    }];

    self.dicGift[[NSString stringWithFormat:@"%@", @(gift1.giftID)]] = gift1;
    self.dicGift[[NSString stringWithFormat:@"%@", @(gift2.giftID)]] = gift2;
    self.dicGift[[NSString stringWithFormat:@"%@", @(gift3.giftID)]] = gift3;
    self.dicGift[[NSString stringWithFormat:@"%@", @(gift9.giftID)]] = gift9;
    self.discoGiftList = @[gift1, gift2, gift3];

}

- (NSMutableDictionary<NSString *, GiftModel *> *)dicGift {
    if (!_dicGift) {
        _dicGift = [[NSMutableDictionary alloc] init];
    }
    return _dicGift;
}

- (NSMutableDictionary<NSString *, NSArray<GiftModel *> *> *)cacheMap {
    if (!_cacheMap) {
        _cacheMap = NSMutableDictionary.new;
    }
    return _cacheMap;
}

/// 获取礼物信息
/// @param giftID 礼物ID
- (nullable GiftModel *)giftByID:(NSInteger)giftID {
    NSString *strGiftID = [NSString stringWithFormat:@"%ld", giftID];
    return self.dicGift[strGiftID];
}

/// 默认火箭图片名称
- (NSString *)defaultRocketImagePath {
    return [NSString stringWithFormat:@"%@/Documents/rocket_shortcut.png", NSHomeDirectory()];
}

/// 保存火箭数据
/// @param base64Str
- (NSString *)saveRocketImage:(NSString *)base64Str {
    if (base64Str.length == 0) {
        return nil;
    }
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64Str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *filePath = [self defaultRocketImagePath];
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        [NSFileManager.defaultManager removeItemAtPath:filePath error:nil];
    }
    if ([imageData writeToFile:filePath atomically:YES]) {
        return filePath;
    }
    return nil;
}

/// 获取火箭图片,不存在则返回nil
- (NSString *_Nullable)getRocketImagePath {
    NSString *filePath = [self defaultRocketImagePath];
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        return filePath;
    }
    return nil;
}

/// 拉取礼物列表
/// @param gameId gameId
/// @param sceneId sceneId
/// @param finished finished
/// @param failure failure
+ (void)reqGiftListWithGameId:(int64_t)gameId sceneId:(NSInteger)sceneId finished:(void (^)(NSArray<GiftModel *> *modelList))finished failure:(void (^)(NSError *error))failure {
    if (sceneId == SceneTypeDisco) {
        if (finished) finished(GiftService.shared.discoGiftList);
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@", @(sceneId), @(gameId)];
    NSArray<GiftModel *> *cacheArr = GiftService.shared.cacheMap[key];
    if (cacheArr.count > 0) {
        if (finished) finished(cacheArr);
        return;
    }
    
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
                giftModel.details = item.details;
                [arr addObject:giftModel];
            }
            GiftService.shared.cacheMap[key] = arr;
            finished(arr);
        }
    }                         failure:failure];
}
@end
