//
//  EnterRoomModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "EnterRoomModel.h"
#import "RoomCmdCrossAppModel.h"

/// pk结果房间信息
@implementation PKResultRoomInfoModel
@end

/// pk结果房间信息
@implementation PKResultModel

@end

@implementation CrossAppMatchModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userList": UserIndexInfo.class};
}
@end

@implementation CrossAppRoomModel
@end

@implementation EnterRoomModel
- (NSMutableDictionary *)dicExtData {
    if (!_dicExtData) {
        _dicExtData = NSMutableDictionary.new;
    }
    return _dicExtData;
}
@end


