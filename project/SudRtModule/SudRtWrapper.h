//
//  SudRtWrapper.h
//  HelloSudPlus
//
//  Created by kaniel on 9/18/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 运行时指令响应
@protocol SudRtWrapperCommandListener <NSObject>
@optional
- (void)onCommand:(NSString *)state
         dataJson:(NSString *)dataJson
          success:(void(^)(NSString *dataJson))success
             fail:(void(^)(NSString *error))fail;

@end


@interface SudRtGameInfo : NSObject
/// 游戏id
@property(nonatomic, strong)NSString *gameId;
/// 版本号
@property(nonatomic, strong)NSString *version;
/// 加载链接
@property(nonatomic, strong)NSString *url;
/// 链接 hash
@property(nonatomic, strong)NSString *gameHash;
/// 定义标签
@property(nonatomic, strong)NSString *gameTag;
@property(nonatomic, strong)NSString *code;
@end

@interface SudRtWrapper : NSObject
@property(nonatomic, strong)UIView *gameView;
@property(nonatomic, strong)NSString *userId;
@property(nonatomic, weak)id<SudRtWrapperCommandListener> commandListener;

/// 加载游戏
/// - Parameters:
///   - sudRtGameInfo: 加载参数
///   - onUpdatedGameViewBlock: 游戏视图回调，将返回游戏加入UI视图中并布局待展示
///   - completion: 完成加载回调
- (void)loadGameWithGameInfo:(SudRtGameInfo *)sudRtGameInfo
      onUpdatedGameViewBlock:(void(^)(UIView *gameView))onUpdatedGameViewBlock
                  completion:(void(^)(NSError *error))completion;

/// 安装缓存游戏包
/// - Parameters:
///   - sudRtGameInfo: sudRtGameInfo description
///   - completion: completion description
- (void)cacheGamePackage:(SudRtGameInfo *)sudRtGameInfo
              completion:(void(^)(NSError *error))completion;


/// 对应停止时，调用恢复
- (void)startGame;

/// 停止游戏
- (void)stopGame;

- (void)startPlayGame;
- (void)stopPlayGame;

/// 停止并销毁游戏
- (void)destroyGame:(nullable void (^)(NSError * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
