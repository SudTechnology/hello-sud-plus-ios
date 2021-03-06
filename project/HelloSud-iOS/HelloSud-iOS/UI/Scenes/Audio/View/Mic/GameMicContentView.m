//
//  GameMicContentView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "GameMicContentView.h"

@interface GameMicContentView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contenView;

@end

@implementation GameMicContentView

- (void)dtAddViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.contenView];
}

- (void)dtConfigUI {
    for (UIView * v in self.contenView.subviews) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < 9; i++) {
        AudioMicroView *micNode = [[AudioMicroView alloc] init];
        micNode.headWidth = 32;
        WeakSelf
        micNode.onTapCallback = ^(AudioRoomMicModel * _Nonnull micModel) {
            if (weakSelf.onTapCallback) weakSelf.onTapCallback(micModel);
        };
        AudioRoomMicModel *m = AudioRoomMicModel.new;
        m.micIndex = i;
        micNode.model = m;
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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
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
