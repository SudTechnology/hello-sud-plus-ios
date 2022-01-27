//
//  HSRespGameInfoModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/27.
//

#import "HSBaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏数据
@interface HSRespGameInfoDataModel : BaseModel

/// game code
@property(nonatomic, copy)NSString *code;
/// the code expireDate
@property(nonatomic, assign)NSInteger expireDate;
@end

/// 登录游戏服务model
@interface HSRespGameInfoModel : HSBaseRespModel
@property(nonatomic, strong)HSRespGameInfoDataModel *data;
@end


NS_ASSUME_NONNULL_END
