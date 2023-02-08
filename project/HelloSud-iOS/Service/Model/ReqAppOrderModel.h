//
//  ReqAppOrderModel.h
//  HelloSud-iOS
//
//  Created by kaniel on 2023/1/16.
//  Copyright © 2023 Sud.Tech (https://sud.tech). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReqAppOrderModel : NSObject
@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, assign) int64_t gameId;
/// 触发的行为动作，比如打赏，购买等
@property(nonatomic, strong) NSString *cmd;
/// 付费用户uid
@property(nonatomic, strong) NSString *fromUid;
/// 目标用户uid
@property(nonatomic, strong) NSString *toUid;
/// 所属的游戏价值
@property(nonatomic, assign) NSInteger value;
/// 扩展数据 json 字符串, 特殊可选
@property(nonatomic, strong) NSString *payload;
@end

NS_ASSUME_NONNULL_END
