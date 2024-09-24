//
//  RoomMsgTableView.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/21.
//

#import "RoomMsgTableView.h"
#import "Msg/BaseMsgCell.h"
#import "Msg/HSRoomTextTableViewCell.h"
#import "Msg/RoomSystemTableViewCell.h"
#import "Msg/RoomGiftTableViewCell.h"
#import "Msg/RoomAudioMsgTableViewCell.h"

@interface RoomMsgTableView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<RoomBaseCMDModel *> *msgList;
@end

@implementation RoomMsgTableView

- (void)dtAddViews {
//    AudioUserModel *user = [AudioUserModel makeUserWithUserID:@"123" name:@"nihao" icon:@"" sex:1];
//    RoomCmdSendGiftModel *giftModel = [RoomCmdSendGiftModel makeMsgWithGiftID:100 giftCount:10 toUser: user];
//    [self addMsg:[RoomCmdChatTextModel makeMsg:@"hello"]];
//    [self addMsg:giftModel];
    [self addSubview:self.tableView];
}

- (void)dtLayoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

/// 展示公屏消息
/// @param msg 消息体
- (void)addMsg:(RoomBaseCMDModel *)msg {
    [msg prepare];
    [self.msgList addObject:msg];
    [self.tableView reloadData];
    [self scrollToBottom];
}

/// 展示公屏消息
/// @param msg 消息体
- (void)addMsgList:(NSArray<RoomBaseCMDModel *> *)msgList {
    for (RoomBaseCMDModel *cmdModel in msgList) {
        [cmdModel prepare];
    }
    [self.msgList addObjectsFromArray:msgList];
    [self.tableView reloadData];
    [self scrollToBottom];
}


/// 滚动到底部
- (void)scrollToBottom {
    NSInteger s = self.tableView.numberOfSections;
    if (s < 1) {
        return;
    }
    NSInteger r = [self.tableView numberOfRowsInSection:s - 1];
    if (r < 1) {
        return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:r - 1 inSection:s - 1];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomBaseCMDModel *model = self.msgList[indexPath.row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellName];
//    cell.backgroundColor = indexPath.row % 2 ? UIColor.greenColor : UIColor.orangeColor;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.msgList[indexPath.row].cellHeight;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[BaseMsgCell class] forCellReuseIdentifier:NSStringFromClass(BaseMsgCell.class)];
        [_tableView registerClass:[HSRoomTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass(HSRoomTextTableViewCell.class)];
        [_tableView registerClass:[RoomSystemTableViewCell class] forCellReuseIdentifier:NSStringFromClass(RoomSystemTableViewCell.class)];
        [_tableView registerClass:RoomGiftTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RoomGiftTableViewCell.class)];
        [_tableView registerClass:RoomAudioMsgTableViewCell.class forCellReuseIdentifier:NSStringFromClass(RoomAudioMsgTableViewCell.class)];
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
