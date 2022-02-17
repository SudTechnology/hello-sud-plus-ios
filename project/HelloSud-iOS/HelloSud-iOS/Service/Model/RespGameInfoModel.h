//
//  RespGameInfoModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 登录游戏服务model
@interface RespGameInfoModel : BaseRespModel
/// game code
@property(nonatomic, copy)NSString *code;
/// the code expireDate
@property(nonatomic, assign)NSInteger expireDate;
@end


NS_ASSUME_NONNULL_END
