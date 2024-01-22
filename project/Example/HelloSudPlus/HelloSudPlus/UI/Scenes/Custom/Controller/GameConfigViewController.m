//
//  GameConfigViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GameConfigViewController.h"
#import "GameConfigTableViewCell.h"
#import "RoomCustomModel.h"
#import "GameConfigPopView.h"
#import "GameCfgModel.h"

@interface GameConfigViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)MarqueeLabel *tipLabel;
@property(nonatomic, strong)NSMutableArray <RoomCustomList *>*dataArray;
@property(nonatomic, strong)RoomCustomModel *customModel;
@end

@implementation GameConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSString.dt_room_game_config;
    
    self.customModel = [AudioRoomService getCustomModel];
    self.dataArray = [NSMutableArray arrayWithArray:self.customModel.customList];
    [self.tableView reloadData];
}
- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tipLabel];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8+40, 16, 0, 16));
    }];
}

#pragma makr lazy
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[GameConfigTableViewCell class] forCellReuseIdentifier:@"GameConfigTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

- (MarqueeLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[MarqueeLabel alloc] init];
        _tipLabel.text = NSString.dt_room_exit_room_reload;
        _tipLabel.textColor = [UIColor dt_colorWithHexString:@"#ED9F20" alpha:1];
        _tipLabel.font = UIFONT_REGULAR(14);
        _tipLabel.backgroundColor = [UIColor dt_colorWithHexString:@"#FFEFDB" alpha:1];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.trailingBuffer = 16;
        _tipLabel.leadingBuffer = 16;
    }
    return _tipLabel;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = NSMutableArray.new;
    }
    return _dataArray;
}

#pragma mark UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameConfigTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    GameConfigTableViewCell *c = (GameConfigTableViewCell *)cell;
    RoomCustomItems *m = self.dataArray[indexPath.section].items[indexPath.row];
    c.model = m;
    c.isShowLine = indexPath.row != self.dataArray[indexPath.section].items.count - 1;
    WeakSelf
    c.sliderVolumeBlock = ^(int64_t value) {
        m.value = value;
        [SettingsService setRoomCustomModel:weakSelf.customModel];
    };
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RoomCustomItems *model = self.dataArray[indexPath.section].items[indexPath.row];
    if ([model isVolumeItem]) {
        return;
    }
    WeakSelf
    GameConfigPopView *popView = GameConfigPopView.new;
    popView.dataArray = model.optionList;
    popView.selectedIdxBlock = ^(int64_t idx) {
        for (RoomCustomOptionList *item in model.optionList) {
            item.isSeleted = NO;
        }
        model.optionList[idx].isSeleted = YES;
        model.value = idx;
        [weakSelf.tableView reloadData];
        [SettingsService setRoomCustomModel:weakSelf.customModel];
        [DTSheetView close];
    };
    [DTSheetView show:popView onCloseCallback:^{}];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *titleLabel = UILabel.new;
    titleLabel.text = self.dataArray[section].name.localized;
    titleLabel.textColor = [UIColor dt_colorWithHexString:@"#000000" alpha:1];
    titleLabel.font = UIFONT_MEDIUM(14);
    titleLabel.frame = CGRectMake(0, 0, kScreenWidth-32, 44);
    return titleLabel;
}


@end
