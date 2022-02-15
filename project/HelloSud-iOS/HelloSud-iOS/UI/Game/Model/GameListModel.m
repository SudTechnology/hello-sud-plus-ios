//
//  GameListModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "GameListModel.h"

@implementation HSGameItem

@end

@implementation HSSceneModel

@end

@implementation GameListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"gameList": [HSGameItem class],
             @"sceneList": [HSSceneModel class]
    };
}
@end
