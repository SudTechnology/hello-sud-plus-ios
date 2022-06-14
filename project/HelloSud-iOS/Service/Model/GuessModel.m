//
//  GuessModel.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/6/10.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "GuessModel.h"

@implementation MoreGuessGameModel
@end

@implementation RespMoreGuessModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"quizGameInfoList": [MoreGuessGameModel class]};
}
@end

@implementation GuessPlayerModel
@end

@implementation RespGuessPlayerListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"playerList": [GuessPlayerModel class]};
}
@end

