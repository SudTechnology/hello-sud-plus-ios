//
//  RespBaseModel.h
//  SudMGP
//
//  Created by kaniel on 2022/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseRespModel : NSObject
/// 接口错误码
@property (nonatomic, assign) NSInteger retCode;
/// 接口错误信息
@property (nonatomic, copy) NSString * retMsg;
/// 解码消息
/// @param rootDic 根JSON
+ (instancetype)decodeModel:(NSDictionary *)rootDic;
@end

NS_ASSUME_NONNULL_END
