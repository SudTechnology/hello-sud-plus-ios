//
//  SudNetworkCheckParamModel.h
//  SudMGP
//
//  Created by kaniel on 2/14/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 检测状态
FOUNDATION_EXPORT NSString *const SudNetworkDetectionStatus_WAITING;// 等待
FOUNDATION_EXPORT NSString *const SudNetworkDetectionStatus_CHECKING;// 检测中
FOUNDATION_EXPORT NSString *const SudNetworkDetectionStatus_COMPLETED;// 检测完成

// 网络检测详情的具体类型
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_CALL_START; // 请求开始
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_DNS_START; // dns开始解析
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_DNS_END; // dns解析完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_CONNECT_START; // 连接开始
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_SECURE_CONNECT_START; // SSL/TLS连接开始
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_SECURE_CONNECT_END; // SSL/TLS连接完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_CONNECT_END; // 连接完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_REQUEST_HEADERS_START; // 发送headers开始
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_REQUEST_HEADERS_END; // 发送headers完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_REQUEST_BODY_START; // 发送body开始
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_REQUEST_BODY_END; // 发送body完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_RESPONSE_HEADERS_START; // 开始返回headers
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_RESPONSE_HEADERS_END; // 返回headers完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_RESPONSE_BODY_START; // 开始返回body
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_RESPONSE_BODY_END; // 返回body完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_CALL_END; // 请求完成
FOUNDATION_EXPORT NSString *const SudNetworkDetectionDetailType_CALL_FAILED; // 请求错误

// 网络检测参数
@interface SudNetworkDetectionParamModel : NSObject
@property (nonatomic, assign) BOOL isTestEnv;
@property (nonatomic, strong, nonnull) NSString *appId;
@property (nonatomic, strong, nonnull) NSString *appKey;
@property (nonatomic, strong, nonnull) NSString *userId;
@end

// 小步骤里面的检测结果
@interface SudNetworkDetectionStepResult : NSObject
@property (nonatomic, assign) NSInteger code; // 错误码，0为成功，非0为失败
@property (nonatomic, strong, nullable) NSString *msg; // 消息文本
@end

// 网络检测详情
@interface SudNetworkDetectionDetail : NSObject
@property (nonatomic, assign) NSString *type; // 类型
@property (nonatomic, assign) long timestamp; // 时间戳
@end

// 网络检测步骤信息
@interface SudNetworkDetectionStep : NSObject
@property (nonatomic, assign) NSInteger identifier; // 唯一id
@property (nonatomic, strong, nonnull) NSString *protocol; // 网络协议：https、wss
@property (nonatomic, strong, nonnull) NSString *method; // 请求方法：GET、POST
@property (nonatomic, strong) NSString * status; // 检测状态
@property (nonatomic, strong, nullable) NSArray<SudNetworkDetectionDetail *> *detailList; // 检测详情
@property (nonatomic, strong, nonnull) SudNetworkDetectionStepResult *result; // 当前步骤的检测结果
@end

// 网络检测结果
@interface SudNetworkDetectionResult : NSObject
@property (nonatomic, assign) NSInteger code; // 错误码，0为成功，非0为失败
@property (nonatomic, strong, nullable) NSString *msg; // 消息文本
@property (nonatomic, strong, nonnull) NSArray<SudNetworkDetectionStep *> *stepList; // 步骤列表
@end

NS_ASSUME_NONNULL_END
