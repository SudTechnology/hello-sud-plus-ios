//
//  HSGameListHeaderView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/20.
//

#import "HSGameListHeaderView.h"
#import "HSRoomTypeHeaderView.h"
#import "HSHotGamesHeaderView.h"

@interface HSGameListHeaderView ()
@property (nonatomic, strong) HSRoomTypeHeaderView *typeNode;
@property (nonatomic, strong) HSHotGamesHeaderView *hotNode;
@end

@implementation HSGameListHeaderView

- (void)hsAddViews {
    [self addSubview:self.typeNode];
    [self addSubview:self.hotNode];
}

- (void)hsLayoutViews {
    [self.typeNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(256);
    }];
    [self.hotNode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeNode.mas_bottom);
        make.left.bottom.right.mas_equalTo(self);
    }];
}

- (HSRoomTypeHeaderView *)typeNode {
    if (!_typeNode) {
        _typeNode = [[HSRoomTypeHeaderView alloc] init];
    }
    return _typeNode;
}

- (HSHotGamesHeaderView *)hotNode {
    if (!_hotNode) {
        _hotNode = [[HSHotGamesHeaderView alloc] init];
    }
    return _hotNode;
}

@end
