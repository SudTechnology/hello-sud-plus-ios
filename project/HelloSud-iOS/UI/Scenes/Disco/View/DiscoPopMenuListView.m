//
//  DiscoPopMenuView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/7/1.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "DiscoPopMenuListView.h"
#import "DiscoMenuTableViewCell.h"
#import "DiscoMenuModel.h"
#import "DiscoMenuRuleView.h"

@interface DiscoPopMenuListView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *bgImageView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) DTPaddingLabel *ruleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UILabel *noDataLabel;
@property(nonatomic, strong) DiscoMenuRuleView *ruleView;
@property(nonatomic, strong) NSMutableArray <NSArray<DiscoMenuModel *> *> *dataList;
@end

@implementation DiscoPopMenuListView

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.bgImageView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.ruleLabel];
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.noDataLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@405);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@31);
        make.height.equalTo(@42);
        make.leading.trailing.equalTo(@0);
    }];
    [self.ruleLabel dt_cornerRadius:8];
    [self.ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@13);
        make.trailing.equalTo(@-16);
        make.width.greaterThanOrEqualTo(@0);
        make.height.equalTo(@16);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.bottom.equalTo(@0);
    }];
    [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.greaterThanOrEqualTo(@0);
        make.centerY.equalTo(self.contentView);
    }];

}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRuleTap:)];
    [self.ruleLabel addGestureRecognizer:tap];
    WeakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:dancingListChangedNTF object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
        [weakSelf loadData];
    }];

}

- (void)dtConfigUI {
    [super dtConfigUI];
    self.backgroundColor = UIColor.whiteColor;
    [self loadData];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    self.noDataLabel.hidden = self.dataList.count > 0;
}

- (void)onRuleTap:(id)tap {
    self.contentView.hidden = YES;
    [self addSubview:self.ruleView];
    WeakSelf
    self.ruleView.closeBlock = ^{
        [weakSelf closeRuleView];
    };
    [self.ruleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(@0);
    }];
}

- (void)closeRuleView {
    if (_ruleView) {
        [_ruleView removeFromSuperview];
        _ruleView = nil;
    }
    self.contentView.hidden = NO;
}

- (void)loadData {
    NSMutableArray *normalArr = [[NSMutableArray alloc] initWithArray:kDiscoRoomService.danceMenuList];
    NSMutableArray *finishedArr = [[NSMutableArray alloc] initWithArray:kDiscoRoomService.finishedDanceMenuList];
    if (normalArr.count > 0 || finishedArr.count > 0) {
        [self.dataList setArray:@[normalArr, finishedArr]];
    }
    self.noDataLabel.hidden = self.dataList.count > 0;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    DiscoMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoMenuTableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    DiscoMenuTableViewCell *c = (DiscoMenuTableViewCell *)cell;
    DiscoMenuModel *model = self.dataList[indexPath.section][indexPath.row];
    model.rank = indexPath.row;
    c.model = model;
    DDLogDebug(@"celll willDisplayCell from user:%@, cell:%@", model.fromUser.name, c);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 36;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = UIView.new;
    if (section == 1) {
        UILabel *label = [[UILabel alloc] init];
        label.font = UIFONT_REGULAR(14);
        label.textColor = HEX_COLOR(@"#ffffff");
        label.text = NSString.dt_room_closed;
        label.hidden = self.dataList[section].count == 0;
        [v addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
            make.width.height.greaterThanOrEqualTo(@0);
            make.centerY.equalTo(v);
        }];
    }
    return v;
}

#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView registerClass:[DiscoMenuTableViewCell class] forCellReuseIdentifier:@"DiscoMenuTableViewCell"];
    }
    return _tableView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"disco_pop_menu_bg"];
    }
    return _bgImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = UIFONT_BOLD(30);
        _titleLabel.textColor = HEX_COLOR(@"#ffffff");
        _titleLabel.text = NSString.dt_room_disco_menu_name;
        _titleLabel.shadowColor = HEX_COLOR(@"#FB01E3");
        _titleLabel.shadowOffset = CGSizeMake(1, 2);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)noDataLabel {
    if (!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        _noDataLabel.font = UIFONT_REGULAR(14);
        _noDataLabel.textColor = HEX_COLOR_A(@"#ffffff", 0.4);
        _noDataLabel.text = NSString.dt_room_disco_no_menu;
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
}


- (DTPaddingLabel *)ruleLabel {
    if (!_ruleLabel) {
        _ruleLabel = [[DTPaddingLabel alloc] init];
        _ruleLabel.paddingX = 2;
        _ruleLabel.userInteractionEnabled = YES;
        _ruleLabel.backgroundColor = HEX_COLOR_A(@"#000000", 0.4);
        NSMutableAttributedString *full = [[NSMutableAttributedString alloc] initWithString:NSString.dt_room_disco_rule];
        full.yy_font = UIFONT_REGULAR(12);
        full.yy_color = HEX_COLOR(@"#ffffff");
        full.yy_firstLineHeadIndent = 3;
        full.yy_baselineOffset = @(2);

        UIImage *iconImage = [UIImage imageNamed:@"disco_rule_icon"];
        [full appendAttributedString:[NSAttributedString dt_attrWithImage:iconImage size:CGSizeMake(12, 12) offsetY:0]];
        _ruleLabel.attributedText = full;
    }
    return _ruleLabel;
}

- (DiscoMenuRuleView *)ruleView {
    if (!_ruleView) {
        _ruleView = [[DiscoMenuRuleView alloc] init];
    }
    return _ruleView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (NSMutableArray <NSArray<DiscoMenuModel *> *> *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}
@end
