//
//  HSRoomMsgTableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "HSRoomMsgTableView.h"
#import "HSBaseMsgCell.h"

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
    HSBaseMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSBaseMsgCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HSHotGameViewController *vc = [[HSHotGameViewController alloc] init];
//    HSRoomViewController *vc = [[HSRoomViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 26;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HSBaseMsgCell class] forCellReuseIdentifier:@"HSBaseMsgCell"];
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
