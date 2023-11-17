//
//  GiftModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "BaseModel.h"
#import "RespGiftListModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HSGiftModelSelectedBlock)(void);
typedef void(^GiftLoadImageBlock)(UIImage *image);



/// 礼物model
@interface GiftModel : BaseModel

/// 礼物图片地址
@property(nonatomic, copy)NSString *giftURL;
/// 礼物小图图片地址
@property(nonatomic, copy)NSString *smallGiftURL;
/// 礼物名称
@property(nonatomic, copy)NSString *giftName;
/// 礼物动效地址
@property(nonatomic, copy)NSString *animateURL;
/// 礼物动效类型
@property(nonatomic, copy)NSString *animateType;
/// 礼物ID
@property(nonatomic, assign)NSInteger giftID;
/// 是否选中
@property(nonatomic, assign)BOOL isSelected;
/// 金额
@property(nonatomic, assign)NSInteger price;
/// 类型 0 内置礼物 1 服务端礼物
@property(nonatomic, assign)NSInteger type;
/// 礼物标识
@property (nonatomic, strong)NSString *giftKey;
/// tag
@property(nonatomic, copy)NSArray<NSString *> *tagList;
/// 左侧标签
@property(nonatomic, copy)NSString *leftTagName;
/// 左侧标签图片
@property(nonatomic, copy)NSString *leftTagImage;
@property(nonatomic, copy)HSGiftModelSelectedBlock selectedChangedCallback;
@property(nonatomic, strong)GiftItemDetailModel *details;

@property(nonatomic, assign)BOOL isEmptyModel;
@property(nonatomic, assign)BOOL isDanmu;
/// 加载webp
- (void)loadWebp:(nullable GiftLoadImageBlock)result;
@end

NS_ASSUME_NONNULL_END
