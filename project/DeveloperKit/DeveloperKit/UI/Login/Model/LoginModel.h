//
//  LoginModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginModel: BaseRespModel
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * refreshToken;

@end

NS_ASSUME_NONNULL_END
