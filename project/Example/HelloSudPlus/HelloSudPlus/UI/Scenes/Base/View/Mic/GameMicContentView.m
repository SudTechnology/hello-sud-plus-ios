//
//  GameMicContentView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "GameMicContentView.h"

@interface GameMicContentView ()
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *contenView;
/// 右边位置缩小视图
@property(nonatomic, strong) UIImageView *rightScaleIconImageView;
/// 左边位置缩小视图
@property(nonatomic, strong) UIImageView *leftScaleIconImageView;
@end

@implementation GameMicContentView

- (void)dtAddViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.contenView];
    [self addSubview:self.rightScaleIconImageView];
    [self addSubview:self.leftScaleIconImageView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftScaleIconImageView.mas_trailing);
        make.trailing.equalTo(@0);
        make.top.bottom.equalTo(@0);
    }];
    [self.rightScaleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(@0);
        make.width.equalTo(@30);
        make.height.equalTo(@24);
    }];
    [self.leftScaleIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.centerY.equalTo(self);
        make.width.equalTo(@0);
        make.height.equalTo(@12);
    }];

}

- (void)dtConfigUI {
    for (UIView *v in self.contenView.subviews) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < 9; i++) {
        AudioMicroView *micNode = [[AudioMicroView alloc] init];
        micNode.headWidth = 32;
        WeakSelf
        micNode.onTapCallback = ^(AudioRoomMicModel *_Nonnull micModel) {
            if (weakSelf.onTapCallback) weakSelf.onTapCallback(micModel);
        };
        NSString *key = [NSString stringWithFormat:@"%@", @(i)];
        micNode.model = kAudioRoomService.currentRoomVC.dicMicModel[key];
        micNode.micType = HSGameMic;
        [self.contenView addSubview:micNode];
        [self.micArr addObject:micNode];
    }
    [self.contenView.subviews dt_mas_distributeSudokuViewsWithFixedItemWidth:32 fixedItemHeight:55
                                                            fixedLineSpacing:16 fixedInteritemSpacing:16
                                                                   warpCount:9
                                                                  topSpacing:0
                                                               bottomSpacing:0 leadSpacing:16 tailSpacing:16];
    if (self.updateMicArrCallBack) {
        self.updateMicArrCallBack(self.micArr);
    }
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapRightScaleToSmallView:)];
    [self.rightScaleIconImageView addGestureRecognizer:tap];

    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapLeftScaleToBigView:)];
    [self.leftScaleIconImageView addGestureRecognizer:tap2];
}

/// 缩放麦位
- (void)switchToSmallView {
    [self onTapRightScaleToSmallView:nil];
}

- (void)onTapLeftScaleToBigView:(id)tap {
    // 切换到大图模式
    if (self.changeScaleBlock) {
        self.changeScaleBlock(NO);
    }
}

- (void)scaleToBigView {
    // 切换到大图模式
    [self dtRemoveRoundCorners];
    self.leftScaleIconImageView.hidden = YES;
    self.backgroundColor = nil;
    [self.leftScaleIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.width.equalTo(@0);
    }];
    NSArray *arrViews = self.contenView.subviews;
    for (int i = 0; i < arrViews.count; ++i) {
        UIView *v = arrViews[i];
        if ([v isKindOfClass:AudioMicroView.class]) {
            AudioMicroView *micView = (AudioMicroView *)v;
            micView.headWidth = 32;
            [micView changeScale:NO];
        }
    }
    self.contenView.frame = CGRectMake(0, 0, 16 + 48 * 9, 55);
    [self.scrollView setContentSize:CGSizeMake(16 + 48 * 9, 0)];
    [self.contenView.subviews dt_mas_distributeSudokuViewsWithFixedItemWidth:32 fixedItemHeight:55
                                                            fixedLineSpacing:16 fixedInteritemSpacing:16
                                                                   warpCount:9
                                                                  topSpacing:0
                                                               bottomSpacing:0 leadSpacing:16 tailSpacing:16];
}

- (void)scaleToSmallView {
    // 切换到小图模式
    self.rightScaleIconImageView.hidden = YES;
    self.leftScaleIconImageView.hidden = NO;
    [self.leftScaleIconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5);
        make.width.equalTo(@12);
    }];
    NSArray *arrViews = self.contenView.subviews;
    CGFloat headHeight = 12;
    for (int i = 0; i < arrViews.count; ++i) {
        UIView *v = arrViews[i];
        if ([v isKindOfClass:AudioMicroView.class]) {
            AudioMicroView *micView = (AudioMicroView *)v;
            micView.headWidth = headHeight;
            [micView changeScale:YES];
        }
    }
    self.contenView.frame = CGRectMake(0, 6, 16 + headHeight * 9, headHeight);
    [self.scrollView setContentSize:CGSizeMake(16 + headHeight * 9, 0)];
    [self.contenView.subviews dt_mas_distributeSudokuViewsWithFixedItemWidth:headHeight fixedItemHeight:headHeight
                                                            fixedLineSpacing:4 fixedInteritemSpacing:4
                                                                   warpCount:9
                                                                  topSpacing:0
                                                               bottomSpacing:0 leadSpacing:4 tailSpacing:4];
}

- (void)showSmallState {

    self.backgroundColor = HEX_COLOR_A(@"#000000", 0.6);
    [self setPartRoundCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadius:12];
    [self setNeedsLayout];
    
}

- (void)showBigState {
    self.rightScaleIconImageView.hidden = NO;
}

- (void)onTapRightScaleToSmallView:(id)tap {
    // 切换到小图模式
    if (self.changeScaleBlock) {
        self.changeScaleBlock(YES);
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setShowsHorizontalScrollIndicator:false];
        [_scrollView setShowsVerticalScrollIndicator:false];
        [_scrollView setContentSize:CGSizeMake(16 + 48 * 9, 0)];
        _scrollView.clipsToBounds = false;
    }
    return _scrollView;
}

- (UIView *)contenView {
    if (!_contenView) {
        _contenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16 + 48 * 9, 55)];
        _contenView.clipsToBounds = false;
    }
    return _contenView;
}

- (UIImageView *)rightScaleIconImageView {
    if (!_rightScaleIconImageView) {
        _rightScaleIconImageView = [[UIImageView alloc] init];
        _rightScaleIconImageView.image = [UIImage imageNamed:@"room_mic_scale"];
        _rightScaleIconImageView.userInteractionEnabled = YES;
    }
    return _rightScaleIconImageView;
}

- (UIImageView *)leftScaleIconImageView {
    if (!_leftScaleIconImageView) {
        _leftScaleIconImageView = [[UIImageView alloc] init];
        _leftScaleIconImageView.image = [UIImage imageNamed:@"room_navi_back_white"];
        _leftScaleIconImageView.userInteractionEnabled = YES;
        _leftScaleIconImageView.hidden = YES;
    }
    return _leftScaleIconImageView;
}

- (NSMutableArray *)micArr {
    if (_micArr == nil) {
        _micArr = NSMutableArray.new;
    }
    return _micArr;
}

- (void)setISudFSMMG:(SudFSMMGDecorator *)iSudFSMMG {
    _iSudFSMMG = iSudFSMMG;
    for (AudioMicroView *v in self.micArr) {
        v.iSudFSMMG = iSudFSMMG;
    }
}

@end
