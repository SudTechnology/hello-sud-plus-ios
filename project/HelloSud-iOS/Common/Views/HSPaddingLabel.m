//
//  HSPaddingLabel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/8.
//

#import "HSPaddingLabel.h"

@implementation HSPaddingLabel

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return [self sizeThatFits:CGSizeMake(size.width, MAXFLOAT)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize changeSize = [super sizeThatFits:size];
    return CGSizeMake(changeSize.width + self.paddingX *2, changeSize.height);
}

@end
