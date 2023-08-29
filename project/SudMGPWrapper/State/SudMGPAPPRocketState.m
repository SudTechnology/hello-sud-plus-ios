//
//  SudMGPAPPState.m
//  SudMGPWrapper
//
//  Created by kaniel on 2022/7/4.
//

#import "SudMGPAPPRocketState.h"
#import <MJExtension/MJExtension.h>


@implementation RocketComponentItemModel
@end

@implementation RocketHeadItemModel
@end

@implementation RocketExtraItemModel
@end

@implementation AppCustomRocketConfigModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketComponentItemModel.class,
            @"headList": RocketHeadItemModel.class,
            @"extraList": RocketExtraItemModel.class};
}
@end

@implementation RocketModelComponentItemModel
@end

@implementation RocketModelItemModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketModelComponentItemModel.class};
}
@end

@implementation AppCustomRocketModelListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": RocketModelItemModel.class};
}
@end

@implementation RocketComponentListItemModel
@end

@implementation AppCustomRocketComponentListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"defaultList": RocketComponentListItemModel.class,
            @"list":RocketComponentListItemModel.class};
}
@end

@implementation RocketUserInfoItemModel
@end

@implementation AppCustomRocketUserInfoModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userList": RocketUserInfoItemModel.class};
}
@end

@implementation RocketOrderRecordListItemModel
@end

@implementation AppCustomRocketOrderRecordListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": RocketOrderRecordListItemModel.class};
}
@end

@implementation RocketRoomRecordListItemModel
@end

@implementation AppCustomRocketRoomRecordListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": RocketRoomRecordListItemModel.class};
}
@end

@implementation RocketUserRecordListItemModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketModelComponentItemModel.class};
}
@end

@implementation InteractConfigModel

@end

@implementation AppCustomRocketUserRecordListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list": RocketUserRecordListItemModel.class};
}
@end

@implementation RocketSetDefaultSeatModel
@end

@implementation AppCustomRocketSetDefaultSeatModel
@end

@implementation RocketDynamicFirePriceModel
@end

@implementation AppCustomRocketDynamicFirePriceModel
@end

@implementation RocketCreateDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketModelComponentItemModel.class};
}
@end

@implementation AppCustomRocketCreateModel
@end

@implementation RocketCreateReplaceDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketModelComponentItemModel.class};
}
@end

@implementation AppCustomRocketReplaceComponentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketComponentListItemModel.class};
}
@end

@implementation RocketCreateBuyDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketComponentListItemModel.class};
}
@end

@implementation AppCustomRocketBuyComponentModel
@end

@implementation RocketPlayModelListItem
@end

@implementation AppCustomRocketPlayModelListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketPlayModelListItem.class};
}
@end

@implementation RocketVerifySignDataModel
@end

@implementation AppCustomRocketVerifySignModel
@end

@implementation AppCustomRocketFireModel
@end

@implementation AppCustomRocketUnlockComponent
@end

@implementation AppCustomRocketSaveSignColorData
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"componentList": RocketComponentListItemModel.class};
}
@end

@implementation AppCustomRocketSaveSignColorModel
@end


