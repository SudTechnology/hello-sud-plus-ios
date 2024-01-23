[English](README_en.md)

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
    <summary>cocoapods方式导入，推荐使用该方式导入</summary>

      1. APP主工程Podfile文件中，添加 SudMGPWrapper 依赖;
   [Cocoapods最新集成版本](https://github.com/SudTechnology/sud-mgp-ios)
  ``` ruby
  pod 'SudMGPWrapper', '~> x.x.x'
  
  ```
      2. 执行pod install，将SudMGP SDK、SudMGPWrapper模块依赖进工程中

  </details>
  <details>
  <summary>本地pod方式导入</summary>

      1. 将QuickStart同级目录下的SudMGPSDK、SudMGPWrapper两个目录所有文件及SudMGPWrapper.podspec文件拷贝到目标工程Podfile所在的目录下

      2. APP主工程Podfile文件中，添加 SudMGPWrapper 依赖;
  ``` ruby
  pod 'SudMGPWrapper', :path => '../../'
  ```
      3. 执行pod install，将SudMGP SDK、SudMGPWrapper模块依赖进工程中
  </details>
  <details>

  <summary>ASR识别支持（可选，只有用到游戏语音识别才需要用 v1.2.7及后续版本支持）</summary>

      1. APP主工程Podfile文件中，添加 ASR语音识别库 依赖;
  ``` ruby
  pod 'MicrosoftCognitiveServicesSpeech-iOS', '1.23.0'
  ```
      2. 执行pod install，将ASR语音识别库模块依赖进工程中
  </details>
  

- 第二步：复用QuickStart对游戏操作管理模块，位于项目SudGameHelper文件夹中
  <details>
  <summary>详细描述</summary>

      拷贝SudGameHelper目录，Demo工程目录路径(project->SudGameHelper):
        SudGameManager 为加载游戏、销毁游戏管理模块
        BaseSudGameEventHandler 为游戏与APP交互处理模块，应用只需创建改子类并接收定义好的游戏回调即可收到游戏各种状态回调
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
  
- 第四步：创建一个游戏交互事件处理子类继承自BaseSudGameEventHandler,并实现必要接口，例如：
    <details>
    <summary>`QuickStartSudGameEventHandler`详细描述 </summary>

    #### 类声明 QuickStartSudGameEventHandler.h
    ``` objc
    /// QuickStart demo实现游戏事件处理模块，接入方可以参照次处理模块，将QuickStartSudGameEventHandler改个名称并实现自己应用的即可
    /// QuickStart demo game event processing module, access can consult the processing module, the QuickStartSudGameEventHandler change a name and realize their own application
    @interface QuickStartSudGameEventHandler : BaseSudGameEventHandler
    @end
    ```
    #### 实现必要接口 详细描述 QuickStartSudGameEventHandler.m

    1.  返回游戏配置，主要配置游戏模式、按钮自定义等UI，如以下样例配置：

    ``` objc
    - (nonnull GameCfgModel *)onGetGameCfg {
        GameCfgModel *gameCfgModel = [GameCfgModel defaultCfgModel];
        /// 可以在此根据自身应用需要配置游戏，例如配置声音
        /// You can configure the game according to your application needs here, such as configuring the sound
        gameCfgModel.gameSoundVolume = 100;
        /// ...
        return gameCfgModel;
    }
    ```

    2. 返回游戏视图整体区域大小、安全区（顶底预留间距），如以下样例配置：

    ``` objc
    - (nonnull GameViewInfoModel *)onGetGameViewInfo {
    
        /// 应用根据自身布局需求在此配置游戏显示视图信息
        /// The application configures the game display view information here according to its layout requirements
        
        // 屏幕安全区
        // Screen Safety zone
        UIEdgeInsets safeArea = [self safeAreaInsets];
        // 状态栏高度
        // Status bar height
        CGFloat statusBarHeight = safeArea.top == 0 ? 20 : safeArea.top;
        
        GameViewInfoModel *m = [[GameViewInfoModel alloc] init];
        CGRect gameViewRect = self.loadConfigModel.gameView.bounds;

        // 游戏展示区域
        // Game display area
        m.view_size.width = gameViewRect.size.width;
        m.view_size.height = gameViewRect.size.height;
        // 游戏内容布局安全区域，根据自身业务调整顶部间距
        // Game content layout security area, adjust the top spacing according to their own business
        // 顶部间距
        // top spacing
        m.view_game_rect.top = (statusBarHeight + 80);
        // 左边
        // Left
        m.view_game_rect.left = 0;
        // 右边
        // Right
        m.view_game_rect.right = 0;
        // 底部安全区域
        // Bottom safe area
        m.view_game_rect.bottom = (safeArea.bottom + 100);
        return m;
    }
    ```

    3. 返回游戏加载时code，<font color=Red>此接口接入方必须继承实现，通过自身应用接口去获取加载游戏时需要code码</font>

    ``` objc
    - (void)onGetCode:(NSString *)userId result:(void (^)(NSString * _Nonnull))result {
    
        /// 获取加载游戏的code,此处请求自己服务端接口获取code并回调返回即可
        /// Get the code of loading the game, here request your server interface to get the code and callback return
        
        if (userId.length == 0) {
            NSLog(@"用户ID不能为空");
            return;
        }
        
        /// 以下是当前demo向demo应用服务获取code的代码
        /// The following is the code that demo obtains the code from demo application service
        
        /// 此接口为QuickStart样例请求接口
        /// This interface is a QuickStart sample request interface
        NSString *getCodeUrl = @"https://mgp-hello.sudden.ltd/login/v3";
        NSDictionary *dicParam = @{@"user_id": userId};
        [self postHttpRequestWithURL:getCodeUrl param:dicParam success:^(NSDictionary *rootDict) {

            NSDictionary *dic = [rootDict objectForKey:@"data"];
            /// 这里的code用于登录游戏sdk服务器
            /// The code here is used to log in to the game sdk server
            NSString *code = [dic objectForKey:@"code"];
            int retCode = (int) [[dic objectForKey:@"ret_code"] longValue];
            result(code);

        }                    failure:^(NSError *error) {
            NSLog(@"login game server error:%@", error.debugDescription);
        }];
    
    }
    ```
    </details>

- 第五步：创建SudGameManager游戏管理模块实例、游戏事件处理模块实例QuickStartSudGameEventHandler，例如：QuickStartViewController.m
    <details>
    <summary>详细描述 QuickStartViewController.m</summary>

    ```objc
    - (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.blackColor;
        
        /// 1. step
        
        // 创建游戏管理实例
        // Create a game management instance
        self.sudGameManager = SudGameManager.new;;
        // 创建游戏事件处理对象实例
        // Create an instance of the game event handler object
        self.gameEventHandler = QuickStartSudGameEventHandler.new;
        // 将游戏事件处理对象实例注册进游戏管理对象实例中
        // Register the game event processing object instance into the game management object instance
        [self.sudGameManager registerGameEventHandler:self.gameEventHandler];
    

    }
    ```
    </details>
  

- 第六步：加载游戏
    <details>
    <summary>详细描述 QuickStartViewController.m</summary>


    ``` objc
    /// 加载游戏
    /// Load game
    - (void)loadGame:(int64_t)gameId {
        // 配置加载SudMGP必须参数
        // Set the required parameters for loading SudMGP
        SudGameLoadConfigModel *sudGameConfigModel = [[SudGameLoadConfigModel alloc] init];
        // 申请的应用ID
        // Application ID
        sudGameConfigModel.appId = SUDMGP_APP_ID;
        // 申请的应用key
        // Application key
        sudGameConfigModel.appKey = SUDMGP_APP_KEY;
        // 是否测试环境，测试时为YES, 发布上线设置为NO
        // Set to YES during the test and NO when publishing online
        sudGameConfigModel.isTestEnv = SUD_GAME_TEST_ENV;
        // 待加载游戏ID
        // ID of the game to be loaded
        sudGameConfigModel.gameId = gameId;
        // 指定游戏房间，相同房间号的人在同一游戏大厅中
        // Assign a game room, and people with the same room number are in the same game hall
        sudGameConfigModel.roomId = self.roomId;
        // 配置游戏内显示语言
        // Configure the in-game display language
        sudGameConfigModel.language = @"zh-CN";
        // 游戏显示的视图
        // Game display view
        sudGameConfigModel.gameView = self.gameView;
        // 当前用户ID
        // Current user id
        sudGameConfigModel.userId = QSAppPreferences.shared.currentUserID;

        [self.sudGameManager loadGame:sudGameConfigModel];
    }       
    ```
    </details>
  

- 第七步：销毁游戏
    <details>
    <summary>详细描述 QuickStartViewController.m</summary>

    ``` objc
    /// 销毁游戏
    /// Destroy game
    - (void)destroyGame {
        [self.sudGameManager destroyGame];
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
- 3.4 `SudGameHelper`目录为使用游戏自行封装可复用调用游戏相关接口的模块，可copy到接入应用中复用
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
