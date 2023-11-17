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

#pragma mark - 3d语聊房
/// 请求房间数据
static NSString *MG_CUSTOM_CR_ROOM_INIT_DATA = @"mg_custom_cr_room_init_data";
/// 点击主播位或老板位通知
static NSString *MG_CUSTOM_CR_CLICK_SEAT = @"mg_custom_cr_click_seat";

#pragma mark - MG_CUSTOM_CR_ROOM_INIT_DATA

@interface MGCustomCrRoomInitData : NSObject
@end

#pragma mark - MG_CUSTOM_CR_CLICK_SEAT

@interface MGCustomCrClickSeat : NSObject
/// 0~4一共5个麦位，0为老板位，1~4为四个面主播位
@property(nonatomic, assign) NSInteger seatIndex;
@end

NS_ASSUME_NONNULL_END
