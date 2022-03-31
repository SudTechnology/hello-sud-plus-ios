//
//  AppService.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "AppService.h"
#import "ZegoAudioEngineImpl.h"
#import "AgoraAudioEngineImpl.h"

/// 用户登录确认key
#define kKeyLoginAgreement @"key_login_agreement"

/// 当前选中RTC类型缓存key
#define kKeyCurrentRTCType @"key_current_rtc_type"
/// 配置信息缓存key
#define kKeyConfigModel @"key_config_model"


NSString *const kRtcNameZego = @"即构";
NSString *const kRtcNameAgora = @"声网";
NSString *const kRtcNameRongCloud = @"融云";
NSString *const kRtcNameCommEase = @"网易云信";
NSString *const kRtcNameVoicEngine = @"火山引擎";
NSString *const kRtcNameAlibabaCloud = @"阿里云";
NSString *const kRtcNameTencentCloud = @"腾讯云";


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
    [self config];
    [self.login prepare];
}

- (void)config {

    _isAgreement = [NSUserDefaults.standardUserDefaults boolForKey:kKeyLoginAgreement];

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
        [HttpService setupHeader:@{@"Authorization": token}];
        // 图片拉取鉴权
        SDWebImageDownloader *downloader = (SDWebImageDownloader *)[SDWebImageManager sharedManager].imageLoader;
        [downloader setValue:token forHTTPHeaderField:@"Authorization"];
    } else {
        NSLog(@"设置APP请求头token为空");
    }
    NSString *locale = @"zh-CN";
    NSString *clientChannel = @"appstore";
    NSString *clientVersion = [NSString stringWithFormat:@"%@.%@", DeviceUtil.getAppVersion, DeviceUtil.getAppBuildCode];
    NSString *deviceId = DeviceUtil.getIdfv;
    NSString *systemType = @"iOS";
    NSString *systemVersion = DeviceUtil.getSystemVersion;
    NSString *clientTimestamp = [NSString stringWithFormat:@"%ld", (NSInteger)[NSDate date].timeIntervalSince1970];
    NSArray *arr = @[
            locale,
            clientChannel,
            clientVersion,
            deviceId,
            systemType,
            systemVersion,
            clientTimestamp
            ];
    NSString *sudMeta = [arr componentsJoinedByString:@","];
    [HttpService setupHeader:@{@"Sud-Meta": sudMeta}];

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
    }                       failure:^(id error) {
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
    if (AppService.shared.login.isLogin) {
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
            AudioConfigModel *model = [[AudioConfigModel alloc] init];
            model.appId = appID;
            model.appKey = appKey;
            [AudioEngineFactory.shared.audioEngine initWithConfig:model];
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
            AudioConfigModel *model = [[AudioConfigModel alloc] init];
            model.appId = appID;
            model.userID = _loginUserInfo.userID;
            model.token = @"";
            [AudioEngineFactory.shared.audioEngine initWithConfig:model];
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


