//
//  SudAdItemModel.m
//  HelloSudPlus
//
//  Created by kaniel on 9/17/25.
//  Copyright © 2025 Sud.Tech (https://sud.tech). All rights reserved.
//

#import "SudAdItemModel.h"
#import "SudRtWrapper.h"
#import "SudRtWrapperManager.h"


#define NTF_GAME_LOAD_FINISHED @"ntf_game_load_finished"

@implementation SudAdVideoItem
@end

// 游戏
@implementation SudAdGameItem
@end

@interface SudAdItemModel()<SudRtWrapperCommandListener>
@property(nonatomic, weak)SudRtWrapper *rt;

@property(nonatomic, strong)void(^completedBlock)(UIView *gameView);
@property(nonatomic, assign)NSInteger userNeedToPlayState;
@property(nonatomic, assign)NSInteger userNeedToRunState;
@end

@implementation SudAdItemModel

-(void)dealloc {
    NSLog(@"SudAdItemModel dealloc");
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onGameLoadFinishedNtf:) name:NTF_GAME_LOAD_FINISHED object:nil];
    }
    return self;
}

- (void)onGameLoadFinishedNtf:(NSNotification *)ntf {
    NSDictionary *userInfo = ntf.userInfo;
    NSInteger lastIndex = [userInfo[@"lastIndex"]integerValue];
    if (self.index == lastIndex + 1) {
        DDLogDebug(@"onGameLoadFinishedNtf:%@", userInfo);
        [self preLoad];
    }
}

- (void)preLoad {
    
    DDLogDebug(@"preLoad:%@", self.tag);
    if (self.adType == SudAdItemModelAdTypeGame) {
        
        if (!_rt) {
            _userNeedToPlayState = -1;
            SudRtWrapper *rt = [[SudRtWrapper alloc]init];
            [SudRtWrapperManager.shared addRt:rt];
            rt.userId = AppService.shared.loginUserID;
            rt.commandListener = self;
            _rt = rt;
            if (self.cacheGameView) {
                [self.cacheGameView addSubview:rt.gameView];
                [rt.gameView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.top.bottom.trailing.equalTo(@0);
                }];
            }
            WeakSelf
            
            SudRtGameInfo *gameInfo = [[SudRtGameInfo alloc]init];
            gameInfo.version = self.gameInfo.version;
            gameInfo.url = self.gameInfo.url;
            gameInfo.gameId = self.gameInfo.gameId;
            gameInfo.gameHash = self.gameInfo.gameHash ?: @"";
            gameInfo.gameTag = self.tag;
            gameInfo.code = self.code;
            [self.rt loadGameWithGameInfo:gameInfo onUpdatedGameViewBlock:^(UIView * _Nonnull gameView) {
                DDLogDebug(@"preLoad onUpdatedGameViewBlock gameView:%@, gameTag:%@", gameView, gameInfo.gameTag);
            } completion:^(NSError * _Nonnull error) {
                DDLogDebug(@"preLoad loadGameWithGameInfo finished:%@ gameId:%@, gameTag:%@", error, gameInfo.gameId, gameInfo.gameTag);
                [weakSelf handleLoadGameCompleted];
                if (error) {
                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                }
            }];
        }
        
    }
}

- (void)handleLoadGameCompleted {
    self.isLoaded = YES;
    [self handleShowGameView];
    [self checkNeedToPlayGame];
    [self checkNeedToRunGame];
    DDLogDebug(@"handleLoadGameCompleted:%@", @(self.index));
    [[NSNotificationCenter defaultCenter]postNotificationName:NTF_GAME_LOAD_FINISHED object:nil userInfo:@{@"lastIndex":@(self.index)}];
}


- (void)loadGame:(void(^)(UIView *gameView))completed {
    self.completedBlock = completed;
    if (_isLoaded) {
        self.completedBlock(self.rt.gameView);
        self.completedBlock = nil;
    }
}

- (void)requestShowGameView {
    [self handleShowGameView];
    if (_isLoaded) {
//        [self handleShowGameView];
    } else {
        [self preLoad];
    }
    
}

- (void)handleShowGameView {
    if (self.delegate) {
        [self.delegate onShowGameView:self.rt.gameView];
    }
}

- (void)checkNeedToPlayGame {
    if (!self.isLoaded) {
        return;
    }
    if (self.userNeedToPlayState == 1) {
        [self.rt startPlayGame];
    }  else if (self.userNeedToPlayState == 2) {
        [self.rt stopPlayGame];
    }
}

- (void)checkNeedToRunGame {
    if (!self.isLoaded) {
        return;
    }
    if (self.userNeedToRunState == 1) {
        [self.rt startGame];
    } else {
        [self.rt stopGame];
    }
}

- (void)playGame {
    self.userNeedToPlayState = 1;
    [self checkNeedToPlayGame];
}

- (void)stopGame {
    self.userNeedToPlayState = 2;
    [self checkNeedToPlayGame];
}

- (void)startRunGame {
    self.userNeedToRunState = 1;
    [self checkNeedToRunGame];
}

- (void)stopRunGame {
    self.userNeedToRunState = 2;
    [self checkNeedToRunGame];
}

- (void)destroyGame {
    WeakSelf
    DDLogDebug(@"rt destroyGame begin:%@", self.tag);
    [self.rt destroyGame:nil];
    [SudRtWrapperManager.shared removeRt:self.rt];
}

- (void)onCommand:(NSString *)state
         dataJson:(NSString *)dataJson
          success:(void(^)(NSString *dataJson))success
             fail:(void(^)(NSString *error))fail {
    DDLogDebug(@"onCommand:%@, dataJson:%@", state, dataJson);
    if ([state isEqualToString:@"mg_common_game_finish"]) {
        
        if (self.delegate) {
            [self.delegate onGameNotifyFinished];
        }

    }
}


@end
