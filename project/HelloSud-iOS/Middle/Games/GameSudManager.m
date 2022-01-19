//
//  GameSudManager.m
//  HelloSud-iOS
//
//  Created by Mary on 2022/1/18.
//

#import "GameSudManager.h"
/// SudMGPSDK
#import <SudMGP/ISudFSMMG.h>
#import <SudMGP/ISudFSTAPP.h>
#import <SudMGP/SudMGP.h>
#import <SudMGP/ISudFSMStateHandle.h>

#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
/// Comon
#import "AppUtil.h"
#import "GameConfig.h"

/// Model
#import "GameViewInfoModel.h"

@interface GameSudManager () <ISudFSMMG>
@property (nonatomic, strong) id<ISudFSTAPP> fsmAPP2MG;
#pragma mark =======一些需要记录的状态=======
/// 当前用户的游戏id
@property (nonatomic, copy) NSString *currentPlayerUserId;
/// 当前用户登录的code
@property (nonatomic, copy) NSString *code;
/// 当前游戏语言
@property (nonatomic, copy) NSString *language;
/// 错误码表
@property (nonatomic, strong) NSDictionary *errorMap;
/// 你画我猜专用，游戏中选中的关键词，会回调出来，通过 DrawSomethingKeyWord 进行保存。
@property (nonatomic, copy) NSString *drawKeyWord;
/// 你画我猜，进入猜词环节，用来公屏识别关键字的状态标识
@property (nonatomic, assign) BOOL keyWordHiting;

@end

@implementation GameSudManager

#pragma mark =======单例=======
//static GameSudManager *_sudManager;
//+ (GameSudManager *)shared {
//    static dispatch_once_t oneToken;
//    dispatch_once(&oneToken, ^{
//        _sudManager = [[GameSudManager alloc] init];
//    });
//    return _sudManager;
//}

#pragma mark =======ISudFSMMG Delegate=======
/**
 * Code过期
 * @param dataJson {"code":"value"}
 */
- (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onExpireCode:Code过期");
    // 请求业务服务器刷新令牌
    /// TODO: Code更新
#warning Code更新 不能copy此代码，接入时需要刷新使用新的令
    NSString *testCode = @"code";
    // 调用小游戏接口更新令牌
    [self updateGameCode:testCode];
    
    // 回调结果
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"ret_code", @"return form APP onExpireCode", @"ret_msg", nil];
    [handle success: [AppUtil dictionaryToJson: dict]];
}

/**
 * 游戏开始
 */
- (void)onGameStarted {
    NSLog(@"ISudFSMMG:onGameStarted:游戏开始");
}

/**
 * 游戏销毁
 */
- (void)onGameDestroyed {
    NSLog(@"ISudFSMMG:onGameDestroyed:游戏销毁");
}

/**
 * 游戏日志
 */
- (void)onGameLog:(nonnull NSString *)dataJson {
    NSLog(@"ISudFSMMG:onGameLog:%@", dataJson);
    NSDictionary * dic = [AppUtil turnStringToDictionary:dataJson];
    [self handleRetCode:[dic objectForKey:@"errorCode"] errorMsg:[dic objectForKey:@"msg"]];
}

/**
 * 获取游戏配置
 * @param handle 回调句柄
 * @param dataJson {}
 */
- (void)onGetGameCfg:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"ret_code"] = @(0);
    dict[@"ret_msg"] = @"return form APP onGetGameCfg";
    NSString *dataJsonRet = @"";
    NSData *dataJsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    if (dataJsonData != nil) {
        dataJsonRet = [[NSString alloc]initWithData:dataJsonData encoding:NSUTF8StringEncoding];
    }
    [handle success:dataJsonRet];
}

/**
 * 获取游戏View信息
 * @param handle 回调句柄
 * @param dataJson {}
 */
- (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] nativeScale];
    GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
    GameViewSize *viewSize = [[GameViewSize alloc] init];
    viewSize.width = rect.size.width * scale;
    viewSize.height = rect.size.height * scale;
    ViewGameRect *viewRect = [[ViewGameRect alloc] init];
    viewRect.top = 0;
    viewRect.left = 0;
    viewRect.bottom = 0;
    viewRect.right = 0;
    m.ret_code = 0;
    m.ret_msg = @"return form APP onGetGameViewInfo";
    m.view_size = viewSize;
    m.view_game_rect = viewRect;
    /// 回调
    [handle success:[AppUtil dictionaryToJson:m.mj_keyValues]];
}

/**
 * 游戏状态变化
 * @param handle 回调句柄
 * @param state 游戏状态
 * @param dataJson 回调json
 */
