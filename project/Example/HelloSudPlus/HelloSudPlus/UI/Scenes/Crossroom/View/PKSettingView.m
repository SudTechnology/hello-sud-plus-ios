//
//  PKSettingView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "PKSettingView.h"
#import "GameConfigPopCell.h"

@interface PKSettingView ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSArray *timeArray;
@property(nonatomic, strong) NSMutableArray<RoomCustomOptionList *> *dataArray;
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MarqueeLabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *startPkBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, assign) PKSettingType pKSettingType;

@end

@implementation PKSettingView

- (instancetype)initWithPKSettingType:(PKSettingType)pKSettingType
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.pKSettingType = pKSettingType;
        [self setupBottomNode];
    }
    return self;
}

- (void)dtAddViews {
    [super dtAddViews];
    self.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self addSubview:self.tableView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeBtn];
    [self addSubview:self.startPkBtn];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.editBtn];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    // 抗压缩
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.closeBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    // 抗拉伸
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.closeBtn setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(22);
        make.height.mas_greaterThanOrEqualTo(0);
        make.trailing.equalTo(self.closeBtn.mas_leading).offset(-5);
    }];
    [self.closeBtn dt_cornerRadius:15];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(19);
        make.height.mas_equalTo(30);
        make.width.greaterThanOrEqualTo(@0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(68, 16, kAppSafeBottom + 60, 16));
        make.height.mas_equalTo(56 * 4);
    }];
    [self.startPkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(12);
        make.height.mas_equalTo(44);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(12);
        make.height.mas_equalTo(44);
    }];
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.cancelBtn.mas_trailing).offset(19);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(12);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(self.cancelBtn.mas_width);
    }];
}

- (void)dtConfigEvents {
    RoomCustomOptionList *item_0 = RoomCustomOptionList.new;
    item_0.isSeleted = true;
    item_0.title = [NSString stringWithFormat:NSString.dt_room_minutes, (NSNumber *)self.timeArray[0]];
    
    RoomCustomOptionList *item_1 = RoomCustomOptionList.new;
    item_1.isSeleted = false;
    item_1.title = [NSString stringWithFormat:NSString.dt_room_minutes, (NSNumber *)self.timeArray[1]];
    
    RoomCustomOptionList *item_2 = RoomCustomOptionList.new;
    item_2.isSeleted = false;
    item_2.title = [NSString stringWithFormat:NSString.dt_room_minutes, (NSNumber *)self.timeArray[2]];
    
    RoomCustomOptionList *item_3 = RoomCustomOptionList.new;
    item_3.isSeleted = false;
    item_3.title = [NSString stringWithFormat:NSString.dt_room_minutes, (NSNumber *)self.timeArray[3]];
    
    [self.dataArray addObjectsFromArray:@[item_0, item_1, item_2, item_3]];
    [self.tableView reloadData];
}

- (void)setupBottomNode {
    switch (self.pKSettingType) {
        case PKSettingTypePKBefore:
            [self.startPkBtn setHidden:false];
            [self.cancelBtn setHidden:true];
            [self.editBtn setHidden:true];
            break;
        case PKSettingTypePKAfter:
            [self.startPkBtn setHidden:true];
            [self.cancelBtn setHidden:false];
            [self.editBtn setHidden:false];
            break;
    }
}

- (NSNumber *)getCurTime {
    for (int i = 0; i < self.dataArray.count; i++) {
        if (self.dataArray[i].isSeleted) {
            return (NSNumber *)self.timeArray[i];
        }
    }
    return (NSNumber *)self.timeArray[0];
}

#pragma mark - Event
- (void)closeBtnEvent {
    if (self.settingNodesEventBlock) {
        self.settingNodesEventBlock(PKSettingBtnEventTypeClosePK, (NSNumber *)[self getCurTime]);
    }
}

- (void)startPkBtnEvent {
    if (self.settingNodesEventBlock) {
        self.settingNodesEventBlock(PKSettingBtnEventTypeStartPK, (NSNumber *)[self getCurTime]);
    }
}

- (void)editBtnEvent {
    if (self.settingNodesEventBlock) {
        self.settingNodesEventBlock(PKSettingBtnEventTypeEditPK, (NSNumber *)[self getCurTime]);
    }
}

- (void)cancelBtnEvent {
    [DTSheetView close];
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameConfigPopCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    GameConfigPopCell *c = (GameConfigPopCell *)cell;
    c.hiddenLine = self.dataArray.count - 1 == indexPath.row;
    c.model = self.dataArray[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (RoomCustomOptionList *item in self.dataArray) {
        item.isSeleted = false;
    }
    self.dataArray[indexPath.row].isSeleted = true;
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

#pragma makr lazy
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[GameConfigPopCell class] forCellReuseIdentifier:@"GameConfigPopCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#FFFFFF");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = false;
    }
    return _tableView;
}

- (NSArray *)timeArray {
    if (!_timeArray) {
        _timeArray = @[@(5), @(15), @(30), @(60)];
    }
    return _timeArray;
}

- (NSMutableArray<RoomCustomOptionList *> *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.new;
    }
    return _dataArray;
}

- (MarqueeLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[MarqueeLabel alloc] init];
        _titleLabel.font = UIFONT_MEDIUM(18);
        _titleLabel.textColor = [UIColor dt_colorWithHexString:@"#1A1A1A" alpha:1];
        _titleLabel.text = NSString.dt_room_pk_duration_set;
        _titleLabel.trailingBuffer = 10;
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setTitle:NSString.dt_room_close_cross_room forState:normal];
        _closeBtn.backgroundColor = UIColor.whiteColor;
        _closeBtn.titleLabel.font = UIFONT_MEDIUM(12);
        [_closeBtn setTitleColor:UIColor.blackColor forState:normal];
        [_closeBtn addTarget:self action:@selector(closeBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12);
    }
    return _closeBtn;
}

- (UIButton *)startPkBtn {
    if (!_startPkBtn) {
        _startPkBtn = [[UIButton alloc] init];
        [_startPkBtn setHidden:true];
        [_startPkBtn setTitle:NSString.dt_room_start_pk forState:normal];
        _startPkBtn.backgroundColor = UIColor.blackColor;
        _startPkBtn.titleLabel.font = UIFONT_BOLD(14);
        [_startPkBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_startPkBtn addTarget:self action:@selector(startPkBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startPkBtn;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setHidden:true];
        [_editBtn setTitle:NSString.dt_room_confirm_modification forState:normal];
        _editBtn.backgroundColor = UIColor.blackColor;
        _editBtn.titleLabel.font = UIFONT_BOLD(14);
        [_editBtn setTitleColor:UIColor.whiteColor forState:normal];
        [_editBtn addTarget:self action:@selector(editBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setHidden:true];
        [_cancelBtn setTitle:NSString.dt_common_cancel forState:normal];
        _cancelBtn.backgroundColor = UIColor.whiteColor;
        _cancelBtn.titleLabel.font = UIFONT_BOLD(14);
        [_cancelBtn setTitleColor:UIColor.blackColor forState:normal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
