//
//  GuessRankHeaderView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/9.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessRankHeaderView.h"
#import "RankHeadItemView.h"
#import "RankNumItemView.h"

@interface GuessRankHeaderView ()
@property(nonatomic, strong) RankHeadItemView *rankFirstView;
@property(nonatomic, strong) RankHeadItemView *rankSecondView;
@property(nonatomic, strong) RankHeadItemView *rankThirdView;

@property(nonatomic, strong) RankNumItemView *numFirstView;
@property(nonatomic, strong) RankNumItemView *numSecondView;
@property(nonatomic, strong) RankNumItemView *numThirdView;

@property(nonatomic, strong) BaseView *bottomView;

@end

@implementation GuessRankHeaderView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.rankFirstView];
    [self addSubview:self.rankSecondView];
    [self addSubview:self.rankThirdView];

    [self addSubview:self.numSecondView];
    [self addSubview:self.numThirdView];
    [self addSubview:self.numFirstView];
    [self addSubview:self.bottomView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.rankFirstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@6);
        make.width.equalTo(@80);
        make.height.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self);
    }];
    [self.rankSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankFirstView).offset(25);
        make.width.equalTo(@72);
        make.height.greaterThanOrEqualTo(@0);
        make.leading.equalTo(self.numSecondView).offset(21);
    }];
    [self.rankThirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankFirstView).offset(25);
        make.width.equalTo(@72);
        make.height.greaterThanOrEqualTo(@0);
        make.trailing.equalTo(self.numThirdView).offset(-21);
    }];

    [self.numFirstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankFirstView.mas_bottom).offset(14);
        make.width.equalTo(@136);
        make.height.equalTo(@70);
        make.centerX.equalTo(self.rankFirstView);
    }];
    [self.numSecondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numFirstView).offset(20);
        make.width.equalTo(@136);
        make.height.equalTo(@50);
        make.leading.equalTo(@19);
    }];
    [self.numThirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numFirstView).offset(20);
        make.width.equalTo(@136);
        make.height.equalTo(@50);
        make.trailing.equalTo(@-20);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@22);
        make.bottom.equalTo(@0);
    }];
}

- (void)dtConfigUI {
    [super dtConfigUI];

}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.rankFirstView.model = self.firstModel;
    self.rankSecondView.model = self.secondModel;
    self.rankThirdView.model = self.thirdModel;
    self.numFirstView.count = self.firstModel.count;
    self.numSecondView.count = self.secondModel.count;
    self.numThirdView.count = self.thirdModel.count;
    self.numFirstView.tip = self.firstModel.tip;
    self.numSecondView.tip = self.secondModel.tip;
    self.numThirdView.tip = self.thirdModel.tip;


    [self.rankFirstView dtUpdateUI];
    [self.rankSecondView dtUpdateUI];
    [self.rankThirdView dtUpdateUI];
    [self.numFirstView dtUpdateUI];
    [self.numSecondView dtUpdateUI];
    [self.numThirdView dtUpdateUI];
}

- (RankHeadItemView *)rankFirstView {
    if (!_rankFirstView) {
        _rankFirstView = [[RankHeadItemView alloc] init];
    }
    return _rankFirstView;
}

- (RankHeadItemView *)rankSecondView {
    if (!_rankSecondView) {
        _rankSecondView = [[RankHeadItemView alloc] init];
    }
    return _rankSecondView;
}

- (RankHeadItemView *)rankThirdView {
    if (!_rankThirdView) {
        _rankThirdView = [[RankHeadItemView alloc] init];
    }
    return _rankThirdView;
}

- (RankNumItemView *)numFirstView {
    if (!_numFirstView) {
        _numFirstView = [[RankNumItemView alloc] init];
        _numFirstView.rank = 1;
        _numFirstView.count = 8883;
    }
    return _numFirstView;
}

- (RankNumItemView *)numSecondView {
    if (!_numSecondView) {
        _numSecondView = [[RankNumItemView alloc] init];
        _numSecondView.rank = 2;
        _numSecondView.count = 8883;
        _numSecondView.alpha = 0.85;
    }
    return _numSecondView;
}

- (RankNumItemView *)numThirdView {
    if (!_numThirdView) {
        _numThirdView = [[RankNumItemView alloc] init];
        _numThirdView.rank = 3;
        _numThirdView.count = 8883;
        _numThirdView.alpha = 0.85;
    }
    return _numThirdView;
}

- (BaseView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[BaseView alloc] init];
        _bottomView.backgroundColor = UIColor.whiteColor;
        [_bottomView setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:20];
    }
    return _bottomView;
}

@end
