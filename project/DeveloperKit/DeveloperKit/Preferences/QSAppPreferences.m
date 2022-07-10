//
//  QSAppPreferences.m
//  QuickStart
//
//  Created by kaniel on 2022/5/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "QSAppPreferences.h"

@interface QSAppPreferences()
/// 游戏列表
@property(nonatomic, strong)NSArray<QSGameItemModel *> *arrGameList;
@end

@implementation QSAppPreferences
+ (instancetype)shared {
    static QSAppPreferences *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = QSAppPreferences.new;
        g_manager.currentUserID = [NSString stringWithFormat:@"%@", @(arc4random())];
    });
    return g_manager;
}


/// 读取游戏列表
- (NSArray<QSGameItemModel *> *)readGameList {
    if (self.arrGameList) {
        return self.arrGameList;
    }
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"sud_game" ofType:@"json" inDirectory:@"Res"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *arrGame = [QSGameItemModel mj_objectArrayWithKeyValuesArray:jsonStr];
    self.arrGameList = arrGame;
    return self.arrGameList;
}
@end
