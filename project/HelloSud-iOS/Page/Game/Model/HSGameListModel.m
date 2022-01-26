//
//  HSGameListModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "HSGameListModel.h"

@implementation HSGameList

@end

@implementation HSSceneList

@end

@implementation HSGameListData
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"gameList": [HSGameList class],
             @"sceneList": [HSSceneList class]
    };
}

@end

@implementation HSGameListModel

@end
