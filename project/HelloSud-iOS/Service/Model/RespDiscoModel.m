//
//  RespDiscoModel.m
//  HelloSud-iOS
//
//  Created by kaniel_mac on 2022/7/7.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RespDiscoModel.h"

@implementation DiscoContributionModel
+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"rank"];
}
@end

@implementation RespDiscoInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dancingMenu": [DiscoMenuModel class],
            @"contribution": [DiscoContributionModel class]
    };
}
@end

@implementation RespDiscoBecomeDJModel
@end

/// 机器人信息model
@implementation RotbotInfoModel
@end

/// 拉取机器人列表数据模型
@implementation RespDiscoRobotListModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"robotList":RotbotInfoModel.class};
}
@end
