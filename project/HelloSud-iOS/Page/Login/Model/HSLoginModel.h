//
//  HSLoginModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSLoginData: BaseModel
@property (nonatomic, copy) NSString              * avatar;
@property (nonatomic, assign) NSInteger              userId;
@property (nonatomic, copy) NSString              * nickname;
@property (nonatomic, copy) NSString              * token;

@end

@interface HSLoginModel: HSBaseRespModel
@property (nonatomic, strong) HSLoginData              *data;

@end

NS_ASSUME_NONNULL_END
