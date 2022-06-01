//
//  DTSVGAPlayerView.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 播放器状态
typedef NS_ENUM(NSInteger, HSSVGAPlayerStateType) {
    HSSVGAPlayerStateTypeUnknow = 0,   // 未知
    HSSVGAPlayerStateTypePrepare = 1,  // 准备中
    HSSVGAPlayerStateTypeWaitPlay = 2, // 等待播放
    HSSVGAPlayerStateTypePlaying  = 3, // 播放中
    HSSVGAPlayerStateTypeFinished = 4, // 播放结束
    HSSVGAPlayerStateTypeFailed = 5    // 播放失败
};

/// svga播放视图
@interface DTSVGAPlayerView : BaseView

/// 播放状态
@property(nonatomic, assign)HSSVGAPlayerStateType playState;

/// 设置播放地址
/// @param url 播放URL
- (void)setURL:(NSURL *)url;

/// 开始播放
/// @param loops 循环次数
/// @param didFinished 播放结束
- (void)play:(NSInteger)loops didFinished:(EmptyBlock)didFinished;
@end

NS_ASSUME_NONNULL_END
