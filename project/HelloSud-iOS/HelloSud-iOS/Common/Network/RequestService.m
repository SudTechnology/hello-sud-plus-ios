//
//  RequestService.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "RequestService.h"

NSInteger const kAFNetworkingTimeoutInterval = 10;

@implementation RequestService

static AFHTTPSessionManager *aManager;

+ (AFHTTPSessionManager *)sharedAFManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        aManager = [AFHTTPSessionManager manager];
        //以下三项manager的属性根据需要进行配置
        aManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/xml",@"text/json",@"text/plain",@"text/JavaScript",@"application/json",@"image/jpeg",@"image/png",@"application/octet-stream",nil];
        
        aManager.requestSerializer = [AFJSONRequestSerializer serializer];
        aManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置超时时间
        aManager.requestSerializer.timeoutInterval = kAFNetworkingTimeoutInterval;
        
        [aManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
    });
    return aManager;
}

+ (void)requestWithType:(HttpRequestType)type
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
           successBlock:(HTTPRequestSuccessBlock)successBlock
           failureBlock:(HTTPRequestFailedBlock)failureBlock {
    if (urlString == nil) {
        return;
    }
    
    if (@available(iOS 9.0, *)) {
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    if (type == HttpRequestTypeGet){
        [[self sharedAFManager] GET:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                id JSON =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                successBlock(JSON);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code !=-999) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }else{
                NSLog(@"取消队列了");
            }
        }];
    }
    if (type == HttpRequestTypePost){
        
        [[self sharedAFManager] POST:urlString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id JSON =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (successBlock){
                successBlock(JSON);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code !=-999) {
                if (failureBlock){
                    failureBlock(error);
                }
            }else{
                NSLog(@"取消队列了");
            }
        }];
    }
}

+ (void)cancelDataTask {
    NSMutableArray *dataTasks = [NSMutableArray arrayWithArray:[self sharedAFManager].dataTasks];
    for (NSURLSessionDataTask *taskObj in dataTasks) {
        [taskObj cancel];
    }
}

/// 设置请求头
+ (void)setupHeader:(NSDictionary *)dic {
    for (NSString *key in dic) {
        NSString *value = [dic objectForKey:key];
        [[self sharedAFManager].requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

+ (void)postRequestWithApi:(NSString *)api
                     param:(NSDictionary *)param
                   success:(void (^)(NSDictionary * _Nonnull))success
                   failure:(void (^)(id _Nonnull))failure {
    [self requestWithType:HttpRequestTypePost urlString:api parameters:param successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getRequestWithApi:(NSString *)api
                    param:(NSDictionary *)param
                  success:(void (^)(NSDictionary * _Nonnull))success
                  failure:(void (^)(id _Nonnull))failure {
    [self requestWithType:HttpRequestTypeGet urlString:api parameters:param successBlock:^(id responseObject) {
        success(responseObject);
    } failureBlock:^(NSError *error) {
        failure(error);
    }];
}

+ (void)downloadRequestWithApi:(NSString *)url
                    param:(NSDictionary *)param
                      progress:(void(^)(NSInteger progress))progress
                  success:(void(^)(NSDictionary *rootDict))success
                  failure:(void(^)(id error))failure{
    NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[self sharedAFManager] downloadTaskWithRequest:requset progress:^(NSProgress * _Nonnull downloadProgress) {
//        progress(downloadProgress.);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
}

@end
