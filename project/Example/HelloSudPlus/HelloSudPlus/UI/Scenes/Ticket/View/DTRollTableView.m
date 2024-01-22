//
//  DTRollTableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/3/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DTRollTableView.h"

@interface DTRollTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSTimer *scrTimer;
@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation DTRollTableView


- (void)dtAddViews {
    self.backgroundColor = UIColor.clearColor;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tickets_notice_bg"]];
    [self addSubview:self.tableView];
}

- (void)dtLayoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)reloadData {
    if (self.dataArray.count > 1) {
        NSMutableArray <NSAttributedString *> *tempArr = [NSMutableArray arrayWithArray:self.dataArray];
        [tempArr addObject:self.dataArray[0]];
        self.dataArray = [NSMutableArray arrayWithArray:tempArr];;
        [self.tableView reloadData];
        WeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
                [weakSelf configTimer];
            }
        });
    } else {
        [self.tableView reloadData];
    }
}

- (void)configTimer {
    [self.scrTimer invalidate];
    self.scrTimer = nil;
    self.scrTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(autoScroll) userInfo:nil repeats:true];
    [NSRunLoop.currentRunLoop addTimer:self.scrTimer forMode:NSRunLoopCommonModes];
}

- (void)autoScroll {
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + self.rowHeight) animated:true];
    [self resetContentOffsetIfNeeded];
}

- (void)resetContentOffsetIfNeeded {
    CGPoint contentOffset = self.tableView.contentOffset;
    if (contentOffset.y >= self.rowHeight * self.dataArray.count) {
        contentOffset.y = 0;
        WeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:false];
            }
        });
    }
}

- (void)endTimer {
    [self.scrTimer invalidate];
    self.scrTimer = nil;
}

- (void)dealloc {
    [self endTimer];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DTRollTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DTRollTableViewCell *c = (DTRollTableViewCell *)cell;
    c.attributedText = self.dataArray[indexPath.row];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = UITableView.new;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = self.rowHeight;
        [_tableView setScrollEnabled:false];
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.showsHorizontalScrollIndicator = false;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:DTRollTableViewCell.class forCellReuseIdentifier:@"DTRollTableViewCell"];
    }
    return _tableView;
}

- (CGFloat)rowHeight {
    if (!_rowHeight) {
        _rowHeight = 30;
    }
    return _rowHeight;
}

@end


@interface DTRollTableViewCell ()
@property (nonatomic, strong) YYLabel *contentLabel;

@end
@implementation DTRollTableViewCell

- (void)dtUpdateUI {
    if (self.attributedText == nil) {
        return;
    }
    self.contentLabel.attributedText = self.attributedText;
}

- (void)dtAddViews {
    self.backgroundColor = UIColor.clearColor;
    self.backgroundView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.contentLabel];
}

- (void)dtLayoutViews {
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_greaterThanOrEqualTo(CGSizeZero);
    }];
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.textColor = [UIColor dt_colorWithHexString:@"#FFE77D" alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _contentLabel.numberOfLines = 1;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.preferredMaxLayoutWidth = 300;
    }
    return _contentLabel;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    _attributedText = attributedText;
    [self dtUpdateUI];
}

@end
