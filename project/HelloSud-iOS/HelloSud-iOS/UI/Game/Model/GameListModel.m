//
//  GameListModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "GameListModel.h"

@implementation HSGameList

@end

@implementation HSSceneList

@end

@implementation GameListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"gameList": [HSGameList class],
             @"sceneList": [HSSceneList class]
    };
}
@end
