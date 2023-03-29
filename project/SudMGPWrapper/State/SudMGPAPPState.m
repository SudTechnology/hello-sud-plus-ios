//
//  SudMGPAPPState.m
//  SudMGPWrapper
//
//  Created by kaniel on 2022/7/4.
//

#import "SudMGPAPPState.h"
#import <MJExtension/MJExtension.h>

@implementation AppCommonGameDiscoAction
@end

/// AI玩家用户信息
@implementation AIPlayerInfoModel
@end

@implementation AppCommonGameAddAIPlayersModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"aiPlayers": AIPlayerInfoModel.class};
}
@end

@implementation AppCommonGameScore
@end

@implementation AppCommonGameCreateOrderResult
@end

