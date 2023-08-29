//
//  SudMGPAPPState2.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/19.
//

#pragma mark - 互动礼物<火箭>

/// 礼物配置文件(火箭)
static NSString *APP_CUSTOM_ROCKET_CONFIG = @"app_custom_rocket_config";
/// 拥有模型列表(火箭)
static NSString *APP_CUSTOM_ROCKET_MODEL_LIST = @"app_custom_rocket_model_list";
/// 拥有组件列表(火箭)
static NSString *APP_CUSTOM_ROCKET_COMPONENT_LIST = @"app_custom_rocket_component_list";
/// 获取用户的信息(火箭)
static NSString *APP_CUSTOM_ROCKET_USER_INFO = @"app_custom_rocket_user_info";
/// app推送主播信息(火箭)
static NSString *APP_CUSTOM_ROCKET_NEW_USER_INFO = @"app_custom_rocket_new_user_info";
/// 订单记录列表(火箭)
static NSString *APP_CUSTOM_ROCKET_ORDER_RECORD_LIST = @"app_custom_rocket_order_record_list";
/// 展馆内列表(火箭)
static NSString *APP_CUSTOM_ROCKET_ROOM_RECORD_LIST = @"app_custom_rocket_room_record_list";
/// 展馆内玩家送出记录(火箭)
static NSString *APP_CUSTOM_ROCKET_USER_RECORD_LIST = @"app_custom_rocket_user_record_list";
/// 设置默认位置(火箭)
static NSString *APP_CUSTOM_ROCKET_SET_DEFAULT_MODEL = @"app_custom_rocket_set_default_model";
/// 动态计算一键发送价格(火箭)
static NSString *APP_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE = @"app_custom_rocket_dynamic_fire_price";
/// 一键发送(火箭)
static NSString *APP_CUSTOM_ROCKET_FIRE_MODEL = @"app_custom_rocket_fire_model";
/// 新组装模型(火箭)
static NSString *APP_CUSTOM_ROCKET_CREATE_MODEL = @"app_custom_rocket_create_model";
/// 更换组件(火箭)
static NSString *APP_CUSTOM_ROCKET_REPLACE_COMPONENT = @"app_custom_rocket_replace_component";
/// 购买组件(火箭)
static NSString *APP_CUSTOM_ROCKET_BUY_COMPONENT = @"app_custom_rocket_buy_component";
/// app推送播放模型(火箭)
static NSString *APP_CUSTOM_ROCKET_PLAY_MODEL_LIST = @"app_custom_rocket_play_model_list";
/// 验证签名合规(火箭)
static NSString *APP_CUSTOM_ROCKET_VERIFY_SIGN = @"app_custom_rocket_verify_sign";
/// app主动调起游戏显示(火箭)
static NSString *APP_CUSTOM_ROCKET_SHOW_GAME_SCENE = @"app_custom_rocket_show_game_scene";
/// app主动调起游戏隐藏(火箭)
static NSString *APP_CUSTOM_ROCKET_HIDE_GAME_SCENE = @"app_custom_rocket_hide_game_scene";
/// app推送解锁组件（火箭)
static NSString *APP_CUSTOM_ROCKET_UNLOCK_COMPONENT = @"app_custom_rocket_unlock_component";
/// app推送关闭火箭播放效果(火箭)
static NSString *APP_CUSTOM_ROCKET_CLOSE_PLAY_EFFECT = @"app_custom_rocket_close_play_effect";
/// app推送火箭效果飞行点击(火箭)
static NSString *APP_CUSTOM_ROCKET_FLY_CLICK = @"app_custom_rocket_fly_click";
/// 颜色和签名自定义改到装配间的模式，保存颜色或签名回调
static NSString *APP_CUSTOM_ROCKET_SAVE_SIGN_COLOR = @"app_custom_rocket_save_sign_color";
#pragma mark - 互动礼物火箭 model

