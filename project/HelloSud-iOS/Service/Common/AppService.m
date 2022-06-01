//
//  AppService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "AppService.h"
#import "ZegoAudioEngineImpl.h"
#import "AgoraAudioEngineImpl.h"
#import "RCloudAudioEngineImpl.h"
#import "NeteaseAudioEngineImpl.h"
#import "TXAudioEngineImpl.h"
#import "VolcAudioEngineImpl.h"
#import "AliyunAudioEngineImpl.h"
/// 用户登录确认key
#define kKeyLoginAgreement @"key_login_agreement"

/// 当前选中RTC类型缓存key
#define kKeyCurrentRTCType @"key_current_rtc_type"
/// 配置信息缓存key
#define kKeyConfigModel @"key_config_model"

NSString *const kRtcTypeZego = @"zego";
NSString *const kRtcTypeAgora = @"agora";
NSString *const kRtcTypeRongCloud = @"rongCloud";
NSString *const kRtcTypeCommEase = @"commsEase";
NSString *const kRtcTypeVolcEngine = @"volcEngine";
NSString *const kRtcTypeAlibabaCloud = @"alibabaCloud";
NSString *const kRtcTypeTencentCloud = @"tencentCloud";


@interface AppService ()
@property(nonatomic, strong) NSArray <NSString *> *randomNameArr;

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

- (LoginService *)login {
    if (!_login) {
        _login = [[LoginService alloc] init];
    }
    return _login;
}

- (void)prepare {
    [self.login prepare];
    [self config];
}

- (NSString *)loginUserID {
    return self.login.loginUserInfo.userID;
}

- (void)config {

    _isAgreement = [NSUserDefaults.standardUserDefaults boolForKey:kKeyLoginAgreement];

    NSString *cacheRTCType = [NSUserDefaults.standardUserDefaults stringForKey:kKeyCurrentRTCType];
    NSString *configStr = [NSUserDefaults.standardUserDefaults stringForKey:kKeyConfigModel];
    if (configStr) {
        _configModel = [ConfigModel mj_objectWithKeyValues:configStr];
    }

    [self switchRtcType:cacheRTCType];
}

- (void)setConfigModel:(ConfigModel *)configModel {
    _configModel = configModel;
    [NSUserDefaults.standardUserDefaults setObject:[configModel mj_JSONString] forKey:kKeyConfigModel];
    [NSUserDefaults.standardUserDefaults synchronize];
    NSString *rtcType = self.rtcType;
    if (self.rtcType.length == 0 || !AudioEngineFactory.shared.audioEngine) {
        [self switchRtcType:rtcType];
    }
}

- (void)setRtcType:(NSString *)rtcType {
    _rtcType = rtcType;
    [NSUserDefaults.standardUserDefaults setObject:rtcType forKey:kKeyCurrentRTCType];
    [NSUserDefaults.standardUserDefaults synchronize];
}


/// 保存是否同意协议
- (void)saveAgreement {
    _isAgreement = true;
    [NSUserDefaults.standardUserDefaults setBool:true forKey:kKeyLoginAgreement];
    [NSUserDefaults.standardUserDefaults synchronize];
}

/// 随机名字
- (NSString *)randomUserName {
    int num = arc4random() % 100;
    return self.randomNameArr[num];
}

/// 设置请求header
- (void)setupNetWorkHeader {
    NSString *token = AppService.shared.login.token;
    if (AppService.shared.login.token) {
        [HSHttpService setupHeader:@{@"Authorization": token}];
        // 图片拉取鉴权
        SDWebImageDownloader *downloader = (SDWebImageDownloader *) [SDWebImageManager sharedManager].imageLoader;
        [downloader setValue:token forHTTPHeaderField:@"Authorization"];
    } else {
        DDLogError(@"设置APP请求头token为空");
    }
    NSString *locale = [SettingsService getCurLanguageLocale];
    NSString *clientChannel = @"appstore";
    NSString *clientVersion = [NSString stringWithFormat:@"%@", DeviceUtil.getAppVersion];
    NSString *buildNumber = DeviceUtil.getAppBuildCode;
    NSString *deviceId = DeviceUtil.getIdfv;
    NSString *systemType = @"iOS";
    NSString *systemVersion = DeviceUtil.getSystemVersion;
    NSString *clientTimestamp = [NSString stringWithFormat:@"%ld", (NSInteger) [NSDate date].timeIntervalSince1970];
    NSString *rtcType = AppService.shared.rtcType ? AppService.shared.rtcType : @"";
    NSArray *arr = @[
            locale,
            clientChannel,
            clientVersion,
            buildNumber,
            deviceId,
            systemType,
            systemVersion,
            clientTimestamp,
            rtcType
    ];
    NSString *sudMeta = [arr componentsJoinedByString:@","];
    [HSHttpService setupHeader:@{@"Sud-Meta": sudMeta}];
    DDLogInfo(@"Sud-Meta:%@", sudMeta);
}

- (void)setDefLanguage {

}

/// 登录成功请求配置信息
- (void)reqConfigData {
    WeakSelf
    [HSHttpService postRequestWithURL:kBASEURL(@"base/config/v1") param:nil respClass:ConfigModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        weakSelf.configModel = (ConfigModel *) resp;
    }                         failure:nil];
}

