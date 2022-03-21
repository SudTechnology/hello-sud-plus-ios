//
//  AppService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "AppService.h"
#import "ZegoAudioEngineImpl.h"
#import "AgoraAudioEngineImpl.h"
/// 用户信息缓存key
#define kKeyLoginUserInfo @"key_login_user_info"
/// 用户登录确认key
#define kKeyLoginAgreement @"key_login_agreement"
/// 用户是否登录缓存key
#define kKeyLoginIsLogin @"key_login_isLogin"
/// 用户是否登录token缓存key
#define kKeyLoginToken @"key_login_token"
/// 当前选中RTC类型缓存key
#define kKeyCurrentRTCType @"key_current_rtc_type"
/// 配置信息缓存key
#define kKeyConfigModel @"key_config_model"

@interface AppService ()
@property (nonatomic, strong) NSArray <NSString *> *randomNameArr;

@end

@implementation AppService
+ (instancetype)shared {
    static AppService *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = AppService.new;
    });
    return g_manager;
}

- (instancetype)init {
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config {
    id temp = [NSUserDefaults.standardUserDefaults objectForKey:kKeyLoginUserInfo];
    if (temp && [temp isKindOfClass:NSString.class]) {
        AccountUserModel *m = [AccountUserModel mj_objectWithKeyValues:temp];
        _loginUserInfo = m;
    } else {
        AccountUserModel *m = AccountUserModel.new;
        _loginUserInfo = m;
        m.userID = @"";
        m.name = @"";
        m.icon = @"";
        m.sex = 1;
    }
    
    _isAgreement = [NSUserDefaults.standardUserDefaults boolForKey:kKeyLoginAgreement];
    _isLogin = [NSUserDefaults.standardUserDefaults boolForKey:kKeyLoginIsLogin];
    id temp_token = [NSUserDefaults.standardUserDefaults objectForKey:kKeyLoginToken];
    if (temp_token && [temp_token isKindOfClass:NSString.class]) {
        _token = temp_token;
        [self saveIsLogin];
        [self setupNetWorkHeader];
        [self reqConfigData];
    }
    NSString *cacheRTCType = [NSUserDefaults.standardUserDefaults stringForKey:kKeyCurrentRTCType];
    NSString *configStr = [NSUserDefaults.standardUserDefaults stringForKey:kKeyConfigModel];
    if (configStr) {
        _configModel = [ConfigModel mj_objectWithKeyValues:configStr];
        [self handleRTCConfigInfo];
    }
    [self switchRtcType:cacheRTCType];
}

- (void)setConfigModel:(ConfigModel *)configModel {
    _configModel = configModel;
    [NSUserDefaults.standardUserDefaults setObject:[configModel mj_JSONString] forKey:kKeyConfigModel];
    [NSUserDefaults.standardUserDefaults synchronize];
    // 处理厂商配置列表
    [self handleRTCConfigInfo];
    NSString *rtcType = self.rtcType;
    // 默认zego，切换引擎
    if (rtcType.length == 0) {
        rtcType = self.configModel.zegoCfg.rtcType;
    }
    if (self.rtcType.length == 0 || !AudioEngineFactory.shared.audioEngine) {
        [self switchRtcType:rtcType];
    }
}

- (void)setRtcType:(NSString *)rtcType {
    _rtcType = rtcType;
    [NSUserDefaults.standardUserDefaults setObject:rtcType forKey:kKeyCurrentRTCType];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 保持用户信息
- (void)saveLoginUserInfo {
    if (self.loginUserInfo) {
        NSString *jsonStr = [self.loginUserInfo mj_JSONString];
        [NSUserDefaults.standardUserDefaults setObject:jsonStr forKey:kKeyLoginUserInfo];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}

/// 保存是否同意协议
- (void)saveAgreement {
    _isAgreement = true;
    [NSUserDefaults.standardUserDefaults setBool:true forKey:kKeyLoginAgreement];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 保存登录状态
- (void)saveIsLogin {
    _isLogin = true;
    [NSUserDefaults.standardUserDefaults setBool:true forKey:kKeyLoginIsLogin];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 随机名字
- (NSString *)randomUserName {
    int num = arc4random() % 100;
    return self.randomNameArr[num];
}

/// 设置请求header
- (void)setupNetWorkHeader {
    if (self.token) {
        [HttpService setupHeader:@{@"Authorization": self.token}];
    } else {
        NSLog(@"设置APP请求头token为空");
    }
    // 图片拉取鉴权
    SDWebImageDownloader *downloader = (SDWebImageDownloader *)[SDWebImageManager sharedManager].imageLoader;
    [downloader setValue:self.token forHTTPHeaderField:@"Authorization"];
}

/// 保存token
- (void)saveToken:(NSString *)token {
    _token = token;
    [self setupNetWorkHeader];
    [NSUserDefaults.standardUserDefaults setValue:token forKey:kKeyLoginToken];
    [NSUserDefaults.standardUserDefaults synchronize];
    
    [self reqConfigData];
}

/// 登录成功请求配置信息
- (void)reqConfigData {
    WeakSelf
    [HttpService postRequestWithApi:kBASEURL(@"base/config/v1") param:nil success:^(NSDictionary *rootDict) {
        ConfigModel *model = [ConfigModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            return;
        }
        weakSelf.configModel = model;
    } failure:^(id error) {
        [ToastUtil show:@"网络错误"];
    }];
}

- (NSArray<NSString *> *)randomNameArr {
    if (!_randomNameArr) {
        _randomNameArr = @[@"哈利", @"祺祥", @"沐辰", @"阿米莉亚", @"齐默尔曼", @"陌北", @"旺仔", @"半夏", @"朝雨", @"卫斯理", @"阿道夫", @"长青", @"安小六", @"小凡", @"炎月", @"醉风", @"斯科特", @"布卢默", @"宛岩", @"平萱", @"凝雁", @"怀亚特", @"格伦巴特", @"尔白", @"南露", @"爱丽丝", @"埃尔维斯", @"奥利维亚", @"妙竹", @"雲思衣", @"少女大佬", @"兔兔别跑", @"夏纱", @"嘉慕", @"阿拉贝拉", @"星剑", @"罗德斯", @"渡满归", @"星浅", @"问水", @"星奕晨", @"丹尼尔", @"白止扇", @"暖暖", @"埃迪", @"杰里米", @"玛德琳", @"波佩", @"卡诺", @"泡芙", @"帕特里克", @"梅雷迪斯", @"公孙昕", @"青弘", @"潘豆豆", @"小番秀二", @"大一宇", @"米奇", @"戴夫", @"伯特", @"米洛布雷", @"阿德莱德", @"吉宝", @"伊娃", @"路易斯", @"希拉姆", @"杰西", @"贝特西", @"利奥波德", @"丽塔", @"拉姆斯登", @"伯纳德", @"理查德", @"奥尔德里奇", @"劳里", @"奥兰多", @"埃尔罗伊", @"栗和顺", @"朱雀佳行", @"理德拉", @"凡勃伦", @"科波菲尔", @"玉谷大三", @"大木元司", @"钮阳冰", @"盖勤", @"紫心", @"弘慕慕", @"怀星驰", @"泉宏胜", @"闻人星海", @"Watt", @"Kevin", @"Toby", @"瓦利斯", @"苏珊娜", @"罗密欧", @"福克纳", @"多萝西", @"贝尔", @"卡门", @"安德烈", @"朱丽叶", @"吉姆"];
    }
    return _randomNameArr;
}

/// 刷新token
- (void)refreshToken {
    if (AppService.shared.isLogin) {
        NSString *name = AppService.shared.loginUserInfo.name;
        NSString *userID = AppService.shared.loginUserInfo.userID;
        if (name.length > 0) {
            [LoginService.shared reqLogin:name userID:userID sucess:^{
                self.isRefreshedToken = YES;
            }];
        }
    }
}

/// 处理rtc厂商信息
- (void)handleRTCConfigInfo {
    NSMutableArray *rtcList = NSMutableArray.new;
    if (self.configModel.zegoCfg) {
        [rtcList addObject:self.configModel.zegoCfg];
    }
    if (self.configModel.agoraCfg) {
        [rtcList addObject:self.configModel.agoraCfg];
    }
    _rtcList = rtcList;
}

/// 切换RTC厂商
/// @param rtcType 对应rtc厂商类型
- (void)switchRtcType:(NSString *)rtcType {
    self.rtcType = rtcType;
    [self switchAudioEngine:self.rtcType configModel:self.configModel];
}

/// 切换RTC语音SDK
/// @param rtcType 厂商类型
/// @param configModel 配置信息
- (void)switchAudioEngine:(NSString *)rtcType configModel:(ConfigModel *)configModel {
    if (rtcType.length == 0 || configModel == nil) {
        NSLog(@"切换RTC厂商失败，参数异常:%@, configModel:%@", rtcType, configModel);
        return;
    }
    
    NSLog(@"切换RTC厂商:%@", rtcType);
    [AudioEngineFactory.shared.audioEngine destroy];

    if (configModel.zegoCfg && [rtcType isEqualToString:configModel.zegoCfg.rtcType]) {
        NSLog(@"使用zego语音引擎");
        /// 使用zego语音引擎
        [AudioEngineFactory.shared createEngine:ZegoAudioEngineImpl.class];
        /// 初始化zego引擎SDK
        NSString *appID = configModel.zegoCfg.appId;
        NSString *appKey = configModel.zegoCfg.appKey;
        if (appID.length > 0 && appKey.length > 0) {
            NSDictionary *config = @{@"appID": appID, @"appKey": appKey};
            [AudioEngineFactory.shared.audioEngine initWithConfig:config];
        } else {
            [ToastUtil show:@"切换zego语音引擎失败，对应配置为空"];
        }
    } else if (configModel.agoraCfg && [rtcType isEqualToString:configModel.agoraCfg.rtcType]) {
        NSLog(@"使用agora语音引擎");
        /// 使用agora语音引擎
        [AudioEngineFactory.shared createEngine:AgoraAudioEngineImpl.class];
        /// 初始化agora引擎SDK
        NSString *appID = configModel.agoraCfg.appId;
        if (appID.length > 0) {
            NSMutableDictionary *config = NSMutableDictionary.new;
            config[@"appID"] = appID;
            [AudioEngineFactory.shared.audioEngine initWithConfig:config];
        } else {
            [ToastUtil show:@"切换agora语音引擎失败，对应配置为空"];
        }
    } else {
        [ToastUtil show:@"切换RTC厂商失败，对应配置为空"];
    }

}

/// 通过gameID获取游戏总人数
/// @param gameID 游戏ID
- (NSInteger)getTotalGameCountWithGameID:(NSInteger)gameID {
    NSInteger count = 0;
    for (HSGameItem *item in self.gameList) {
        if (gameID == item.gameId) {
            if (item.gameModeList.count > 0) {
                count = [[item.gameModeList[0].count lastObject] integerValue];
            }
            break;
        }
    }
    return count;
}

@end


