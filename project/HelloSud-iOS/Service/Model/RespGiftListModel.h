//
//  RespGiftListModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/22.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GiftItemDetailModel : BaseModel
typedef NS_ENUM(NSInteger, GiftItemDetailCardType){
    GiftItemDetailCardTypeRole = 1,
    GiftItemDetailCardTypeCard = 2
};

@property(nonatomic, strong)NSString *backgroundUrl;
@property(nonatomic, assign)GiftItemDetailCardType cardType;
@property(nonatomic, strong)NSString *desc;
@property(nonatomic, strong)NSString *textColor;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *content;
@end

/// 单个礼物模型
@interface RespGiftModel : BaseModel
@property(nonatomic, assign) NSInteger giftId;
@property(nonatomic, assign) NSInteger giftPrice;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *giftUrl;
@property(nonatomic, strong) NSString *bigGiftUrl;
@property(nonatomic, strong) NSString *smallGiftUrl;
@property(nonatomic, strong) NSString *animationUrl;
@property(nonatomic, strong) GiftItemDetailModel *details;
@end


/// 礼物礼拜model
@interface RespGiftListModel : BaseRespModel
@property(nonatomic, strong) NSArray<RespGiftModel *> *giftList;
@end

NS_ASSUME_NONNULL_END
