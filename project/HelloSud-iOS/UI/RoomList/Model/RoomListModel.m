//
//  RoomListModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "RoomListModel.h"

@implementation HSRoomInfoList

@end

@implementation RoomListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"roomInfoList": [HSRoomInfoList class]
    };
}

@end
