//
//  HSRoomMsgTableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomMsgTableView.h"
#import "HSBaseMsgCell.h"
#import "HSRoomTextTableViewCell.h"
#import "HSRoomSystemTableViewCell.h"
#import "HSRoomGiftTableViewCell.h"

@interface HSRoomMsgTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *msgList;
@end

@implementation HSRoomMsgTableView

- (void)hsAddViews {
    self.msgList = @[@(1), @(1), @(1)];
    [self addSubview:self.tableView];
}

- (void)hsLayoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HSRoomTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSRoomTextTableViewCell"];
        cell.model = [BaseModel new];
        return cell;
    } else if (indexPath.row == 1) {
        HSRoomSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSRoomSystemTableViewCell"];
        cell.model = [BaseModel new];
        return cell;
    } else {
        HSRoomGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSRoomGiftTableViewCell"];
        cell.model = [BaseModel new];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HSHotGameViewController *vc = [[HSHotGameViewController alloc] init];
//    HSAudioRoomViewController *vc = [[HSAudioRoomViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 26;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        [_tableView registerClass:[HSBaseMsgCell class] forCellReuseIdentifier:@"HSBaseMsgCell"];
        [_tableView registerClass:[HSRoomTextTableViewCell class] forCellReuseIdentifier:@"HSRoomTextTableViewCell"];
        [_tableView registerClass:[HSRoomSystemTableViewCell class] forCellReuseIdentifier:@"HSRoomSystemTableViewCell"];
        [_tableView registerClass:[HSRoomGiftTableViewCell class] forCellReuseIdentifier:@"HSRoomGiftTableViewCell"];
    }
    return _tableView;
}

- (NSMutableArray *)msgList {
    if (!_msgList) {
        _msgList = [NSMutableArray array];
    }
    return _msgList;
}
@end
