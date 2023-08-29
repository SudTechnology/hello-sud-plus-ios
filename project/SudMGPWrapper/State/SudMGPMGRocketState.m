//
//  SudMGPMGState.m
//  HelloSud-iOS
//
// Copyright © Sud.Tech (https://sud.tech)
//
//  Created by Mary on 2022/2/18.
//

#import "SudMGPMGRocketState.h"

@implementation MGCustomRocketUserInfo
@end

@implementation MGCustomRocketOrderRecordList
@end

@implementation MGCustomRocketRoomRecordList
@end

@implementation MGCustomRocketUserRecordList
@end

@implementation MGCustomRocketSetDefaultSeat
@end

@implementation MGCustomRocketDynamicFirePriceComponentListItem
@end

@implementation MGCustomRocketDynamicFirePrice
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": MGCustomRocketDynamicFirePriceComponentListItem.class};
}
@end

@implementation MGCustomRocketFireModelComponentListItem
@end

@implementation MGCustomRocketFireModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": MGCustomRocketFireModelComponentListItem.class};
}
@end

@implementation MGCustomRocketCreateModelComponentListItem
@end

@implementation MGCustomRocketCreateModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": MGCustomRocketCreateModelComponentListItem.class};
}
@end

@implementation MGCustomRocketReplaceModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": MGCustomRocketCreateModelComponentListItem.class};
}
@end

@implementation MGCustomRocketBuyModelComponentListItem
@end

@implementation MGCustomRocketBuyModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": MGCustomRocketBuyModelComponentListItem.class};
}
@end

@implementation MGCustomRocketVerifySign
@end

@implementation MGCustomRocketUploadModelIcon
@end

@implementation MGCustomRocketClickLockComponent
@end

@implementation GameSetClickRectItem
@end

@implementation MGCustomRocketFlyEnd
@end

@implementation MGCustomGameSetClickRect
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": GameSetClickRectItem.class};
}
@end

@implementation MGCustomRocketSaveSignColorModel : NSObject
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": MGCustomRocketBuyModelComponentListItem.class};
}
@end
