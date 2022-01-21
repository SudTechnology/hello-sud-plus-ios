//
//  HSRoomMsgBgView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomMsgBgView.h"

@implementation HSRoomMsgBgView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
//    [self configGradientHeader];
}

- (void)configGradientHeader {
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.frame = self.bounds;
    gradient.colors = @[[UIColor clearColor], [UIColor whiteColor]];
    gradient.locations = @[@(0), @(1)];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    self.layer.mask = gradient;
}

@end
