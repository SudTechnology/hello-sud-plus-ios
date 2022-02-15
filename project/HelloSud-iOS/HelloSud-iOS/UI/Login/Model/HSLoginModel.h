//
//  HSLoginModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSLoginModel: HSBaseRespModel
@property (nonatomic, copy) NSString              * avatar;
@property (nonatomic, assign) NSInteger              userId;
@property (nonatomic, copy) NSString              * nickname;
@property (nonatomic, copy) NSString              * token;

@end

NS_ASSUME_NONNULL_END
