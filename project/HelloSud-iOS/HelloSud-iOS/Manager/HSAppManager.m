//
//  HSAppManager.m
//  HelloSud-iOS
//
//  Created by kaniel on 2022/1/25.
//

#import "HSAppManager.h"
#import "ZegoAudioEngine.h"
#import "AgoraAudioEngine.h"

#define kKeyLoginUserInfo @"key_login_user_info"
#define kKeyLoginAgreement @"key_login_agreement"
#define kKeyLoginIsLogin @"key_login_isLogin"
#define kKeyLoginToken @"key_login_token"
#define kKeyCurrentRTCType @"key_current_rtc_type"
#define kKeyConfigModel @"key_config_model"

@interface HSAppManager ()
@property (nonatomic, strong) NSArray <NSString *> *randomNameArr;

@end

@implementation HSAppManager
+ (instancetype)shared {
    static HSAppManager *g_manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        g_manager = HSAppManager.new;
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
        HSAccountUserModel *m = [HSAccountUserModel mj_objectWithKeyValues:temp];
        _loginUserInfo = m;
    } else {
        HSAccountUserModel *m = HSAccountUserModel.new;
        _loginUserInfo = m;
        m.userID = [NSString stringWithFormat:@"%u", arc4random()];
        m.name = @"小公主2";
//        m.icon = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fi0.hdslb.com%2Fbfs%2Farticle%2F7af2c723accd90ce5c9e79471a76251ae44f0798.jpg&refer=http%3A%2F%2Fi0.hdslb.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1645674165&t=cb63922664bc54461211e0ae8acd6e95";
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
    _rtcType = [NSUserDefaults.standardUserDefaults stringForKey:kKeyCurrentRTCType];
//    _rtcType = @"agora";
    NSString *configStr = [NSUserDefaults.standardUserDefaults stringForKey:kKeyConfigModel];
    if (configStr) {
        _configModel = [HSConfigModel mj_objectWithKeyValues:configStr];
        [self handleRTCConfigInfo];
    }
    [self switchAudioEngine];
}

- (void)setConfigModel:(HSConfigModel *)configModel {
    _configModel = configModel;
    [NSUserDefaults.standardUserDefaults setObject:[configModel mj_JSONString] forKey:kKeyConfigModel];
    [NSUserDefaults.standardUserDefaults synchronize];
    
    [self handleRTCConfigInfo];
}

- (void)setRtcType:(NSString *)rtcType {
    _rtcType = rtcType;
    [NSUserDefaults.standardUserDefaults setObject:rtcType forKey:kKeyCurrentRTCType];
    [NSUserDefaults.standardUserDefaults synchronize];
    [self switchAudioEngine];
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
        [RequestService setupHeader:@{@"Authorization": self.token}];
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
    [RequestService postRequestWithApi:kBASEURL(@"base/config/v1") param:nil success:^(NSDictionary *rootDict) {
        HSConfigModel *model = [HSConfigModel decodeModel:rootDict];
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
    if (HSAppManager.shared.isLogin) {
        NSString *name = HSAppManager.shared.loginUserInfo.name;
        NSString *userID = HSAppManager.shared.loginUserInfo.userID;
        if (name.length > 0) {
            [self reqLogin:name userID:userID sucess:nil];
        }
    }
}


/// 请求登录
/// @param name 昵称
/// @param userID 用户ID
- (void)reqLogin:(NSString *)name userID:(nullable NSString *)userID sucess:(EmptyBlock)success {
    NSString *deviceId = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionaryWithDictionary:@{@"nickname": name, @"deviceId": deviceId}];
    if (userID.length > 0) {
        dicParam[@"userId"] = [NSNumber numberWithInteger:userID.integerValue];
    }
    [RequestService postRequestWithApi:kBASEURL(@"login/v1") param:dicParam success:^(NSDictionary *rootDict) {
        HSLoginModel *model = [HSLoginModel decodeModel:rootDict];
        if (model.retCode != 0) {
            [ToastUtil show:model.retMsg];
            return;
        }
        /// 存储用户信息
        HSAppManager.shared.loginUserInfo.name = model.nickname;
        HSAppManager.shared.loginUserInfo.userID = [NSString stringWithFormat:@"%ld", model.userId];
        HSAppManager.shared.loginUserInfo.icon = model.avatar;
        
        HSAppManager.shared.loginUserInfo.sex = 1;
        [HSAppManager.shared saveLoginUserInfo];
        
        [HSAppManager.shared saveToken: model.token];
        [HSAppManager.shared saveIsLogin];
        if (success) success();
    } failure:^(id error) {
        [ToastUtil show:@"网络错误"];
    }];
}

/// APP隐私协议地址
- (NSURL *)appPrivacyURL {
    NSString *path = [NSBundle.mainBundle pathForResource:@"user_privacy" ofType:@"html" inDirectory:@"Res"];
    return [NSURL fileURLWithPath:path];
}
/// APP用户协议
- (NSURL *)appProtocolURL {
    NSString *path = [NSBundle.mainBundle pathForResource:@"user_protocol" ofType:@"html" inDirectory:@"Res"];
    return [NSURL fileURLWithPath:path];
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
    // 默认zego
    if (self.rtcType.length == 0) {
        self.rtcType = self.configModel.zegoCfg.rtcType;
    }
}

/// 切换RTC语音SDK
- (void)switchAudioEngine {
    
    NSLog(@"当前使用RTC厂商:%@", self.rtcType);
    [MediaAudioEngineManager.shared.audioEngine destroy];
    if ([self.rtcType isEqualToString:self.configModel.zegoCfg.rtcType]) {
        NSLog(@"使用zego语音引擎");
        /// 使用zego语音引擎
        [MediaAudioEngineManager.shared makeEngine:ZegoAudioEngine.class];
        /// 初始化zego引擎SDK
        [MediaAudioEngineManager.shared.audioEngine config:self.configModel.zegoCfg.appId appKey:self.configModel.zegoCfg.appKey];
    } else if ([self.rtcType isEqualToString:self.configModel.agoraCfg.rtcType]) {
        NSLog(@"使用agora语音引擎");
        /// 使用agora语音引擎
        [MediaAudioEngineManager.shared makeEngine:AgoraAudioEngine.class];
        /// 初始化agora引擎SDK
        [MediaAudioEngineManager.shared.audioEngine config:self.configModel.agoraCfg.appId appKey:self.configModel.agoraCfg.appKey];
    }
}

@end


