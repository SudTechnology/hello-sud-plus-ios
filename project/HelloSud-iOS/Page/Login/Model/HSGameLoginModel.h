//
//  HSGameLoginModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "HSBaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSGameLoginData : BaseModel
@property (nonatomic, assign) int                   expireDate;
@property (nonatomic, strong) NSString              *code;

@end

@interface HSGameLoginModel : HSBaseRespModel
@property (nonatomic, strong) HSGameLoginData              *data;
@end

NS_ASSUME_NONNULL_END
