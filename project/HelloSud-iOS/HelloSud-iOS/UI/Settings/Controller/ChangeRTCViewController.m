//
//  ChangeRTCViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "ChangeRTCViewController.h"
#import "ChangeRTCTCell.h"
#import "ChangeRTCModel.h"

@interface ChangeRTCViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray <ChangeRTCModel *> *arrData;

@end

@implementation ChangeRTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换RTC服务商";
    [self configData];
}

/// 配置页面数据
- (void)configData {

    NSArray *arr = @[kRtcNameZego, kRtcNameAgora, kRtcNameRongCloud, kRtcNameCommEase, kRtcNameVoicEngine, kRtcNameAlibabaCloud, kRtcNameTencentCloud];
    NSDictionary *dicSupport = @{kRtcNameZego: kRtcNameZego, kRtcNameAgora: kRtcNameAgora};
    NSMutableArray <ChangeRTCModel *>* arrModel = [NSMutableArray array];
    for (NSUInteger i = 0; i < arr.count; ++i) {
        ChangeRTCModel *m = [ChangeRTCModel new];
        NSString *name = arr[i];
        m.title = name;
        m.isSlect = NO;
        /// 是否可点击
        m.isClickable = dicSupport[name] != nil ? YES : NO;

        /// 是否选中
        if (([AppService.shared.rtcType compare:@"zego" options:NSCaseInsensitiveSearch] == NSOrderedSame) ||
            ([AppService.shared.rtcType compare:@"agora" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
            m.isSlect = YES;
        }
        [arrModel addObject:m];
    }
    self.arrData = arrModel;
    [self.tableView reloadData];
}

- (void)dtAddViews {
    [super dtAddViews];
    self.view.backgroundColor = HEX_COLOR(@"#F5F6FB");
    [self.view addSubview:self.tableView];

}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 16, 0, 16));
    }];
}

#pragma makr lazy

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView registerClass:[ChangeRTCTCell class] forCellReuseIdentifier:@"ChangeRTCTCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEX_COLOR(@"#F5F6FB");
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tableView;
}

#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChangeRTCTCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangeRTCTCell *c = (ChangeRTCTCell *) cell;
    c.isShowTopLine = indexPath.row > 0;
    c.model = self.arrData[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChangeRTCModel *model = self.arrData[indexPath.row];
    if (model.isClickable == NO) {
        [ToastUtil show:@"正在制作中, 敬请期待!"];
    } else {
        if (model.isSlect == NO) {
            WeakSelf
            [DTAlertView showTextAlert:[NSString stringWithFormat:@"确认将RTC服务商切换为【%@】？", model.title] sureText:@"确定" cancelText:@"取消" onSureCallback:^{
                for (ChangeRTCModel *m in self.arrData) {
                    m.isSlect = NO;
                }
                model.isSlect = true;

                NSString *rtcType = [model.title isEqualToString:kRtcNameZego] ? @"zego" : @"agora";
                [AppService.shared switchRtcType:rtcType];
                [weakSelf.tableView reloadData];

                if (self.onRTCChangeBlock) {
                    self.onRTCChangeBlock(AppService.shared.rtcType);
                }
                [weakSelf.navigationController popViewControllerAnimated:true];
            }          onCloseCallback:^{

            }];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return UIView.new;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return UIView.new;
}

@end
