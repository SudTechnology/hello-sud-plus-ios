//
//  RespGiftListModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 单个礼物模型
@interface RespGiftModel : BaseModel
@property(nonatomic, assign) NSInteger giftId;
@property(nonatomic, assign) NSInteger giftPrice;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *giftUrl;
@property(nonatomic, strong) NSString *bigGiftUrl;
@property(nonatomic, strong) NSString *smallGiftUrl;
@property(nonatomic, strong) NSString *animationUrl;
@end


/// 礼物礼拜model
@interface RespGiftListModel : BaseRespModel
@property(nonatomic, strong) NSArray<RespGiftModel *> *giftList;
@end

NS_ASSUME_NONNULL_END
