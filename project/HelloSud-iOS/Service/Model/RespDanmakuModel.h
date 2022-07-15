//
//  RespDanmakuModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/16.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "BaseRespModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 弹幕动效类型
typedef NS_ENUM(NSInteger, DanmakuEffectModelShowType) {
    DanmakuEffectModelShowTypeCall = 0,// 召唤
    DanmakuEffectModelShowTypeJoin = 1// 加入战队
};

/// 加入阵队数据模型
@interface DanmakuJoinTeamModel : BaseModel
/// 名称
@property(nonatomic, strong) NSString *name;
/// 按钮图片
@property(nonatomic, strong) NSString *buttonPic;
/// 文本内容(弹幕使用)
@property(nonatomic, strong) NSString *content;

@end

/// 召唤数据模型
@interface DanmakuCallWarcraftModel : BaseModel
/// 召唤方式（1弹幕，2礼物）
@property(nonatomic, assign) NSInteger callMode;
/// 魔兽类型（1弹幕魔兽，2初级魔兽，3精英魔兽，4远古魔兽）
@property(nonatomic, assign) NSInteger warcraftType;
/// 礼物id
@property(nonatomic, assign) NSInteger giftId;
/// 礼物数量
@property(nonatomic, assign) NSInteger giftAmount;
/// 礼物图片
@property(nonatomic, strong) NSString *giftUrl;
/// 动效图
@property(nonatomic, strong) NSString *animationUrl;
/// 礼物价格
@property(nonatomic, assign) NSInteger giftPrice;
/// 名称
@property(nonatomic, strong) NSString *name;
/// 标题
@property(nonatomic, strong) NSString *title;
/// 标题色值
@property(nonatomic, strong) NSString *titleColor;
/// 文本内容(弹幕使用)
@property(nonatomic, strong) NSString *content;
/// 魔兽图片列表
@property(nonatomic, strong) NSArray <NSString *> *warcraftImageList;

#pragma mark custom
/// 弹幕快捷输入cell动效展示类型(加入战队、召唤)
@property(nonatomic, assign) DanmakuEffectModelShowType effectShowType;
@property(nonatomic, strong) NSArray<DanmakuJoinTeamModel *> *joinTeamList;
@property(nonatomic, assign, readonly) CGFloat cellWidth;
@end

/// 弹幕列表
@interface RespDanmakuListModel : BaseRespModel
@property(nonatomic, strong) NSArray<DanmakuCallWarcraftModel *> *callWarcraftInfoList;
@property(nonatomic, strong) NSArray<DanmakuJoinTeamModel *> *joinTeamList;
@property(nonatomic, strong) NSString *guideText;
@end

NS_ASSUME_NONNULL_END
