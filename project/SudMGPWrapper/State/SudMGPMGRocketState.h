//
//  SudMGPMGState.h
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 通用状态-游戏
/// 参考文档： https://docs.sud.tech/zh-CN/app/Client/MGFSM/CommonStateGame.html

#pragma mark - 互动礼物<火箭>
/// 礼物配置文件(火箭)
static NSString *MG_CUSTOM_ROCKET_CONFIG = @"mg_custom_rocket_config";
/// 拥有模型列表(火箭)
static NSString *MG_CUSTOM_ROCKET_MODEL_LIST = @"mg_custom_rocket_model_list";
/// 拥有组件列表(火箭)
static NSString *MG_CUSTOM_ROCKET_COMPONENT_LIST = @"mg_custom_rocket_component_list";
/// 获取用户的信息(火箭)
static NSString *MG_CUSTOM_ROCKET_USER_INFO = @"mg_custom_rocket_user_info";
/// 订单记录列表(火箭)
static NSString *MG_CUSTOM_ROCKET_ORDER_RECORD_LIST = @"mg_custom_rocket_order_record_list";
/// 展馆内列表(火箭)
static NSString *MG_CUSTOM_ROCKET_ROOM_RECORD_LIST = @"mg_custom_rocket_room_record_list";
/// 展馆内玩家送出记录(火箭)
static NSString *MG_CUSTOM_ROCKET_USER_RECORD_LIST = @"mg_custom_rocket_user_record_list";
/// 设置默认位置(火箭)
static NSString *MG_CUSTOM_ROCKET_SET_DEFAULT_MODEL = @"mg_custom_rocket_set_default_model";
/// 动态计算一键发送价格(火箭)
static NSString *MG_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE = @"mg_custom_rocket_dynamic_fire_price";
/// 一键发送(火箭)
static NSString *MG_CUSTOM_ROCKET_FIRE_MODEL = @"mg_custom_rocket_fire_model";
/// 新组装模型(火箭)
static NSString *MG_CUSTOM_ROCKET_CREATE_MODEL = @"mg_custom_rocket_create_model";
/// 更换组件(火箭)
static NSString *MG_CUSTOM_ROCKET_REPLACE_COMPONENT = @"mg_custom_rocket_replace_component";
/// 购买组件(火箭)
static NSString *MG_CUSTOM_ROCKET_BUY_COMPONENT = @"mg_custom_rocket_buy_component";
/// 播放效果开始(火箭)
static NSString *MG_CUSTOM_ROCKET_PLAY_EFFECT_START = @"mg_custom_rocket_play_effect_start";
/// 播放效果完成(火箭)
static NSString *MG_CUSTOM_ROCKET_PLAY_EFFECT_FINISH = @"mg_custom_rocket_play_effect_finish";
/// 验证签名(火箭)
static NSString *MG_CUSTOM_ROCKET_VERIFY_SIGN = @"mg_custom_rocket_verify_sign";
/// 上传icon(火箭)
static NSString *MG_CUSTOM_ROCKET_UPLOAD_MODEL_ICON = @"mg_custom_rocket_upload_model_icon";
/// 前期准备完成(火箭)
static NSString *MG_CUSTOM_ROCKET_PREPARE_FINISH = @"mg_custom_rocket_prepare_finish";
/// 火箭主界面已展示(火箭)
static NSString *MG_CUSTOM_ROCKET_SHOW_GAME_SCENE = @"mg_custom_rocket_show_game_scene";
/// 火箭主界面已隐藏(火箭)
static NSString *MG_CUSTOM_ROCKET_HIDE_GAME_SCENE = @"mg_custom_rocket_hide_game_scene";
/// 点击锁住组件(火箭)
static NSString *MG_CUSTOM_ROCKET_CLICK_LOCK_COMPONENT = @"mg_custom_rocket_click_lock_component";
/// 火箭可点击区域
static NSString *MG_CUSTOM_ROCKET_SET_CLICK_RECT = @"mg_custom_rocket_set_click_rect";
#pragma mark - MG_CUSTOM_ROCKET_USER_INFO

