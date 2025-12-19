//
//  SudAdAnimateView.m
//  HelloSudPlus
//
//  Created by kaniel on 11/11/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudAdAnimateView.h"


@interface SudAdAnimateView()
@property(nonatomic, strong)UIImageView *ivCircle;
@property(nonatomic, strong)UILabel *labCount;
@property(nonatomic, strong)UILabel *labMs;
@property(nonatomic, assign)NSInteger count;

// 新增计时相关属性
@property (nonatomic, strong) CADisplayLink *displayLink; // 毫秒级刷新定时器
@property (nonatomic, assign) NSTimeInterval startTime; // 起始时间戳
@property (nonatomic, assign) NSTimeInterval totalElapsedTime; // 累计已流逝时间（支持暂停/恢复）

@end

@implementation SudAdAnimateView

#pragma mark - 内存管理（避免泄漏）
- (void)dealloc {
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)dtAddViews {
    [super dtAddViews];
    [self addSubview:self.ivCircle];
    [self addSubview:self.labCount];
    [self addSubview:self.labMs];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.ivCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@210);
        make.center.equalTo(self);
    }];
    [self.labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@60);
        make.centerY.equalTo(self);
    }];
    [self.labMs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@16);
        make.top.equalTo(self.labCount.mas_bottom).offset(20);
    }];
}

// 圆形图片视图（已提供，保留作参考）
- (UIImageView *)ivCircle {
    if (!_ivCircle) {
        _ivCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ad_waitting_circle"]];
        // 可选补充：设置图片模式、尺寸等（根据需求调整）
        _ivCircle.contentMode = UIViewContentModeScaleAspectFit; // 保持图片比例
        _ivCircle.clipsToBounds = YES; // 裁剪超出部分
    }
    return _ivCircle;
}

// 数字计数标签（如倒计时数字：3、2、1）
- (UILabel *)labCount {
    if (!_labCount) {
        _labCount = [[UILabel alloc] init];
        // 基础样式配置（可根据实际需求修改）
        _labCount.textAlignment = NSTextAlignmentCenter; // 文字居中
        _labCount.font = UIFONT_MEDIUM(60); // 粗体大字体（突出数字）
        _labCount.textColor = HEX_COLOR_A(@"#ffffff", 0.8); // 文字白色（适配深色背景）
        // 可选：初始文字（如默认显示"3"）
        _labCount.text = @"";
    }
    return _labCount;
}

// 单位标签（如"秒"、"ms"）
- (UILabel *)labMs {
    if (!_labMs) {
        _labMs = [[UILabel alloc] init];
        // 基础样式配置（与 labCount 搭配，风格统一）
        _labMs.textAlignment = NSTextAlignmentCenter;
        _labMs.font = UIFONT_REGULAR(16); // 偏小字体（作为单位辅助）
        _labMs.textColor = HEX_COLOR_A(@"#ffffff", 0.5);;
        // 可选：初始文字（根据需求修改，如"秒"、"ms"）
        _labMs.text = @"ms";
    }
    return _labMs;
}


- (void)startTimer {
    DDLogDebug(@"startTimer:%@", self);
    if (self.displayLink) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    // 1. 记录起始时间戳
    self.startTime = CACurrentMediaTime(); // 高精度时间戳（适合毫秒级）
    self.totalElapsedTime = 0;
    // 2. 初始化CADisplayLink（屏幕刷新率同步，默认60帧/秒，即~16.67ms刷新一次）
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimer)];
    self.displayLink.preferredFramesPerSecond = 30;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    DDLogDebug(@"stopTimer:%@", self);
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)updateTimer {
    // 计算当前累计时间（高精度，误差<1ms）
    self.totalElapsedTime = CACurrentMediaTime() - self.startTime;
    // 格式化时间并更新标签
    self.labCount.text = [NSString stringWithFormat:@"%ld", (NSInteger)(self.totalElapsedTime * 1000)];
}
@end
