//
//  ChangeRTCViewController.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/2/15.
//

#import "ChangeRTCViewController.h"
#import "ChangeRTCTCell.h"
#import "ChangeRTCModel.h"

@interface ChangeRTCViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray <ChangeRTCModel *>*arrData;

@end

@implementation ChangeRTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"切换RTC服务商";
    [self configData];
}

/// 配置页面数据
- (void)configData {
    ChangeRTCModel *m0 = [ChangeRTCModel new];
    m0.title = @"即构";
    m0.isSlect = ([AppService.shared.rtcType compare:@"zego" options:NSCaseInsensitiveSearch] == NSOrderedSame) ? YES : NO;
    m0.isClickable = YES;
    
    ChangeRTCModel *m1 = [ChangeRTCModel new];
    m1.title = @"声网";
    m1.isSlect = ([AppService.shared.rtcType compare:@"agora" options:NSCaseInsensitiveSearch] == NSOrderedSame) ? YES : NO;
    m1.isClickable = YES;
    
    ChangeRTCModel *m2 = [ChangeRTCModel new];
    m2.title = @"网易云信";
    m2.isSlect = NO;
    m2.isClickable = NO;
    ChangeRTCModel *m3 = [ChangeRTCModel new];
    m3.title = @"火山";
    m3.isSlect = NO;
    m3.isClickable = NO;
    ChangeRTCModel *m4 = [ChangeRTCModel new];
    m4.title = @"阿里云";
    m4.isSlect = NO;
    m4.isClickable = NO;
    ChangeRTCModel *m5 = [ChangeRTCModel new];
    m5.title = @"腾讯";
    m5.isSlect = NO;
    m5.isClickable = NO;
    
    self.arrData = @[m0, m1, m2, m3, m4, m5];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
    ChangeRTCTCell *c = (ChangeRTCTCell *)cell;
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
                
                NSString *rtcType = [model.title isEqualToString:@"即构"] ? @"zego" : @"agora";
                [AppService.shared switchRtcType:rtcType];
                [weakSelf.tableView reloadData];
                
                if (self.onRTCChangeBlock) {
                    self.onRTCChangeBlock(AppService.shared.rtcType);
                }
                [weakSelf.navigationController popViewControllerAnimated:true];
            } onCloseCallback:^{
                
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