/// 火箭组件
@interface RocketComponentItemModel : NSObject
/// 1套装，2主仓，3尾翼
@property(nonatomic, assign) NSInteger type;
/// 组件Id
@property(nonatomic, strong) NSString *componentId;
/// 价格 暂时不考虑小数
@property(nonatomic, assign) CGFloat price;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 组件的ID
@property(nonatomic, assign) NSInteger id;
/// 锁：0不锁 1锁
@property(nonatomic, assign) NSInteger isLock;
/// 展示：0不展示 1展示
@property(nonatomic, assign) NSInteger isShow;
/// 显示名称(商城+装配间+购买记录+...)
@property(nonatomic, strong) NSString *name;
/// 图片ID
@property(nonatomic, strong) NSString *imageId;
@end

/// 火箭头像配置
@interface RocketHeadItemModel : NSObject
/// 4头像(商城+装配间+购买记录+...)
@property(nonatomic, assign) NSInteger type;
/// 组件ID
@property(nonatomic, strong) NSString *componentId;
/// 价格 暂时不考虑小数
@property(nonatomic, assign) CGFloat price;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 显示名称
@property(nonatomic, strong) NSString *name;
/// 用户的userID
@property(nonatomic, strong) NSString *userId;
/// 昵称
@property(nonatomic, strong) NSString *nickname;
/// 性别 0:男 1:女
@property(nonatomic, assign) NSInteger sex;
/// 头像URL
@property(nonatomic, strong) NSString *url;
@end

/// 火箭专属配置
@interface RocketExtraItemModel : NSObject
/// 5签名，6颜色
@property(nonatomic, assign) NSInteger type;
/// 组件ID
@property(nonatomic, strong) NSString *componentId;
/// 显示名称(商城+装配间+购买记录+...)
@property(nonatomic, strong) NSString *name;
/// 价格
@property(nonatomic, assign) CGFloat price;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 专属签名需花费99999积分,7天过期
@property(nonatomic, strong) NSString *desc;
@end

/// APP_CUSTOM_ROCKET_CONFIG
@interface AppCustomRocketConfigModel : NSObject
/// 最大机位
@property(nonatomic, assign) NSInteger maxSeat;
/// 发射的静态价格
@property(nonatomic, assign) CGFloat firePrice;
/// 服务器时间戳，单位：秒
@property(nonatomic, assign) NSTimeInterval serverTime;
/// 发射价格是否动态开关 0:静态 1动态
@property(nonatomic, assign) NSInteger isDynamicPrice;
/// 玩法介绍
@property(nonatomic, strong) NSString *gameIntroduce;
/// 货币单位 金币
@property(nonatomic, strong) NSString *monetaryUnit;
/// 组件列表
@property(nonatomic, strong) NSArray<RocketComponentItemModel *> *componentList;
/// 过滤不显示的模块(默认是为空)
/// "mainModel",               //装配间
/// "shopModel",               //商城
/// "roomModel",               //展馆
/// "helpModel",               //购买记录+规则介绍
/// "recordModel",             //购买记录
/// "introduceModel",          //规则介绍
@property(nonatomic, strong) NSArray <NSString *> *filterModel;
/// 过滤不显示的页面(默认是为空)
/// "rocketLayer",               //套装
/// "bodyLayer",                 //主仓
/// "wingLayer",                 //尾翼
/// "headLayer",                 //头像
/// "signLayer",                 //签名
/// "colorLayer",                //颜色
@property(nonatomic, strong) NSArray <NSString *> *filterLayer;
/// 头像配置
@property(nonatomic, strong) NSArray <RocketHeadItemModel *> *headList;
/// 专属配置
@property(nonatomic, strong) NSArray <RocketExtraItemModel *> *extraList;
@end

/// 火箭模型组件item
@interface RocketModelComponentItemModel : NSObject
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *itemId;
@property(nonatomic, strong) NSString *value;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期时间戳：单位是秒
@property(nonatomic, assign) NSInteger validTime;
@end

/// 火箭模型item
@interface RocketModelItemModel : NSObject
/// 座位ID
@property(nonatomic, strong) NSString *modelId;
/// 可以换装：0不可以 1可以
@property(nonatomic, assign) NSInteger isAvatar;
/// 服务标识 全服
@property(nonatomic, strong) NSString *serviceFlag;
@property(nonatomic, strong) NSArray<RocketModelComponentItemModel *> *componentList;
@end