- (void)onGameStateChange:(nonnull id<ISudFSMStateHandle>)handle state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    
    if ([state isEqualToString:MG_COMMON_PUBLIC_MESSAGE]) {
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:公屏消息");
        if ([self.delegate respondsToSelector:@selector(onGameStateChangePublicMessage:)]) {
            [self.delegate onGameStateChangePublicMessage:dataJson];
        }
    } else if ([state isEqualToString:MG_COMMON_KEY_WORD_TO_HIT]) {
//        NSDictionary *dic = [AppUtil turnStringToDictionary:dataJson];
//        NSString *word = [dic objectForKey:@"word"];
//        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:你画我猜关键词获取:%@",word);
//        /// 记录你画我猜关键字
//        self.drawKeyWord = word;
//        if (word == (id) [NSNull null] || [word isEqualToString:@""]) {
//            /// 隐藏命中按钮
//            self.hitButton.alpha = 0;
//            /// 关闭公屏关键词hit状态
//            self.keyWordHiting = NO;
//        } else {
//            /// 添加命中按钮
//            self.hitButton.alpha = 1;
//            /// 开启公屏关键词hit状态
//            self.keyWordHiting = YES;
//        }
    }else {
        /// 其他状态
        NSLog(@"ISudFSMMG:onGameStateChange:游戏->APP:state:%@",MG_COMMON_PUBLIC_MESSAGE);
    }
}

- (void)onPlayerStateChange:(nullable id<ISudFSMStateHandle>)handle userId:(nonnull NSString *)userId state:(nonnull NSString *)state dataJson:(nonnull NSString *)dataJson {
    
}

#pragma mark - ======= Public =======
#pragma mark - ======= Private =======
/**
 * 初始化游戏SDK
 *
 * @param appID           NSString        项目的appID
 * @param appKey         NSString        项目的appKey
 * @param isTestEnv  Boolean         是否是测试环境，true:测试环境, false:正式环境
 * @param mgID             NSInteger      游戏ID，如 碰碰我最强:1001；飞刀我最强:1002；你画我猜:1003
 */
- (void)initGameSDKWithAppID:(NSString *)appID appKey:(NSString *)appKey isTestEnv:(Boolean)isTestEnv mgID:(int64_t)mgID rootView:(UIView*)rootView {
    [SudMGP initSDK:appID appKey:appKey isTestEnv:isTestEnv listener:^(int retCode, const NSString *retMsg) {
        if (retCode == 0) {
            NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化游戏SDK成功");
            // SudMGPSDK初始化成功 加载MG
            [self loadMG:self.currentPlayerUserId roomId:@"1234567" code:self.code mgId:mgID language:self.language fsmMG:self rootView:rootView];
        } else {
            /// 初始化失败, 可根据业务重试
            NSLog(@"ISudFSMMG:initGameSDKWithAppID:初始化sdk失败 :%@",retMsg);
        }
    }];
}

/// 加载游戏MG
/// @param userId 用户唯一ID
/// @param roomId 房间ID
/// @param code 游戏登录code
/// @param mgId 游戏ID
/// @param language 支持简体"zh-CN "    繁体"zh-TW"    英语"en-US"   马来"ms-MY"
/// @param fsmMG 控制器
/// @param rootView 游戏根视图
- (void)loadMG:(NSString *)userId roomId:(NSString *)roomId code:(NSString *)code mgId:(int64_t) mgId language:(NSString *)language fsmMG:(id)fsmMG rootView:(UIView*)rootView {
    self.fsmAPP2MG = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:fsmMG rootView:rootView];
}

/// 销毁MG
- (void)destroyMG {
    [self.fsmAPP2MG destroyMG];
}

/// 更新code
/// @param code 新的code
- (void)updateGameCode:(NSString *)code {
    [self.fsmAPP2MG updateCode:code listener:^(int retCode, const NSString *retMsg, const NSString *dataJson) {
        NSLog(@"ISudFSMMG:updateGameCode retCode=%@ retMsg=%@ dataJson=%@", @(retCode), retMsg, dataJson);
    }];
}

#pragma mark =======处理返回消息=======
- (void)handleRetCode:(NSString *)retCode errorMsg:(NSString *)msg {
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@出错，错误码:%@", msg, retCode]];
}










#pragma mark =======处理公屏消息=======
/// 处理公屏消息
/// @param json 公屏消息JSON
- (void)handlePublicMessage:(NSString *)json {
    if (!json) {
        return;
    }
    NSDictionary * dic = [AppUtil turnStringToDictionary:json];
    NSLog(@"%@",dic);
    if (!dic) {
        NSLog(@"ISudFSMMG:handlePublicMessage error dic:%@",dic);
    }
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] init];
    NSArray * array = [dic objectForKey:@"msg"];
    if (![array respondsToSelector:@selector(objectAtIndex:)]) {
        /// 格式不符合
        return;
    }
    for (int i = 0; i < array.count; i ++) {
        NSDictionary * msgDic = [array objectAtIndex:i];
        if ([[msgDic objectForKey:@"phrase"] intValue] == 2) {
            NSDictionary * userDic = [msgDic objectForKey:@"user"];
            NSString * userName = [userDic objectForKey:@"name"];
            NSString * color = [userDic objectForKey:@"color"];
            [result appendAttributedString:[AppUtil getAttributedStringWithString:userName color:color]];
        }else if ([[msgDic objectForKey:@"phrase"] intValue] == 1) {
            NSDictionary * textDic = [msgDic objectForKey:@"text"];
            NSString * textString = [textDic objectForKey:self.language];
            NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:textString];
            [result appendAttributedString:attributedString];
        }
    }
    /// 插入公屏消息
//    [self.publicMessageView insertCellWithAttributeString:result];
}
@end

