//
//  SudAiModel.h
//  SudMGP
//
//  Created by kaniel on 9/23/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// AI大模型模块
@interface SudAiModel : NSObject

/// AI大模型常规接口
/// - Parameters:
///   - param: json string参数,详细参数参阅文档
///   - completed: 完成时回调，返回json string结果
+ (void)aiCommon:(NSString *_Nonnull)param
       completed:(void(^_Nullable)(NSString *_Nonnull result))completed;

/// AI大模型sse形式接口
/// - Parameters:
///   - param: json string参数,详细参数参阅文档
///   - message: 事件回调数据
///   - completed: 完成回调
///   - fail: 失败回调
+ (void)aiSse:(NSString *_Nonnull)param
      message:(void(^)(NSString *message))message
    completed:(void(^_Nullable)(void))completed
         fail:(void(^_Nullable)(NSInteger errCode, NSString *_Nonnull errMsg))fail;

/// 加载模型接口
/// - Parameters:
///   - param: json string参数,详细参数参阅文档
///   - success: 成功时返回的模型二进制数据
///   - fail: 失败回调
+ (void)loadModel:(NSString *_Nonnull)param
          success:(void(^_Nullable)(NSData *_Nonnull data))success
             fail:(void(^_Nullable)(NSInteger errCode, NSString *_Nonnull errMsg))fail;

/// 清空所有缓存
+ (void)clearAllCache;

/// 获取缓存路径
+ (NSString *)getCachePath;
@end

NS_ASSUME_NONNULL_END
