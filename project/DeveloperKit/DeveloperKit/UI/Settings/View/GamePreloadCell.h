//
//  HSSettingCell.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/20.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
/// 游戏预加载
@interface GamePreloadCell : BaseTableViewCell

/// 是否展示顶部线条
@property(nonatomic, assign)BOOL isShowTopLine;
@property(nonatomic, copy)void(^loadGameBlock)(void);
@property(nonatomic, copy)void(^startDownloadBlock)(void);
@property(nonatomic, copy)void(^cancelDownloadBlock)(void);
@property(nonatomic, copy)void(^pauseDownloadBlock)(void);
- (void)updateDownloadedSize:(long) downloadedSize totalSize:(long) totalSize;
- (void)updateFailureWithCode:(NSInteger)code msg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
