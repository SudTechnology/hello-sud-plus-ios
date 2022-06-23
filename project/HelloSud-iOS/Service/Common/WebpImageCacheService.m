//
//  WebpImageCacheService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/23.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "WebpImageCacheService.h"

/// webp格式图片缓存条目
@interface WebpImageCacheItem: NSObject
/// 缓存webp图片
@property(nonatomic, strong) UIImage *cacheWebpImage;
@property(nonatomic, assign) BOOL isLoading;
@property(nonatomic, strong) NSMutableArray<void(^)(UIImage *image)> *arrBlock;
@property(nonatomic, strong) NSString *animateURL;
@end

@implementation WebpImageCacheItem

/// 加载webp
- (void)loadWebp:(nullable void(^)(UIImage *image))result {
    if (self.cacheWebpImage && result) {
        result(self.cacheWebpImage);
        return;
    }
    if (result) {
        [self.arrBlock addObject:result];
    }
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    if (self.animateURL) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDate *date = [NSDate date];
            NSData *webpData = [NSData dataWithContentsOfFile:self.animateURL];
            NSLog(@"load data time:%@", @([[NSDate date] timeIntervalSince1970] - date.timeIntervalSince1970));
            UIImage *wimage = [[SDImageWebPCoder sharedCoder] decodedImageWithData:webpData options:nil];
            NSLog(@"decode data time:%@", @([[NSDate date] timeIntervalSince1970] - date.timeIntervalSince1970));
            self.cacheWebpImage = wimage;
            NSLog(@"load webp ok");
            self.isLoading = NO;
            [self dispatch];
        });
    }
}

- (void)dispatch {
    NSArray *arrBlock = [self.arrBlock copy];
    [self.arrBlock removeAllObjects];
    if (arrBlock.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (GiftLoadImageBlock b in arrBlock) {
                b(self.cacheWebpImage);
            }
        });
    }
}

- (NSMutableArray *)arrBlock {
    if (!_arrBlock) {
        _arrBlock = NSMutableArray.new;
    }
    return _arrBlock;
}
@end

@interface WebpImageCacheService ()
@property(nonatomic, strong) NSMutableDictionary <NSString *, WebpImageCacheItem *> *cacheMap;
@end

@implementation WebpImageCacheService

+ (instancetype)shared {
    static WebpImageCacheService *g_instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_instance = WebpImageCacheService.new;
    });
    return g_instance;
}

/// 加载webp
- (void)loadWebp:(NSString *)url result:(nullable void(^)(UIImage *image))result {
    if (url.length == 0) {
        if (result) {
            result(nil);
        }
    }
    NSString *key = url.dt_md5;
    WebpImageCacheItem *item = self.cacheMap[key];
    if (!item) {
        item = [[WebpImageCacheItem alloc]init];
        item.animateURL = url;
        self.cacheMap[key] = item;
    }
    [item loadWebp:result];
}
@end
