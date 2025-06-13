//
// Created by kaniel on 2023/8/7.
// Copyright (c) 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomRobotLevelSelectView.h"

//@interface RoomRobotLevelSelectView ()
//@property(nonatomic, strong) UIImageView *bgImageView;
//@property(nonatomic, strong) UIButton *numBtn1;
//@property(nonatomic, strong) UIButton *numBtn2;
//@property(nonatomic, strong) UIButton *numBtn3;
//@property(nonatomic, strong) UIButton *numBtn4;
//@property(nonatomic, strong) UIView *lineView1;
//@property(nonatomic, strong) UIView *lineView2;
//@property(nonatomic, strong) UIView *lineView3;
//
//
//@end


//@implementation RoomRobotLevelSelectView {
//
//}
//
//- (void)dtAddViews {
//    [super dtAddViews];
//    [self addSubview:self.bgImageView];
//    [self addSubview:self.numBtn1];
//    [self addSubview:self.numBtn2];
//    [self addSubview:self.numBtn3];
//    [self addSubview:self.numBtn4];
//    [self addSubview:self.lineView1];
//    [self addSubview:self.lineView2];
//    [self addSubview:self.lineView3];
//}
//
//- (void)dtLayoutViews {
//    [super dtLayoutViews];
//    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.top.bottom.equalTo(@0);
//    }];
//
//    [self.numBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(@0);
//        make.top.equalTo(@11);
//        make.height.equalTo(@18);
//    }];
//    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@7);
//        make.trailing.equalTo(@-7);
//        make.top.equalTo(self.numBtn3.mas_bottom).offset(11);
//        make.height.equalTo(@1);
//    }];
//    [self.numBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.equalTo(@0);
//        make.top.equalTo(self.numBtn3.mas_bottom).offset(24);
//        make.height.equalTo(self.numBtn3);
//    }];
//    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@7);
//        make.trailing.equalTo(@-7);
//        make.top.equalTo(self.numBtn2.mas_bottom).offset(11);
//        make.height.equalTo(@1);
//    }];
//    [self.numBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.numBtn2.mas_bottom).offset(24);
//        make.leading.trailing.equalTo(@0);
//        make.height.equalTo(self.numBtn2);
//    }];
//    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@7);
//        make.trailing.equalTo(@-7);
//        make.top.equalTo(self.numBtn1.mas_bottom).offset(11);
//        make.height.equalTo(@1);
//    }];
//    [self.numBtn4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.numBtn1.mas_bottom).offset(24);
//        make.leading.trailing.equalTo(@0);
//        make.height.equalTo(self.numBtn1);
//    }];
//
//}
//
//- (void)dtConfigUI {
//    [super dtConfigUI];
//    [self.numBtn1 setTitle:@"dt_room_robot_simple".dt_lan forState:UIControlStateNormal];
//    self.numBtn1.tag = 1;
//    [self.numBtn2 setTitle:@"dt_room_robot_middle".dt_lan forState:UIControlStateNormal];
//    self.numBtn2.tag = 2;
//    [self.numBtn3 setTitle:@"dt_room_robot_hard".dt_lan forState:UIControlStateNormal];
//    self.numBtn3.tag = 3;
//    [self.numBtn4 setTitle:@"dt_room_robot_ai".dt_lan forState:UIControlStateNormal];
//    self.numBtn4.tag = 4;
//    
//
//}
//
//- (void)dtConfigEvents {
//    [super dtConfigEvents];
//    WeakSelf
//    [self.numBtn1 dt_onClick:^(UIButton *sender) {
//
//        if (weakSelf) {
//            [weakSelf handleBtnClick:sender];
//        }
//    }];
//    [self.numBtn2 dt_onClick:^(UIButton *sender) {
//        if (weakSelf) {
//            [weakSelf handleBtnClick:sender];
//        }
//    }];
//    [self.numBtn3 dt_onClick:^(UIButton *sender) {
//        if (weakSelf) {
//            [weakSelf handleBtnClick:sender];
//        }
//    }];
//    [self dt_onTap:^(UITapGestureRecognizer * _Nonnull tap) {
//        if (weakSelf) {
//            weakSelf.noSelectedBlock();
//        }
//    }];
//
//}
//
//- (void)handleBtnClick:(UIButton *)sender {
//    self.numSelectedBlock(sender.tag);
//}
//
//- (UIImageView *)bgImageView {
//    if (!_bgImageView) {
//        _bgImageView = UIImageView.new;
//        _bgImageView.image = [UIImage imageNamed:@"robot_select_bg"];
//    }
//    return _bgImageView;
//}
//
//- (UIButton *)numBtn1 {
//    if (!_numBtn1) {
//        _numBtn1 = UIButton.new;
//        [_numBtn1 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
//        [_numBtn1 setBackgroundImage:[UIImage imageNamed:@"robot_btn_selected"] forState:UIControlStateHighlighted];
//        _numBtn1.titleLabel.font = UIFONT_BOLD(13);
//    }
//    return _numBtn1;
//}
//
//- (UIButton *)numBtn2 {
//    if (!_numBtn2) {
//        _numBtn2 = UIButton.new;
//        [_numBtn2 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
//        [_numBtn2 setBackgroundImage:[UIImage imageNamed:@"robot_btn_selected"] forState:UIControlStateHighlighted];
//        _numBtn2.titleLabel.font = UIFONT_BOLD(13);
//    }
//    return _numBtn2;
//}
//
//- (UIButton *)numBtn3 {
//    if (!_numBtn3) {
//        _numBtn3 = UIButton.new;
//        [_numBtn3 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
//        [_numBtn3 setBackgroundImage:[UIImage imageNamed:@"robot_btn_selected"] forState:UIControlStateHighlighted];
//        _numBtn3.titleLabel.font = UIFONT_BOLD(13);
//    }
//    return _numBtn3;
//}
//
//- (UIButton *)numBtn4 {
//    if (!_numBtn4) {
//        _numBtn4 = UIButton.new;
//        [_numBtn4 setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
//        [_numBtn4 setBackgroundImage:[UIImage imageNamed:@"robot_btn_selected"] forState:UIControlStateHighlighted];
//        _numBtn4.titleLabel.font = UIFONT_BOLD(13);
//    }
//    return _numBtn4;
//}
//
//- (UIView *)lineView1 {
//    if (!_lineView1) {
//        _lineView1 = UIView.new;
//        _lineView1.backgroundColor = HEX_COLOR(@"#DDDDDD");
//    }
//    return _lineView1;
//}
//
//- (UIView *)lineView2 {
//    if (!_lineView2) {
//        _lineView2 = UIView.new;
//        _lineView2.backgroundColor = HEX_COLOR(@"#DDDDDD");
//    }
//    return _lineView2;
//}
//
//- (UIView *)lineView3 {
//    if (!_lineView3) {
//        _lineView3 = UIView.new;
//        _lineView3.backgroundColor = HEX_COLOR(@"#DDDDDD");
//    }
//    return _lineView3;
//}
//
//@end


