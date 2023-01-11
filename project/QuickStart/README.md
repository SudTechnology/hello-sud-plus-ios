# 开启快速接入和联调SUD游戏之旅
- 第一步：APP客户端集成SUD游戏（三分钟集成代码）
  <details>
  <summary>详细描述</summary>

      1.appId、appKey和isTestEnv=true，请使用QuickStart客户端的；
      2.iOS bundleId、Android applicationId，请使用APP客户端自己的；(接入信息表中的bundleId/applicationId)；
      3.短期令牌code，请使用QuickStart的后端服务（login/getCode获取的）；
      4.完成集成，游戏跑起来;
  
      *** SUD平台支持一个appId绑定多个bundleId和applicationId；***
      *** 填完接入信息表后，SUD会将APP的bundleId和applicationId，绑定到QuickStart的appId上，仅支持测试环境；***
  QuickStart 后端服务[hello-sud-java代码仓库](https://github.com/SudTechnology/hello-sud-java) ，`如果访问不了代码仓库，请联系SUD添加，github账号`；
  </details>

  
- 第二步：APP客户端和APP服务端联调
  <details>
  <summary>详细描述</summary>

      1.APP服务端实现4个HTTP API；（接入信息表填的）
      2.APP服务端实现login/getCode接口，获取短期令牌code；
      3.请使用APP客户端自己的appId、appKey、isTestEnv=true、bundleId(iOS)、applicationId(Android)；
      4.请使用APP自己的服务端login/getCode接口，获取短期令牌code；
      5.APP客户端和APP服务端联调5个HTTP API；
      6.完成HTTP API联调；
  </details>


- 第三步：APP专注于自身业务需求
  <details>
  <summary>详细描述</summary>

      1.参考SudMGP文档、SudMGPWrapper、QuickStart、HelloSud体验Demo（展示多场景，Custom自定义场景）；
      2.专注于APP UI交互、功能是否支持、如何实现
      比如：
      调整游戏View大小、位置；
      调整APP和游戏交互流程，UI元素是否可隐藏，按钮是否可隐藏APP实现，点击事件是否支持拦截回调；
      
      3.专注于APP业务逻辑流程、实现
      比如：
      一局游戏开始如何透传数值类型参数、Key类型参数；（结算）
  ![Android](doc/hello_sudplus_android.png)
  ![iPhone](doc/hello_sudplus_iphone.png)
  </details>
# 三分钟集成代码
- 第一步：导入模块SudMGPSDK、SudMGPWrapper
  <details>
  <summary>本地pod方式导入</summary>

      1.将QuickStart同级目录下的SudMGPSDK、SudMGPWrapper两个目录所有文件及SudMGPWrapper.podspec文件拷贝到目标工程Podfile所在的目录下
      2.APP主工程Podfile文件中，添加 SudMGPWrapper 依赖;
  ``` ruby
  pod 'SudMGPWrapper', :path => './'
  ```
      3. 执行pod install，将SudMGP SDK、SudMGPWrapper模块依赖进工程中
  </details>
  <details>
  <summary>cocoapods方式导入</summary>

      1.APP主工程Podfile文件中，添加 SudMGPWrapper 依赖;
  ``` ruby
  pod 'SudMGPWrapper', '~> 1.5.8'
  ```
      3. 执行pod install，将SudMGP SDK、SudMGPWrapper模块依赖进工程中
  </details>
  <details>
  <summary>ASR识别支持（可选 v1.2.7及后续版本支持）</summary>

      1.APP主工程Podfile文件中，添加 ASR语音识别库 依赖;
  ``` ruby
  pod 'MicrosoftCognitiveServicesSpeech-iOS', '1.23.0'
  ```
      3. 执行pod install，将ASR语音识别库模块依赖进工程中
  </details>
  

- 第二步：拷贝QuickStart 两个文件，并保持配置参数不变
  <details>
  <summary>详细描述</summary>

      1.拷贝两个文件，Demo工程目录路径(QuickStart->UI->VC):
        QuickStartViewController+Game.h
        QuickStartViewController+Game.m
      2.保持配置参数不变，appId和appKey使用QuickStart
        QuickStartViewController+Game.h
  ``` objc
    // TODO: 登录接入方服务器url
    #define GAME_LOGIN_URL          @"https://fat-mgp-hello.sudden.ltd/login/v2"

    // TODO: 必须填写由SudMGP提供的appId 及 appKey
    #define SUDMGP_APP_ID                  @"1461564080052506636"
    #define SUDMGP_APP_KEY                 @"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"

    // TODO: 是否是测试环境,生产环境必须设置为NO
    #if DEBUG
    #define GAME_TEST_ENV    YES
    #else
    #define GAME_TEST_ENV    NO
    #endif
  ```
      3.QuickStartViewController+Game分类名称改成目标ViewController对应名称
      4.保持使用QuickStart后端服务login/getCode；
        4.1 实现APP快速加载运行游戏，使用QuickStart服务；
        4.2 填好接入信息表后，测试环境，会把APP的bundleId和applicationId，同时加入到QuickStart的appId；
  </details>
  

- 第三步：在目标ViewController中定义一个游戏View容器，例如：QuickStartViewController.h
    <details>
    <summary>详细描述 QuickStartViewController.h</summary>

    ``` objc
    @interface QuickStartViewController ()
    /// 游戏加载主view
    @property(nonatomic, strong) UIView *gameView;
    ```
    </details>
  

- 第四步：创建SudMDPWrapper实例，例如：QuickStartViewController.m
    <details>
    <summary>详细描述 QuickStartViewController.m</summary>
    
    ``` objc
    - (void)viewDidLoad {
        [super viewDidLoad];

        // 1. 创建SudMDPWrapper
        [self createSudMGPWrapper];

        ...
    }     
    ```
    </details>
  

- 第五步：加载游戏
    <details>
    <summary>详细描述 QuickStartViewController.m</summary>


    ``` objc
    - (void)viewDidLoad {
        [super viewDidLoad];

        /// 加载游戏步骤

        // 创建SudMDPWrapper
        [self createSudMGPWrapper];

        // 配置加载SudMGP必须参数
        SudMGPLoadConfigModel *sudGameConfigModel = [[SudMGPLoadConfigModel alloc] init];
        // 碰碰我最强， SudMGP平台64bit游戏ID（此id与QuickStart绑定。替换Sud平台AppId之后，请修改为对应mgId）
        sudGameConfigModel.mgId = 1461227817776713818;
        // 房间ID
        sudGameConfigModel.roomId = @"10000"; 
        // 游戏语言
        sudGameConfigModel.language = @"zh-CN";
        // 游戏视图
        sudGameConfigModel.gameView = self.gameView;
        // 业务方APP当前登录的用户ID
        sudGameConfigModel.userId = @"123456";

        // 加载游戏
        if (sudGameConfigModel.mgId > 0) {
            [self loginGame:self.sudMGPLoadConfigModel];
        }
    }        
    ```
    </details>
  

- 第六步：销毁游戏
    <details>
    <summary>详细描述 QuickStartViewController+Game.m</summary>

    ``` objc
    /// 三：退出游戏 销毁SudMGP SDK
    - (void)logoutGame {
        // 销毁游戏
        [self.sudFSMMGDecorator clearAllStates];
        [self.sudFSTAPPDecorator destroyMG];
    }
    ```
    </details>  

# QuickStart 架构图
![QuickStartArch.png](doc/QuickStartArch.png)

# 1. SudMGP SDK
### 1.1 SudMGP Client SDK

- [下载 SudMGP-Android-v1.1.52.554.zip](https://github.com/SudTechnology/sud-mgp-android/releases)
- [下载 SudMGP-iOS-v1.1.52.527.zip](https://github.com/SudTechnology/sud-mgp-ios/releases)

### 1.2 接入文档

- [接入文档](https://docs.sud.tech/zh-CN/app/Client/API/)
- [FAQ](https://docs.sud.tech/zh-CN/app/Client/FAQ/)

# 2. SudMGPWrapper
- `SudMGPWrapper封装SudMGP，简化App和游戏相互调用接口`；
- `SudMGPWrapper长期维护和保持更新`；
- `推荐APP接入方使用SudMGPWrapper`；
- `SudMGPAPPState`、`SudMGPMGState`、`SudFSMMGListener`、`SudFSMMGDecorator`、`SudFSTAPPDecorator核心类`；

### 2.1 App状态和游戏状态
- `SudMGPAPPState` 封装 [App通用状态](https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonState.html) ；
- `SudFSTAPPDecorator` 封装 [ISudFSTAPP](https://docs.sud.tech/zh-CN/app/Client/API/ISudFSTAPP.html) 两类接口，[notifyStateChange](https://docs.sud.tech/zh-CN/app/Client/APPFST/CommonState.html) 、 foo；
- `SudFSTAPPDecorator` 负责把每一个App通用状态封装成接口；
    <details>
    <summary>代码框架 objc class SudFSTAPPDecorator</summary>

    ``` objc
    /// app -> 游戏
    @interface SudFSTAPPDecorator : NSObject

    @property (nonatomic, strong) id<ISudFSTAPP> iSudFSTAPP;

    /// setI SudFSTAPP = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:self.sudFSMMGDecorator rootView:rootView];
    - (void)setISudFSTAPP:(id<ISudFSTAPP>)iSudFSTAPP;
    ...

    /// 继续游戏
    - (void)playMG;
    /// 暂停游戏
    - (void)pauseMG;
    /// 销毁游戏
    - (void)destroyMG;
    /// 获取游戏View
    - (UIView *) getGameView;
    /// 更新code
    /// @param code 新的code
    - (void)updateCode:(NSString *) code;
    /// 传输音频数据： 传入的音频数据必须是：PCM格式，采样率：16000， 采样位数：16， 声道数： MONO
    - (void)pushAudio:(NSData *)data;
    @end
    ```
    </details>

### 2.2 游戏调用App
- `SudMGPMGState` 封装 [通用状态-游戏](https://docs.sud.tech/zh-CN/app/Client/MGFSM/CommonStateGame.html) 和 [通用状态-玩家](https://docs.sud.tech/zh-CN/app/Client/MGFSM/CommonStatePlayer.html) ；
- `SudFSMMGListener` 封装[ISudFSMMG](https://docs.sud.tech/zh-CN/app/Client/API/ISudFSMMG.html) 三类回调函数，onGameStateChange、onPlayerStateChange、onFoo；
- `SudFSMMGListener` 负责把游戏每一个状态封装成单独的回调函数；
    <details>
    <summary>代码框架 objc interface SudFSMMGListener</summary>
    
    ``` objc
    @protocol SudFSMMGListener <NSObject>

    @required
    /// 获取游戏View信息  【需要实现】
    - (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;

    /// 短期令牌code过期  【需要实现】
    - (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;

    /// 获取游戏Config  【需要实现】
    - (void)onGetGameCfg:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;


    @optional
    /// 游戏开始
    - (void)onGameStarted;

    /// 游戏销毁
    - (void)onGameDestroyed;

    /// 通用状态-游戏
    /// 游戏: 公屏消息状态    MG_COMMON_PUBLIC_MESSAGE
    - (void)onGameMGCommonPublicMessage:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model;

    ...
    @end
    ```
    </details>

- [ISudFSMMG](https://docs.sud.tech/zh-CN/app/Client/API/ISudFSMMG.html) 的装饰类`SudFSMMGDecorator`，负责派发每一个游戏状态，缓存需要的游戏状态
    <details>
    <summary>class SudFSMMGDecorator</summary>
    
    ``` objc
    /// game -> app
    @interface SudFSMMGDecorator : NSObject <ISudFSMMG>

    typedef NS_ENUM(NSInteger, GameStateType) {
        /// 空闲
        GameStateTypeLeisure = 0,
        /// loading
        GameStateTypeLoading = 1,
        /// playing
        GameStateTypePlaying = 2,
    };

    /// 当前用户ID
    @property(nonatomic, strong, readonly)NSString *currentUserId;
    // 游戏状态枚举： GameStateType
    @property (nonatomic, assign) GameStateType gameStateType;
    /// 当前用户是否加入
    @property (nonatomic, assign) BOOL isInGame;
    /// 是否在游戏中
    @property (nonatomic, assign) BOOL isPlaying;
    
    ...

    /// 设置事件处理器
    /// @param listener 事件处理实例
    - (void)setEventListener:(id<SudFSMMGListener>)listener;
    /// 设置当前用户ID
    /// @param userId 当前用户ID
    - (void)setCurrentUserId:(NSString *)userId;
    /// 清除所有存储数组
    - (void)clearAllStates;
    /// 2MG成功回调
    - (NSString *)handleMGSuccess;
    /// 2MG失败回调
    - (NSString *)handleMGFailure;

    #pragma mark - 获取gamePlayerStateMap中最新的一个状态
    /// 获取用户加入状态
    - (BOOL)isPlayerIn:(NSString *)userId;
    /// 获取用户是否在准备中
    - (BOOL)isPlayerIsReady:(NSString *)userId;
    /// 获取用户是否在游戏中
    - (BOOL)isPlayerIsPlaying:(NSString *)userId;
    /// 获取用户是否在队长
    - (BOOL)isPlayerIsCaptain:(NSString *)userId;
    /// 获取用户是否在在绘画
    - (BOOL)isPlayerPaining:(NSString *)userId;

    #pragma mark - 获取是否存在gamePlayerStateMap中 （用于判断用户是否在游戏里了）
    /// 获取用户是否已经加入了游戏
    - (BOOL)isPlayerInGame:(NSString *)userId;
    @end
    ```
    </details>



# 3. QuickStart
- 3.1 请使用QuickStart项目运行；
- 3.2 QuickStart使用SudMGPWrapper、SudMGPSDK实现快速接入游戏；
- 3.3 快速接入文档：[StartUp-Android](https://docs.sud.tech/zh-CN/app/Client/StartUp-Android.html) 和 [StartUp-iOS](https://docs.sud.tech/zh-CN/app/Client/StartUp-iOS.html)
- 3.4 `QuickStartViewController(Game)`游戏部分相关调用逻辑：负责login(App getCode) --> SudMGP.initSDK --> SudMGP.loadMG
- 3.5 `QuickStartViewController`展示游戏房相关UI展示
- 3.6 `QuickStart 服务端`[hello-sud-java](https://github.com/SudTechnology/hello-sud-java) ，login(App getCode 获取短期令牌code) ，`如果访问不了，请联系SUD添加，github账号`

# 4. QuickStart运行效果图
![QuickStartHome.PNG](./doc/QuickStartHome.PNG)
![QuickStartGame.PNG](./doc/QuickStartGame.PNG)

- HelloSud体验Demo（展示多业务场景）

![Android](doc/hello_sudplus_android.png)
![iPhone](doc/hello_sudplus_iphone.png)

# 5. 接入方客户端和SudMGP SDK调用时序图
![AppCallSudMGPSeqDiag.png](doc/AppCallSudMGPSeqDiag.png)
