//
//  QsrCommon.m
//  QuickStart-Runtime
//
//  Created by kaniel on 12/4/25.
//

#import "QsrCommon.h"

@implementation QsrCommon

+(instancetype)shared {
    static dispatch_once_t onceToken;
    static QsrCommon *g_common = nil;
    dispatch_once(&onceToken, ^{
        g_common = [[QsrCommon alloc]init];
    });
    return g_common;
}

- (void)reqGetCode:(void(^)(NSString *code))success fail:(void(^)(NSInteger code, NSString *msg))fail {
    
    NSString *getCodeUrl = @"https://fat-hellosud-base.s00.tech/login/v3";
    NSDictionary *dicParam = @{@"user_id": self.userId, @"app_id":SUDMGP_APP_ID };
    [self postHttpRequestWithURL:getCodeUrl param:dicParam success:^(NSDictionary *rootDict) {
        
        NSDictionary *dic = [rootDict objectForKey:@"data"];
        /// 这里的code用于登录游戏sdk服务器
        /// The code here is used to log in to the game sdk server
        NSString *code = [dic objectForKey:@"runtime_code"];
        NSInteger retCode = (int) [[dic objectForKey:@"ret_code"] longValue];
        NSString *errMsg = [dic objectForKey:@"ret_msg"];
        if (retCode == 0 && code.length > 0) {
            // callback the code
            success(code);
        } else {
            fail(retCode, errMsg);
        }
        
    }                    failure:^(NSError *error) {
        NSLog(@"login game server error:%@", error.debugDescription);
        fail(error.code, error.debugDescription);
    }];
}


/// 基础接口请求
/// Basic interface request
- (void)postHttpRequestWithURL:(NSString *)api
                         param:(NSDictionary *)param
                       success:(void (^)(NSDictionary *_Nonnull))success
                       failure:(void (^)(id _Nonnull))failure {
    
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (param) {
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONReadingMutableContainers error:nil];
        request.HTTPBody = bodyData;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
                return;
            }
            NSError *error;
            NSMutableDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (error) {
                if (failure) {
                    failure(error);
                }
                return;
            }
            if (success) {
                success(responseObject);
            }
        });
    }];
    [dataTask resume];
}
@end