@interface RobotLevelCell : BaseTableViewCell
@property (nonatomic, strong) UIButton *levelButton;
@property (nonatomic, strong) UIView *lineView;
@property(nonatomic, assign)BOOL isShowLine;

@end
@implementation RobotLevelCell

- (void)dtAddViews {
    [super dtAddViews];
    self.levelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.levelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.levelButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:self.levelButton];
    [self.contentView addSubview:self.lineView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.levelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.centerY.equalTo(@0);
        make.height.equalTo(@18);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@7);
        make.trailing.equalTo(@-7);
        make.bottom.equalTo(@-1);
        make.height.equalTo(@1);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _lineView;
}

- (void)setIsShowLine:(BOOL)isShowLine {
    _isShowLine = isShowLine;
    self.lineView.hidden = isShowLine ? NO : YES;
}
@end


@interface RoomRobotLevelSelectView () <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)NSArray *levelTitles;

@end
@implementation RoomRobotLevelSelectView

- (void)dtAddViews {
    [super dtAddViews];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RobotLevelCell class] forCellReuseIdentifier:@"RobotLevelCell"];
    [self addSubview:self.bgImageView];
    [self addSubview:self.tableView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.bottom.equalTo(@-10);
    }];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = UIImageView.new;
        _bgImageView.image = [[UIImage imageNamed:@"robot_select_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(60, 38, -58, -38) resizingMode:UIImageResizingModeStretch];
    }
    return _bgImageView;
}

- (void)updateTitles:(NSArray<NSString *>*)titleArr {
    self.levelTitles = titleArr;
    [self.tableView reloadData];
}

- (void)setup {

}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.levelTitles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RobotLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RobotLevelCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
    
    [cell.levelButton setTitle:self.levelTitles[indexPath.row] forState:UIControlStateNormal];
    cell.levelButton.tag = indexPath.row + 1; // Set tag for button action
    
    // Add action for button click
    [cell.levelButton addTarget:self action:@selector(handleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row != self.levelTitles.count - 1) {
        cell.isShowLine = YES;
    } else {
        cell.isShowLine = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}
#pragma mark - UITableViewDelegate
- (void)handleButtonClick:(UIButton *)sender {
    if (self.numSelectedBlock) {
        self.numSelectedBlock(sender.tag);
    }
}
@end
