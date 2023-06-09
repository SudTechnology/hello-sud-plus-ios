# Start your journey with SUD games through quick integration and debugging
- Step 1: Integrate SUD games into your app client (3-minute code integration)
  <details> 
  <summary>Details</summary> 

      1. Use the QuickStart client's appId, appKey, and set isTestEnv=true; 
      2. Use your own iOS bundleId and Android applicationId (found in the integration information table); 
      3. Use the short-term token code provided by QuickStart's backend service (obtained through login/getCode); 
      4. Once integrated, the game should run smoothly. 

      ***SUD platform supports multiple bundleIds and applicationIds bound to a single appId;*** 
      ***After filling out the integration information table, SUD will bind your app's bundleId and applicationId to QuickStart's appId, only in the test environment.*** 
  QuickStart backend service [hello-sud-java code repository](https://github.com/SudTechnology/hello-sud-java). If you cannot access the repository, please contact SUD to add your GitHub account.
  </details> 


- Step 2: Debug the app client and server
  <details> 
  <summary>Details</summary> 

      1. Implement 4 HTTP APIs on the app server (as listed in the integration information table); 
      2. Implement the login/getCode interface on the app server to obtain the short-term token code; 
      3. Use your own appId, appKey, isTestEnv=true, bundleId (iOS), and applicationId (Android); 
      4. Use your own app server's login/getCode interface to obtain the short-term token code; 
      5. Debug 5 HTTP APIs between the app client and server; 
      6. Once HTTP API debugging is complete, move on to the next step. 
  </details> 


- Step 3: Focus on your own app's business needs
  <details> 
  <summary>Details</summary> 

      1. Refer to the SudMGP documentation, SudMGPWrapper, QuickStart, and the HelloSud demo (which showcases multiple scenarios, including custom scenarios); 
      2. Focus on your app's UI interaction, functionality, and implementation; 
      For example: 
      Adjusting the size and position of the game view; 
      Adjusting the interaction flow between the app and game, whether UI elements can be hidden, whether buttons can be hidden in the app implementation, and whether click events can be intercepted for callbacks; 
       
      3. Focus on your app's business logic and implementation; 
      For example: 
      How to pass numerical type parameters and key type parameters during a game (settlement); 
  ![Android](doc/hello_sudplus_android.png)
  ![iPhone](doc/hello_sudplus_iphone.png)
  </details>

# 3-Minute Code Integration
- Step 1: Import SudMGPSDK and SudMGPWrapper modules
  <details> 
  <summary>Local pod import method</summary> 

      1. Copy all files in the SudMGPSDK and SudMGPWrapper directories, as well as the SudMGPWrapper.podspec file, to the target project's Podfile directory. 
      2. Add SudMGPWrapper dependency to the app's main Podfile;
  ```ruby
  pod 'SudMGPWrapper', :path => './'
  ```
      3. Run pod install to add SudMGP SDK and SudMGPWrapper module dependencies to the project.
  </details> 
  <details> 
  <summary>CocoaPods import method</summary> 

      1. Add SudMGPWrapper dependency to the app's main Podfile;
  ```ruby
  pod 'SudMGPWrapper', '~> 1.5.8'
  ```
      2. Run pod install to add SudMGP SDK and SudMGPWrapper module dependencies to the project.
  </details> 
  <details> 
  <summary>ASR recognition support (optional, supported in v1.2.7 and later)</summary> 

      1. Add ASR speech recognition library dependency to the app's main Podfile;
  ```ruby 
  pod 'MicrosoftCognitiveServicesSpeech-iOS', '1.23.0'
  ```
      3. Run pod install to add the ASR speech recognition library module dependencies to the project.
  </details> 

- Step 2: Copy two QuickStart files and keep the configuration parameters unchanged
  <details> 
  <summary>Details</summary> 

      1. Copy two files from the demo project directory (QuickStart->UI->VC): 
        QuickStartViewController+Game.h 
        QuickStartViewController+Game.m 
      2. Keep the configuration parameters unchanged, using the appId and appKey from QuickStart 
        QuickStartViewController+Game.h
    ```objc
    // TODO: Login URL for the server
    #define GAME_LOGIN_URL          @"https://fat-mgp-hello.sudden.ltd/login/v2"
    
        // TODO: Must fill in the appId and appKey provided by SudMGP
        #define SUDMGP_APP_ID                  @"1461564080052506636"
        #define SUDMGP_APP_KEY                 @"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"
    
        // TODO: Whether it is a test environment, the production environment must be set to NO
        #if DEBUG
        #define GAME_TEST_ENV    YES
        #else
        #define GAME_TEST_ENV    NO
        #endif
    ```
     3. Change the category name of QuickStartViewController+Game to the corresponding name of the target ViewController
     4. Keep using QuickStart backend service login/getCode;
        4.1 Implement app quick loading and running the game using QuickStart service;
        4.2 After filling out the integration information table, in the test environment, the app's bundleId and applicationId will be added to QuickStart's appId;
  </details> 

- Step 3: Define a game view container in the target ViewController, e.g., QuickStartViewController.h
  <details> 
  <summary>Details for QuickStartViewController.h</summary>
  
  ```objc
  @interface QuickStartViewController ()
  /// Main game loading view
  @property(nonatomic, strong) UIView *gameView;
  ```
  </details> 

- Step 4: Create a SudMDPWrapper instance, e.g., QuickStartViewController.m
  <details> 
  <summary>Details for QuickStartViewController.m</summary>
  
  ```objc
  - (void)viewDidLoad {
    [super viewDidLoad];
  
    // 1. Create SudMDPWrapper
    [self createSudMGPWrapper];
  
    ...
    }
  ```
  </details> 

- Step 5: Load the game
  <details> 
  <summary>Details for QuickStartViewController.m</summary>

  ```objc
  - (void)viewDidLoad {
    [super viewDidLoad];
  
    /// Game loading steps
  
    // Create SudMDPWrapper
    [self createSudMGPWrapper];
  
    // Configure necessary parameters for loading SudMGP
    SudMGPLoadConfigModel *sudGameConfigModel = [[SudMGPLoadConfigModel alloc] init];
    // SudMGP platform 64bit game ID (this ID is bound to QuickStart. After replacing the Sud platform AppId, please modify the corresponding mgId)
    sudGameConfigModel.mgId = 1461227817776713818;
    // Room ID
    sudGameConfigModel.roomId = @"10000";
    // Game language
    sudGameConfigModel.language = @"zh-CN";
    // Game view
    sudGameConfigModel.gameView = self.gameView;
    // User ID of the currently logged-in user in the app
    sudGameConfigModel.userId = @"123456";
  
    // Load the game
    if (sudGameConfigModel.mgId > 0) {
    [self loginGame:self.sudMGPLoadConfigModel];
    }
    }
  ```
  </details> 

- Step 6: Destroy the game
  <details> 
  <summary>Details for QuickStartViewController+Game.m</summary>
  
  ```objc
      /// 3: Logout of the game and destroy SudMGP SDK
      - (void)logoutGame {
        // Destroy the game
        [self.sudFSMMGDecorator clearAllStates];
        [self.sudFSTAPPDecorator destroyMG];
        }
  ```
  </details>

# QuickStart Architecture Diagram
![QuickStartArch.png](doc/QuickStartArch.png)

# 1. SudMGP SDK
### 1.1 SudMGP Client SDK

- [Download SudMGP-Android-v1.1.52.554.zip](https://github.com/SudTechnology/sud-mgp-android/releases)
- [Download SudMGP-iOS-v1.1.52.527.zip](https://github.com/SudTechnology/sud-mgp-ios/releases)

### 1.2 Integration Documentation

- [Integration Documentation](https://docs.sud.tech/en/app/Client/API/)
- [FAQ](https://docs.sud.tech/en/app/Client/FAQ/)

# 2. SudMGPWrapper
-  SudMGPWrapper encapsulates SudMGP and simplifies the interface for app and game interaction ;
-  SudMGPWrapper is maintained and updated regularly ;
-  It is recommended for app integration to use SudMGPWrapper ;
-  SudMGPAPPState ,  SudMGPMGState ,  SudFSMMGListener ,  SudFSMMGDecorator ,  SudFSTAPPDecorator are core classes .

### 2.1 App State and Game State
-  SudMGPAPPState  encapsulates [App Common State](https://docs.sud.tech/en/app/Client/APPFST/CommonState.html);
-  SudFSTAPPDecorator  encapsulates two types of [ISudFSTAPP](https://docs.sud.tech/en/app/Client/API/ISudFSTAPP.html) interfaces, [notifyStateChange](https://docs.sud.tech/en/app/Client/APPFST/CommonState.html) and foo;
-  SudFSTAPPDecorator  is responsible for encapsulating each App common state into an interface;
    <details> 
    <summary>Code framework objc class SudFSTAPPDecorator</summary>

    ```objc
    /// app -> game
    @interface SudFSTAPPDecorator : NSObject
    
        @property (nonatomic, strong) id<ISudFSTAPP> iSudFSTAPP;
    
        /// setI SudFSTAPP = [SudMGP loadMG:userId roomId:roomId code:code mgId:mgId language:language fsmMG:self.sudFSMMGDecorator rootView:rootView];
        - (void)setISudFSTAPP:(id<ISudFSTAPP>)iSudFSTAPP;
        ...
    
        /// Continue the game
        - (void)playMG;
        /// Pause the game
        - (void)pauseMG;
        /// Destroy the game
        - (void)destroyMG;
        /// Get the game view
        - (UIView *) getGameView;
        /// Update code
        /// @param code New code
        - (void)updateCode:(NSString *) code;
        /// Transfer audio data: The input audio data must be: PCM format, sample rate: 16000, sample depth: 16, channel number: MONO
        - (void)pushAudio:(NSData *)data;
        @end
     ```
    </details> 

### 2.2 Game Calls App
-  SudMGPMGState  encapsulates [Common State - Game](https://docs.sud.tech/en/app/Client/MGFSM/CommonStateGame.html) and [Common State - Player](https://docs.sud.tech/en/app/Client/MGFSM/CommonStatePlayer.html);
-  SudFSMMGListener  encapsulates three types of [ISudFSMMG](https://docs.sud.tech/en/app/Client/API/ISudFSMMG.html) callback functions, onGameStateChange, onPlayerStateChange, and onFoo;
-  SudFSMMGListener  is responsible for encapsulating each game state into a separate callback function;
    <details> 
    <summary>Code framework objc interface SudFSMMGListener</summary>

    ```objc
    @protocol SudFSMMGListener <NSObject>
    
        @required
        /// Get game view information  【Need to implement】
        - (void)onGetGameViewInfo:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;
    
        /// Short-term token code expires  【Need to implement】
        - (void)onExpireCode:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;
    
        /// Get game config  【Need to implement】
        - (void)onGetGameCfg:(nonnull id<ISudFSMStateHandle>)handle dataJson:(nonnull NSString *)dataJson;
    
    
        @optional
        /// Game starts
        - (void)onGameStarted;
    
        /// Game destroyed
        - (void)onGameDestroyed;
    
        /// Common state - game
        /// Game: Public screen message state    MG_COMMON_PUBLIC_MESSAGE
        - (void)onGameMGCommonPublicMessage:(nonnull id<ISudFSMStateHandle>)handle model:(MGCommonPublicMessageModel *)model;
    
        ...
        @end
    ```
    </details> 

  - [ISudFSMMG](https://docs.sud.tech/en/app/Client/API/ISudFSMMG.html) decorator class  SudFSMMGDecorator , responsible for dispatching each game state, caching required game states
      <details> 
      <summary>class SudFSMMGDecorator</summary>

    ```objc
    /// game -> app
    @interface SudFSMMGDecorator : NSObject <ISudFSMMG>
  
        typedef NS_ENUM(NSInteger, GameStateType) {
            /// Idle
            GameStateTypeLeisure = 0,
            /// loading
            GameStateTypeLoading = 1,
            /// playing
            GameStateTypePlaying = 2,
        };
  
        /// Current user ID
        @property(nonatomic, strong, readonly)NSString *currentUserId;
        // Game state enumeration: GameStateType
        @property (nonatomic, assign) GameStateType gameStateType;
        /// Whether the current user has joined
        @property (nonatomic, assign) BOOL isInGame;
        /// Whether it is in the game
        @property (nonatomic, assign) BOOL isPlaying;
      
        ...
  
        /// Set event handler
        /// @param listener Event handling instance
        - (void)setEventListener:(id<SudFSMMGListener>)listener;
        /// Set the current user ID
        /// @param userId Current user ID
        - (void)setCurrentUserId:(NSString *)userId;
        /// Clear all stored arrays
        - (void)clearAllStates;
        /// 2MG success callback
        - (NSString *)handleMGSuccess;
        /// 2MG failure callback
        - (NSString *)handleMGFailure;
  
        #pragma mark - Get the latest state in gamePlayerStateMap
        /// Get user join status
        - (BOOL)isPlayerIn:(NSString *)userId;
        /// Whether the user is in preparation
        - (BOOL)isPlayerIsReady:(NSString *)userId;
        /// Whether the user is in the game
        - (BOOL)isPlayerIsPlaying:(NSString *)userId;
        /// Whether the user is the captain
        - (BOOL)isPlayerIsCaptain:(NSString *)userId;
        /// Whether the user is painting
        - (BOOL)isPlayerPaining:(NSString *)userId;
  
        #pragma mark - Check if it exists in gamePlayerStateMap (used to determine if the user is in the game)
        /// Whether the user has joined the game
        - (BOOL)isPlayerInGame:(NSString *)userId;
        @end
    ```
    </details>

# 3. QuickStart
- 3.1 Please use the QuickStart project to run.
- 3.2 QuickStart uses SudMGPWrapper and SudMGPSDK to enable fast integration of games.
- 3.3 Quick integration guides: [StartUp-Android](https://docs.sud.tech/zh-CN/app/Client/StartUp-Android.html) and [StartUp-iOS](https://docs.sud.tech/zh-CN/app/Client/StartUp-iOS.html).
- 3.4  QuickStartViewController(Game)  contains the relevant call logic for the game section, which is responsible for login (App getCode) --> SudMGP.initSDK --> SudMGP.loadMG.
- 3.5  QuickStartViewController  displays the relevant UI for the game room.
- 3.6  QuickStart Server  [hello-sud-java](https://github.com/SudTechnology/hello-sud-java) contains the login (App getCode to obtain a short-term token code) functionality. If it cannot be accessed, please contact SUD to add the GitHub account.

# 4. QuickStart Running Screenshots
![QuickStartHome.PNG](./doc/QuickStartHome.PNG)
![QuickStartGame.PNG](./doc/QuickStartGame.PNG)

- HelloSud Experience Demo (showcasing multiple business scenarios)

![Android](doc/hello_sudplus_android.png)
![iPhone](doc/hello_sudplus_iphone.png)

# 5. Sequence Diagram of Client App and SudMGP SDK Calls
![AppCallSudMGPSeqDiag.png](doc/AppCallSudMGPSeqDiag.png)


