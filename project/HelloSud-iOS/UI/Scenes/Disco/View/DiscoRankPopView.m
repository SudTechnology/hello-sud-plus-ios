//
//  DiscoRankPopView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/30.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoRankPopView.h"
#import "DiscoRankTableViewCell.h"
#import "DiscoRankModel.h"

@interface DiscoRankPopView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *subTitleLabel;
@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <DiscoContributionModel *> *dataList;
@end

@implementation DiscoRankPopView
- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.tipLabel];
    [self addSubview:self.tableView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.subTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.tipLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.tipLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.height.equalTo(@28);
        make.width.greaterThanOrEqualTo(@0);
        make.centerX.equalTo(self);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.leading.equalTo(@16);
        make.height.greaterThanOrEqualTo(@17);
        make.trailing.equalTo(self.tipLabel.mas_leading).offset(-2);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.centerY.equalTo(self.subTitleLabel);
        make.width.height.greaterThanOrEqualTo(@0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10);
        make.height.equalTo(@326);
    }];
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;


}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    [self loadData];
}

- (void)loadData {
    [self.dataList setArray:kDiscoRoomService.rankList];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoRankTableViewCell"];
    DiscoContributionModel *m = self.dataList[indexPath.row];
    m.rank = indexPath.row;
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.whiteColor;
        [_tableView registerClass:[DiscoRankTableViewCell class] forCellReuseIdentifier:@"DiscoRankTableViewCell"];
    }
    return _tableView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_BOLD(20);
        _titleLabel.textColor = HEX_COLOR(@"#000000");
        _titleLabel.text = NSString.dt_room_disco_rank_fee;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = UIFONT_REGULAR(12);
        _subTitleLabel.textColor = HEX_COLOR(@"#000000");
        _subTitleLabel.text = NSString.dt_room_disco_operate_tip;
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = UIFONT_REGULAR(12);
        _tipLabel.textColor = HEX_COLOR(@"#000000");
        _tipLabel.text = NSString.dt_room_disco_fee_value;
    }
    return _tipLabel;
}

- (NSMutableArray <DiscoRankModel *> *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}
@end
