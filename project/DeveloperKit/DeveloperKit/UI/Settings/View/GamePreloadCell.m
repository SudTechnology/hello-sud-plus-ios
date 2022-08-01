//
//  HSSettingCell.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "GamePreloadCell.h"
#import "HSSettingModel.h"

@interface GamePreloadCell()
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *progressLabel;
@property (nonatomic, strong)UIButton *loadBtn;
@property (nonatomic, strong)UIButton *startBtn;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *pauseBtn;
@property (nonatomic, strong)UIProgressView *progressView;

@end

@implementation GamePreloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dtAddViews {
    [super dtAddViews];
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.progressLabel];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.loadBtn];
    [self.contentView addSubview:self.startBtn];
    [self.contentView addSubview:self.cancelBtn];
//    [self.contentView addSubview:self.pauseBtn];
    [self.contentView addSubview:self.progressView];
}

- (void)dtLayoutViews {
    [super dtLayoutViews];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.trailing.mas_equalTo(-20);
        make.leading.mas_equalTo(20);
        make.height.mas_equalTo(0.5);

    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.leading.equalTo(@16);
        make.centerY.equalTo(self.contentView);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing).offset(8);
        make.height.mas_greaterThanOrEqualTo(0);
        make.top.equalTo(self.iconImageView);
        make.trailing.equalTo(self.loadBtn.mas_leading);
    }];
    [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(2);
    }];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView);
        make.height.equalTo(@5);
        make.trailing.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.progressLabel.mas_bottom).offset(2);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.contentView);
    }];
//    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.equalTo(self.pauseBtn.mas_leading).offset(-5);
//        make.width.height.mas_greaterThanOrEqualTo(0);
//        make.centerY.equalTo(self.contentView);
//    }];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.cancelBtn.mas_leading).offset(-5);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.contentView);
    }];
    [self.loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.startBtn.mas_leading).offset(-5);
        make.width.height.mas_greaterThanOrEqualTo(0);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)dtUpdateUI {
    [super dtUpdateUI];
    if (![self.model isKindOfClass:[QSGameItemModel class]]) {
        return;
    }
    QSGameItemModel *model = (QSGameItemModel *)self.model;
    self.nameLabel.text = model.gameName;
    self.iconImageView.image = [UIImage imageNamed:model.gameRoomPic];
    [self updateDownloadedSize:model.downloadedSize totalSize:model.totalSize];
    
}

- (void)dtConfigEvents {
    [super dtConfigEvents];
    [self.loadBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onBtnClick:(UIButton *)sender {
    if (sender == self.loadBtn) {
        // 加载
        if (self.loadGameBlock) self.loadGameBlock();
    } else if (sender == self.startBtn) {
        // 开始
        if (self.startDownloadBlock) self.startDownloadBlock();
    } else if (sender == self.cancelBtn) {
        // 取消
        if (self.cancelDownloadBlock) self.cancelDownloadBlock();
    } else if (sender == self.pauseBtn) {
        // 暂停
        if (self.pauseDownloadBlock) self.pauseDownloadBlock();
    }
}

- (void)setIsShowTopLine:(BOOL)isShowTopLine {
    _isShowTopLine = isShowTopLine;
    self.topView.hidden = isShowTopLine ? NO : YES;
}

- (void)updateDownloadedSize:(long) downloadedSize totalSize:(long) totalSize {
    QSGameItemModel *model = (QSGameItemModel *)self.model;
    model.downloadedSize = downloadedSize;
    model.totalSize = totalSize;
    
    CGFloat totalMB = totalSize * 1.0 / 1024 / 1024;
    CGFloat downloadedMB = downloadedSize * 1.0 / 1024 / 1024;
    self.progressLabel.text = [NSString stringWithFormat:@"进度：%.02fMB/%.02fMB", downloadedMB, totalMB];
    if (totalMB > 0) {
        self.progressView.progress = downloadedMB / totalMB;
    } else {
        self.progressView.progress = 0;
    }
    if (downloadedSize == totalSize && totalSize > 0) {
        self.progressLabel.text = @"已完成";
    }
}

- (void)updateFailureWithCode:(NSInteger)code msg:(NSString *)msg {
    self.progressLabel.text = [NSString stringWithFormat:@"%@(%@)", msg, @(code)];
}

#pragma mark lazy
- (UIView *)topView {
    if (_topView == nil) {
        _topView = UIView.new;
        _topView.backgroundColor = HEX_COLOR(@"#DDDDDD");
    }
    return _topView;
}

- (UIView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = UIImageView.new;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
 
    if (_nameLabel == nil) {
        _nameLabel = UILabel.new;
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = HEX_COLOR(@"#1A1A1A");
    }
    return _nameLabel;
}

- (UILabel *)progressLabel {
 
    if (_progressLabel == nil) {
        _progressLabel = UILabel.new;
        _progressLabel.font = [UIFont systemFontOfSize:12];
        _progressLabel.textColor = HEX_COLOR(@"#8A8A8E");
        _progressLabel.textAlignment = NSTextAlignmentRight;
        _progressLabel.text = @"未下载";
    }
    return _progressLabel;
}

- (UIButton *)loadBtn {
    if (!_loadBtn) {
        _loadBtn = [[UIButton alloc]init];
        [_loadBtn setTitle:@"加载游戏" forState:UIControlStateNormal];
        _loadBtn.titleLabel.font = UIFONT_REGULAR(14);
        _loadBtn.layer.borderWidth = 2;
        _loadBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_loadBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_loadBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return  _loadBtn;
}

- (UIButton *)startBtn {
    if (!_startBtn) {
        _startBtn = [[UIButton alloc]init];
        [_startBtn setTitle:@"开始" forState:UIControlStateNormal];
        _startBtn.titleLabel.font = UIFONT_REGULAR(14);
        _startBtn.layer.borderWidth = 2;
        _startBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_startBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_startBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return  _startBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = UIFONT_REGULAR(14);
        _cancelBtn.layer.borderWidth = 2;
        _cancelBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_cancelBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_cancelBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return  _cancelBtn;
}

- (UIButton *)pauseBtn {
    if (!_pauseBtn) {
        _pauseBtn = [[UIButton alloc]init];
        [_pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
        _pauseBtn.titleLabel.font = UIFONT_REGULAR(14);
        _pauseBtn.layer.borderWidth = 2;
        _pauseBtn.layer.borderColor = UIColor.orangeColor.CGColor;
        [_pauseBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_pauseBtn setContentEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];

    }
    return  _pauseBtn;
}

-(UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]init];
        _progressView.tintColor = UIColor.orangeColor;
        _progressView.trackTintColor = UIColor.lightGrayColor;
    }
    return _progressView;
}

@end
