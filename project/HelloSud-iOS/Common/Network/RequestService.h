//
//  RequestService.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

/** 请求类型的枚举 */
typedef NS_ENUM(NSUInteger, HttpRequestType){
    /** get请求 */
    HttpRequestTypeGet = 0,
    /** post请求 */
    HttpRequestTypePost
};

/**
 http通讯成功的block

 @param responseObject 返回的数据
 */
typedef void (^HTTPRequestSuccessBlock)(id responseObject);

/**
 http通讯失败后的block

 @param error 返回的错误信息
 */
typedef void (^HTTPRequestFailedBlock)(NSError *error);


//超时时间
extern NSInteger const kAFNetworkingTimeoutInterval;


@interface RequestService : NSObject

/**
 *  网络请求的实例方法
 *
 *  @param type         get / post (项目目前只支持这倆中)
 *  @param urlString    请求的地址
 *  @param parameters   请求的参数
 *  @param successBlock 请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)requestWithType:(HttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(HTTPRequestSuccessBlock)successBlock
           failureBlock:(HTTPRequestFailedBlock)failureBlock;

/**
 取消队列
 */
+(void)cancelDataTask;


+ (void)postRequestWithApi:(NSString *)api
                     param:(NSDictionary *)param
                   success:(void(^)(NSDictionary *rootDict))success
                   failure:(void(^)(id error))failure;

+ (void)getRequestWithApi:(NSString *)api
                    param:(NSDictionary *)param
                  success:(void(^)(NSDictionary *rootDict))success
                  failure:(void(^)(id error))failure;

@end
