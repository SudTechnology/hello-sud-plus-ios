//
//  GameListModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/25.
//

#import "GameListModel.h"

@implementation HSGameModeModel
@end

@implementation HSGameItem
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"gameModeList": [HSGameModeModel class]};
}

@end

@implementation HSSceneModel
- (NSString *)headIdentifier {

    switch (self.sceneId) {
        case SceneTypeDanmaku:
        case SceneTypeDisco:
        case SceneTypeVertical:
            return @"HomeHeaderFullReusableView";
        default:
            return @"HomeHeaderReusableView";
    }
}

- (NSString *)reuseCell {
    switch (self.sceneId) {
        case SceneTypeDanmaku:
        case SceneTypeDisco:
        case SceneTypeLeague:
            return @"GameItemFullCollectionViewCell";
        default:
            return @"GameItemCollectionViewCell";
    }
}
@end

@implementation GameListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"gameList": [HSGameItem class],
             @"sceneList": [HSSceneModel class]
    };
}
@end