- (void)reqAppUpdate:(RespModelBlock)success fail:(nullable ErrorStringBlock)fail {
    [HSHttpService postRequestWithURL:kBASEURL(@"check-upgrade/v1") param:nil respClass:RespVersionUpdateInfoModel.class showErrorToast:YES success:^(BaseRespModel *resp) {
        success(resp);
    }                         failure:^(NSError *error) {
        if (fail) {
            fail(error.dt_errMsg);
        }
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
    if (AppService.shared.login.isLogin) {
    }
}

/// 切换RTC厂商
/// @param rtcType 对应rtc厂商类型
- (void)switchRtcType:(NSString *)rtcType {
    NSString *changedRtcType = [self switchAudioEngine:rtcType];
    if (changedRtcType) {
        self.rtcType = changedRtcType;
    }
    [self setupNetWorkHeader];
}

- (BOOL)isSameRtc:(HSConfigContent *)rtcConfig rtcType:(NSString *)rtcType {
    if (rtcConfig) {
        return [rtcConfig isSameRtc:rtcType];
    }
    return NO;
}

/// 切换RTC语音SDK
/// @param rtcType 厂商类型
- (NSString *)switchAudioEngine:(NSString *)rtcType {

    HSConfigContent *rtcConfig = nil;
    DDLogInfo(@"切换RTC厂商:%@", rtcType);
    [AudioEngineFactory.shared.audioEngine destroy];
    if ([self isSameRtc:self.configModel.zegoCfg rtcType:rtcType]) {

        DDLogInfo(@"使用zego语音引擎");
        [AudioEngineFactory.shared createEngine:ZegoAudioEngineImpl.class];
        rtcConfig = self.configModel.zegoCfg;
    } else if ([self isSameRtc:self.configModel.agoraCfg rtcType:rtcType]) {

        DDLogInfo(@"使用agora语音引擎");
        [AudioEngineFactory.shared createEngine:AgoraAudioEngineImpl.class];
        rtcConfig = self.configModel.agoraCfg;
    } else if ([self isSameRtc:self.configModel.rongCloudCfg rtcType:rtcType]) {

        DDLogInfo(@"使用rongCloud语音引擎");
        [AudioEngineFactory.shared createEngine:RCloudAudioEngineImpl.class];
        rtcConfig = self.configModel.rongCloudCfg;
    } else if ([self isSameRtc:self.configModel.commsEaseCfg rtcType:rtcType]) {

        DDLogInfo(@"使用commsEas语音引擎");
        [AudioEngineFactory.shared createEngine:NeteaseAudioEngineImpl.class];
        rtcConfig = self.configModel.commsEaseCfg;
    } else if ([self isSameRtc:self.configModel.tencentCloudCfg rtcType:rtcType]) {

        DDLogInfo(@"使用TencentCloud语音引擎");
        [AudioEngineFactory.shared createEngine:TXAudioEngineImpl.class];
        rtcConfig = self.configModel.tencentCloudCfg;
    } else if ([self isSameRtc:self.configModel.volcEngineCfg rtcType:rtcType]) {

        DDLogInfo(@"使用VolcEngine语音引擎");
        [AudioEngineFactory.shared createEngine:VolcAudioEngineImpl.class];
        rtcConfig = self.configModel.volcEngineCfg;
    } else if ([self isSameRtc:self.configModel.alibabaCloudCfg rtcType:rtcType]) {

        DDLogInfo(@"使用AlibabaCloud语音引擎");
        [AudioEngineFactory.shared createEngine:AliyunAudioEngineImpl.class];
        rtcConfig = self.configModel.alibabaCloudCfg;
    } else {
        if (rtcType.length == 0 && self.configModel.zegoCfg) {
            rtcType = self.configModel.zegoCfg.rtcType;
            [AudioEngineFactory.shared createEngine:ZegoAudioEngineImpl.class];
            rtcConfig = self.configModel.zegoCfg;
            DDLogInfo(@"默认RTC厂商：%@", rtcType);
        } else {
            DDLogError(@"切换RTC厂商失败，对应配置为空");
            return rtcType;
        }
    }

    /// 初始化引擎SDK
    NSString *appID = rtcConfig.appId;
    NSString *appKey = rtcConfig.appKey;
    if (appID.length > 0 || appKey.length > 0) {
        AudioConfigModel *model = [[AudioConfigModel alloc] init];
        model.appId = appID;
        model.appKey = appKey;
        self.rtcConfigModel = model;
        return rtcType;
    }
    return rtcType;
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

/// 获取RTC厂商名称
/// @param rtcType rtc类型
- (NSString *)getRTCTypeName:(NSString *)rtcType {
    if ([rtcType dt_isInsensitiveEqualToString:kRtcTypeZego]) {
        return NSString.dt_settings_zego;
    } else if ([rtcType dt_isInsensitiveEqualToString:kRtcTypeAgora]) {
        return NSString.dt_settings_agora;
    } else if ([rtcType dt_isInsensitiveEqualToString:kRtcTypeRongCloud]) {
        return NSString.dt_settings_rong_cloud;
    } else if ([rtcType dt_isInsensitiveEqualToString:kRtcTypeCommEase]) {
        return NSString.dt_settings_net_ease;
    } else if ([rtcType dt_isInsensitiveEqualToString:kRtcTypeVolcEngine]) {
        return NSString.dt_settings_volcano;
    } else if ([rtcType dt_isInsensitiveEqualToString:kRtcTypeAlibabaCloud]) {
        return NSString.dt_settings_alicloud;
    } else if ([rtcType dt_isInsensitiveEqualToString:kRtcTypeTencentCloud]) {
        return NSString.dt_settings_tencent;
    }
    return @"";
}

@end