/// APP_CUSTOM_ROCKET_MODEL_LIST
@interface AppCustomRocketModelListModel : NSObject
/// 默认座位
@property(nonatomic, strong) NSString *defaultModelId;
/// 截图：0不截图 1截图(app上传失败或者过期时,被动截图)
@property(nonatomic, assign) NSInteger isScreenshot;
@property(nonatomic, strong) NSArray<RocketModelItemModel *> *list;
@end


@interface RocketComponentListItemModel : NSObject
/// 唯一标识
@property(nonatomic, strong) NSString *itemId;
/// 1套装，2主仓，3尾翼
@property(nonatomic, assign) NSInteger type;
/// (1套装，2主仓，3尾翼 配置数据的ID)
@property(nonatomic, strong) NSString *value;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期时间戳：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 有效期时间戳：单位是秒
@property(nonatomic, assign) NSInteger date;
/// 可选，字段存在显示内容，字段不存在显示时间或者永久
@property(nonatomic, strong) NSString *extra;
@end

/// APP_CUSTOM_ROCKET_COMPONENT_LIST
@interface AppCustomRocketComponentListModel : NSObject
@property(nonatomic, strong) NSArray <RocketComponentListItemModel *> *defaultList;
@property(nonatomic, strong) NSArray <RocketComponentListItemModel *> *list;
@end

@interface RocketUserInfoItemModel : NSObject
/// 用户的userID
@property(nonatomic, strong) NSString *userId;
/// 昵称
@property(nonatomic, strong) NSString *nickname;
/// 性别 0:男 1:女
@property(nonatomic, assign) NSInteger sex;
/// 头像URL
@property(nonatomic, strong) NSString *url;
@end

/// APP_CUSTOM_ROCKET_USER_INFO
@interface AppCustomRocketUserInfoModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong) NSArray <RocketUserInfoItemModel *> *userList;
@end

@interface RocketOrderRecordListItemModel : NSObject
/// 1套装，2主仓，3尾翼
@property(nonatomic, assign) NSInteger type;
/// (1套装，2主仓，3尾翼 配置数据的ID)
@property(nonatomic, strong) NSString *value;
/// 永久：0非永久 1永久
@property(nonatomic, assign) NSInteger isForever;
/// 有效期时间戳：单位是秒
@property(nonatomic, assign) NSInteger validTime;
/// 1970年1月1日开始
@property(nonatomic, assign) NSInteger date;
@end

/// APP_CUSTOM_ROCKET_ORDER_RECORD_LIST
@interface AppCustomRocketOrderRecordListModel : NSObject
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, strong) NSArray <RocketOrderRecordListItemModel *> *list;
@end

@interface RocketRoomRecordListItemModel : NSObject
/// 送礼人
@property(nonatomic, strong) RocketUserInfoItemModel *fromUser;
/// 火箭数量
@property(nonatomic, assign) NSInteger number;
@end

/// APP_CUSTOM_ROCKET_ROOM_RECORD_LIST
@interface AppCustomRocketRoomRecordListModel : NSObject
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageCount;
@property(nonatomic, strong) NSArray <RocketRoomRecordListItemModel *> *list;
@end


@interface RocketUserRecordListItemModel : NSObject
/// 送礼人
@property(nonatomic, strong) RocketUserInfoItemModel *toUser;
/// 火箭数量
@property(nonatomic, assign) NSInteger number;
/// 时间
@property(nonatomic, assign) NSInteger date;
@property(nonatomic, strong) NSArray <RocketModelComponentItemModel *> *componentList;
@end

/// APP_CUSTOM_ROCKET_USER_RECORD_LIST 展馆内玩家送出记录
@interface AppCustomRocketUserRecordListModel : NSObject
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageCount;
/// 送礼人
@property(nonatomic, strong) RocketUserInfoItemModel *fromUser;
@property(nonatomic, strong) NSArray <RocketUserRecordListItemModel *> *list;
@end

