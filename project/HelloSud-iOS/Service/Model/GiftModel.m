//
//  GiftModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "GiftModel.h"


@interface GiftModel()
/// 缓存webp图片
@property(nonatomic, strong)UIImage *cacheWebpImage;
@property(nonatomic, assign)BOOL isLoading;
@property(nonatomic, strong)NSMutableArray<GiftLoadImageBlock> *arrBlock;
@end

@implementation GiftModel

- (NSString *)giftKey {
    return [NSString stringWithFormat:@"%@%@", @(self.type), @(self.giftID)];
}

/// 加载webp
- (void)loadWebp:(nullable GiftLoadImageBlock)result {
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
