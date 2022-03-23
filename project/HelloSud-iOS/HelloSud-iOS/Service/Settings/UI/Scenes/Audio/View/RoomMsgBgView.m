//
//  RoomMsgBgView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomMsgBgView.h"

@interface RoomMsgBgView()

@end

@implementation RoomMsgBgView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configGradientHeader];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.mask.frame = self.bounds;
}


- (void)configGradientHeader {
    CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
    gradient.frame = self.bounds;
    gradient.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    gradient.locations = @[@(0), @(0.1)];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    self.layer.mask = gradient;
}

@end