@interface MGCustomRocketUserInfo : NSObject
/// 每个用户userID
@property(nonatomic, strong) NSArray <NSString *> *userIdList;
@end

#pragma mark - MG_CUSTOM_ROCKET_ORDER_RECORD_LIST

@interface MGCustomRocketOrderRecordList : NSObject
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageSize;
@end

#pragma mark - MG_CUSTOM_ROCKET_ROOM_RECORD_LIST

@interface MGCustomRocketRoomRecordList : NSObject
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageSize;
@end

#pragma mark - MG_CUSTOM_ROCKET_USER_RECORD_LIST

@interface MGCustomRocketUserRecordList : NSObject
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, assign) NSInteger pageSize;
@property(nonatomic, strong) NSString *userId;
@end

#pragma mark - MG_CUSTOM_ROCKET_SET_DEFAULT_MODEL

@interface MGCustomRocketSetDefaultSeat : NSObject
@property(nonatomic, strong) NSString *modelId;
@end

@interface MGCustomRocketDynamicFirePriceComponentListItem : NSObject
@property(nonatomic, strong) NSString *itemId;
@end

#pragma mark - MG_CUSTOM_ROCKET_DYNAMIC_FIRE_PRICE

@interface MGCustomRocketDynamicFirePrice : NSObject
@property(nonatomic, strong) NSArray <MGCustomRocketDynamicFirePriceComponentListItem *> *componentList;
@end


#pragma mark - MG_CUSTOM_ROCKET_FIRE_MODEL

@interface MGCustomRocketFireModelComponentListItem : NSObject
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, strong) NSString *itemId;
@end

@interface MGCustomRocketFireModel : NSObject
@property(nonatomic, strong) NSArray <MGCustomRocketFireModelComponentListItem *> *componentList;
@end


#pragma mark - MG_CUSTOM_ROCKET_CREATE_MODEL

@interface MGCustomRocketCreateModelComponentListItem : NSObject
@property(nonatomic, strong) NSString *itemId;
@end


@interface MGCustomRocketCreateModel : NSObject
@property(nonatomic, strong) NSArray <MGCustomRocketCreateModelComponentListItem *> *componentList;
@end


#pragma mark - MG_CUSTOM_ROCKET_REPLACE_COMPONENT

@interface MGCustomRocketReplaceModel : NSObject
@property(nonatomic, strong) NSString *modelId;
@property(nonatomic, strong) NSArray <MGCustomRocketCreateModelComponentListItem *> *componentList;
@end

#pragma mark - MG_CUSTOM_ROCKET_BUY_COMPONENT

@interface MGCustomRocketBuyModelComponentListItem : NSObject
@property(nonatomic, strong) NSString *componentId;
@property(nonatomic, strong) NSString *value;
@end

@interface MGCustomRocketBuyModel : NSObject
@property(nonatomic, strong) NSArray <MGCustomRocketBuyModelComponentListItem *> *componentList;
@end

#pragma mark - MG_CUSTOM_ROCKET_VERIFY_SIGN

@interface MGCustomRocketVerifySign : NSObject
@property(nonatomic, strong) NSString *sign;
@end

#pragma mark - MG_CUSTOM_ROCKET_UPLOAD_MODEL_ICON

@interface MGCustomRocketUploadModelIcon : NSObject
/// 图片base64数据
@property(nonatomic, strong) NSString *data;
@end

#pragma mark - MG_CUSTOM_ROCKET_CLICK_LOCK_COMPONENT
@interface MGCustomRocketClickLockComponent : NSObject
/// 组件类型
@property(nonatomic, assign) NSInteger type;
/// 组件ID
@property(nonatomic, strong) NSString *componentId;
@end

#pragma mark - MG_CUSTOM_ROCKET_SET_CLICK_RECT
@interface GameSetClickRectItem : NSObject
@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@end

@interface MGCustomGameSetClickRect : NSObject
/// 组件类型
@property(nonatomic, assign) NSInteger type;
/// 组件ID
@property(nonatomic, strong) NSArray <GameSetClickRectItem *> *list;
@end


NS_ASSUME_NONNULL_END
