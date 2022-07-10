//
//  RoomCustomModel.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/4/20.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "RoomCustomModel.h"

@interface RoomCustomOptionList ()
@property(nonatomic, assign) CGFloat cellHeight;
@end

@implementation RoomCustomOptionList

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        _cellHeight = 56;
        NSString *value = self.title.localized;
        if (value.length > 0) {
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:value attributes:@{NSFontAttributeName: UIFONT_REGULAR(16)}];
            CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 72, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading context:nil];
            _cellHeight = rect.size.height + 32;
            if (_cellHeight < 56) {
                _cellHeight = 56;
            }
        }

    }
    return _cellHeight;
}

@end

@implementation RoomCustomItems
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"optionList": [RoomCustomOptionList class]
    };
}

- (NSString *)key {
    NSString *key = [self.subTitle stringByReplacingOccurrencesOfString:@"(" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@")" withString:@""];
    return key;
}

- (NSArray *)keyList {
    NSString *key = [self key];
    return [key componentsSeparatedByString:@"."];
}

- (NSString *)getCurSelectedText {
    for (RoomCustomOptionList *item in self.optionList) {
        if (item.isSeleted) {
            return item.title;
        }
    }
    return @"";
}

- (BOOL)isVolumeItem {
    if (self.optionList.count == 0) {
        return true;
    }
    return false;
}
@end

@implementation RoomCustomList
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"items": [RoomCustomItems class]
    };
}
@end

@implementation RoomCustomModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"customList": [RoomCustomList class]
    };
}

- (GameCfgModel *)getCfgModel {
    GameCfgModel *configModel = GameCfgModel.new;
    NSMutableDictionary *configMap = [NSMutableDictionary dictionaryWithDictionary:[configModel mj_keyValues]];;
    [configMap setValue:@(1) forKey:@"gameMode"];

    for (RoomCustomList *item in self.customList) {
        if ([item.name isEqualToString:@"dt_custom_game_system"]) {
            [self handleSysytemModel:item.items configMap:configMap];
        } else if ([item.name isEqualToString:@"UI"]) {
            [self handleUIModel:item.items configMap:configMap];
        } else if ([item.name isEqualToString:@"Custom"]) {
            [self handleCustomModel:item.items configMap:configMap];
        }
    }
    return [GameCfgModel mj_objectWithKeyValues:configMap];
}

- (void)handleSysytemModel:(NSArray <RoomCustomItems *> *)itemList
                 configMap:(NSMutableDictionary *)configMap {
    for (RoomCustomItems *item in itemList) {
        [configMap setValue:@(item.value) forKey:[item key]];
    }
}

- (void)handleUIModel:(NSArray <RoomCustomItems *> *)itemList
            configMap:(NSMutableDictionary *)configMap {
    NSMutableDictionary *uiMap = NSMutableDictionary.new;
    for (RoomCustomItems *item in itemList) {
        NSArray *keyList = item.keyList;
        NSMutableDictionary *hideMap = NSMutableDictionary.new;
        [hideMap setValue:@(item.value) forKey:keyList[2]];
        [uiMap setValue:hideMap forKey:keyList[1]];
    }
    [configMap setValue:uiMap forKey:@"ui"];
}

- (void)handleCustomModel:(NSArray <RoomCustomItems *> *)itemList
                configMap:(NSMutableDictionary *)configMap {
    NSMutableDictionary *uiMap = [configMap objectForKey:@"ui"];
    for (RoomCustomItems *item in itemList) {
        NSArray *keyList = item.keyList;
        NSMutableDictionary *valueMap = [uiMap objectForKey:keyList[1]];
        if (valueMap) {
            [valueMap setValue:@(item.value) forKey:keyList[2]];
        } else {
            NSMutableDictionary *hideMap = NSMutableDictionary.new;
            [hideMap setValue:@(item.value) forKey:keyList[2]];
            [uiMap setValue:hideMap forKey:keyList[1]];
        }
    }
}

@end