@interface RocketSetDefaultSeatModel : NSObject
@property(nonatomic, strong) NSString *modelId;
@end

/// APP_CUSTOM_ROCKET_SET_DEFAULT_MODEL 设置默认位置
@interface AppCustomRocketSetDefaultSeatModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong) RocketSetDefaultSeatModel *data;
@end

@interface RocketDynamicFirePriceModel : NSObject
@property(nonatomic, assign) CGFloat price;
@end

/// APP_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE 动态计算一键发送价格
@interface AppCustomRocketDynamicFirePriceModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong) RocketDynamicFirePriceModel *data;
@end

@interface RocketCreateDataModel : NSObject
/// 座位ID
@property(nonatomic, strong) NSString *modelId;
/// 可以换装：0不可以 1可以
@property(nonatomic, assign) NSInteger isAvatar;
/// 服务标识
@property(nonatomic, strong) NSString *serviceFlag;
@property(nonatomic, strong) NSArray <RocketModelComponentItemModel *> *componentList;
@end

/// APP_CUSTOM_ROCKET_CREATE_MODEL 新组装模型
@interface AppCustomRocketCreateModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong) RocketCreateDataModel *data;
@end

@interface RocketCreateReplaceDataModel : NSObject
/// 座位ID
@property(nonatomic, strong) NSString *modelId;
@property(nonatomic, strong) NSArray <RocketModelComponentItemModel *> *componentList;
@end

/// APP_CUSTOM_ROCKET_REPLACE_COMPONENT 更换组件
@interface AppCustomRocketReplaceComponentModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong) RocketCreateReplaceDataModel *data;
@end

@interface RocketCreateBuyDataModel : NSObject
@property(nonatomic, strong) NSArray <RocketComponentListItemModel *> *componentList;
@end

/// APP_CUSTOM_ROCKET_BUY_COMPONENT 购买组件
@interface AppCustomRocketBuyComponentModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong) RocketCreateBuyDataModel *data;
@end

@interface RocketPlayModelListItem : NSObject
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *value;
@end

@interface InteractConfigModel : NSObject
@property(nonatomic, strong)NSString * interactivePlay;
@property(nonatomic, strong)NSArray<NSString *> *gear;
@property(nonatomic, strong)NSString *nicknameTips;
@property(nonatomic, strong)NSString *uiSwitche;
@property(nonatomic, strong)NSString *guide;

@end

/// APP_CUSTOM_ROCKET_PLAY_MODEL_LIST app播放火箭发射动效
@interface AppCustomRocketPlayModelListModel : NSObject
@property(nonatomic, strong) NSString *orderId;
@property(nonatomic, strong) InteractConfigModel *interactConfig;
@property(nonatomic, strong) NSArray <RocketPlayModelListItem *> *componentList;
@end

@interface RocketVerifySignDataModel : NSObject
@property(nonatomic, strong) NSString *sign;
@end

/// APP_CUSTOM_ROCKET_VERIFY_SIGN 验证签名合规
@interface AppCustomRocketVerifySignModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong) RocketVerifySignDataModel *data;
@end

/// APP_CUSTOM_ROCKET_FIRE_MODEL 一键发送(火箭)
@interface AppCustomRocketFireModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@end

/// app推送解锁组件（火箭) APP_CUSTOM_ROCKET_UNLOCK_COMPONENT
@interface AppCustomRocketUnlockComponent : NSObject
/// 组件类型
@property(nonatomic, assign) NSInteger type;
/// 组件ID
@property(nonatomic, strong) NSString *componentId;
@end

@interface AppCustomRocketSaveSignColorData : NSObject
@property(nonatomic, strong) NSArray <RocketComponentListItemModel *> *componentList;
@end

@interface AppCustomRocketSaveSignColorModel : NSObject
/// 0: 请求成功，1：请求失败
@property(nonatomic, assign) NSInteger resultCode;
/// 错误描述
@property(nonatomic, strong) NSString *error;
@property(nonatomic, strong)AppCustomRocketSaveSignColorData *data;
@end

