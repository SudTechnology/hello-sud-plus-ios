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
@property (nonatomic, strong) NSMutableArray<HSAudioMsgBaseModel*> *msgList;
@end

@implementation HSRoomMsgTableView

- (void)hsAddViews {
    HSAudioUserModel *user = [HSAudioUserModel makeUserWithUserID:@"123" name:@"nihao" icon:@"" sex:1];
    HSAudioMsgGiftModel *giftModel = [HSAudioMsgGiftModel makeMsgWithGiftID:100 giftCount:10 toUser: user];
    [self.msgList setArray: @[[HSAudioMsgTextModel makeMsg:@"hello"], giftModel]];
    [self addSubview:self.tableView];
}

- (void)hsLayoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

/// 展示公屏消息
/// @param msg 消息体
- (void)addMsg:(HSAudioMsgBaseModel *)msg {
    [self.msgList addObject:msg];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate || UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSAudioMsgBaseModel *model = self.msgList[indexPath.row];
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellName];
    cell.model = model;
    return cell;
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
        
        [_tableView registerClass:[HSBaseMsgCell class] forCellReuseIdentifier:NSStringFromClass(HSBaseMsgCell.class)];
        [_tableView registerClass:[HSRoomTextTableViewCell class] forCellReuseIdentifier:NSStringFromClass(HSRoomTextTableViewCell.class)];
        [_tableView registerClass:[HSRoomSystemTableViewCell class] forCellReuseIdentifier:NSStringFromClass(HSRoomSystemTableViewCell.class)];
        [_tableView registerClass:HSRoomGiftTableViewCell.class forCellReuseIdentifier:NSStringFromClass(HSRoomGiftTableViewCell.class)];
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
