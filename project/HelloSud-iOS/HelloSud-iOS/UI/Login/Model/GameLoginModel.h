//
//  GameLoginModel.h
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/26.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameLoginModel : BaseRespModel
@property (nonatomic, assign) int                   expireDate;
@property (nonatomic, strong) NSString              *code;
@end

NS_ASSUME_NONNULL_END
