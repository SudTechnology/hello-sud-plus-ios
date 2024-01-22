//
//  RespGiftListModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 单个banner模型
@interface RespBannerModel : BaseModel

@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSString *jumpUrl;
/// 1 跳房间 2 h5
@property (nonatomic, assign)NSInteger type;
@end


/// banner list
@interface RespBannerListModel : BaseRespModel
@property(nonatomic, strong) NSArray<RespBannerModel *> *bannerInfoList;
@end

NS_ASSUME_NONNULL_END
