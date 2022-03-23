//
//  TicketChooseNoticeView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "TicketChooseNoticeView.h"

@interface TicketChooseNoticeView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation TicketChooseNoticeView

- (void)dtAddViews {
    [self addSubview:self.bgImageView];
}

- (void)dtLayoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
    }
    return _bgImageView;
}
@end
