//
//  MicOperateView.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "MicOperateView.h"
@interface MicOperateView()
@property(nonatomic, strong)UIView *operateView;
@property(nonatomic, strong)UIButton *cancelBtn;
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)NSArray<NSString *> *operateList;
@end

@implementation MicOperateView

/// 初始化操作列表
/// @param list 操作列表名称
- (instancetype)initWithOperateList:(NSArray<NSString *>*)list {
    if (self = [super initWithFrame:CGRectZero]) {
        _operateList = list;
        [self layoutOperate];
    }
    return self;
}
- (void)dtAddViews {
    [self addSubview:self.operateView];
    [self addSubview:self.lineView];
    [self addSubview:self.cancelBtn];
}

- (void)dtLayoutViews {
    
    [self.operateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.operateView.mas_bottom);
    }];
    CGFloat bottom = kAppSafeBottom;
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(56);
        make.bottom.mas_equalTo(-bottom);
    }];
}

- (void)dtConfigUI {
    self.backgroundColor = HEX_COLOR(@"#F2F2F2");
}


/// 布局操作列表
- (void)layoutOperate {
    UIButton *lastBtn = nil;
    for (int i = 0; i < self.operateList.count; ++i) {
        NSString *name = self.operateList[i];
        UIButton * btn = UIButton.new;
        [self.operateView addSubview:btn];
        [btn setTitle:name forState:UIControlStateNormal];
        btn.titleLabel.font = UIFONT_REGULAR(13);
        [btn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onBtnOperate:) forControlEvents:UIControlEventTouchUpInside];
        if (lastBtn == nil) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(56);
                // 只有一个
                if (self.operateList.count == 1) {
                    make.bottom.mas_equalTo(0);
                }
            }];
        } else {
            if (i == self.operateList.count - 1) {
                // 最后一个
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastBtn.mas_bottom);
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(56);
                    make.bottom.mas_equalTo(0);
                }];
            } else {
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastBtn.mas_bottom);
                    make.left.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(56);
                }];
            }
        }
        lastBtn = btn;
    }
    
}

- (void)onBtnOperate:(UIButton *)sender {
    if (self.operateCallback) self.operateCallback(sender.currentTitle);
}

- (void)onBtnCancel:(UIButton *)sender {
    if (self.cancelCallback) self.cancelCallback(sender);
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setTitle:NSString.dt_common_cancel forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = UIFONT_REGULAR(13);
        [_cancelBtn setTitleColor:HEX_COLOR(@"#000000") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(onBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (UIView *)operateView {
    if (_operateView == nil) {
        _operateView = UIView.new;
    }
    return _operateView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = UIView.new;
        _lineView.backgroundColor = HEX_COLOR(@"#D1D2D8");
    }
    return _lineView;
}
@end
