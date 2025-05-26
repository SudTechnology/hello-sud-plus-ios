[English](README_en.md)

# SwiftDemo of SudMGP

- 第一步：在 podfile 文件中依赖 SudMGP 库:

  ```ruby
    pod 'SudGIP', 'x.x.x'
    pod 'SudGIPWrapper'
  ```

- 第二步：复制可复用代码文件到项目中 SudGameHelper
- 第三步：创建项目桥接文件 xxxx-Bridging-Header.h 并在里面引入游戏操作头文件
  ```objc
   #import "SudGameManager.h"
  ```
- 第四步：创建继承于游戏 SudGameBaseEventHandler 操作类，并实现必要返回数据，参考 QuickStartSudGameEventHandler
- 第五步：在使用游戏的地方创建游戏操作对象，实现加载并销毁

  ```objc
   // game operation object
   let gameEventHandler:QuickStartSudGameEventHandler = QuickStartSudGameEventHandler()
   let sudGameManager = SudGameManager()

       /// Load game
   func loadGame(gameId: Int64) {
       // Set the required parameters for loading SudMGP
       let sudGameConfigModel = SudGameLoadConfigModel()

       // Application ID
       sudGameConfigModel.appId = SUDMGP_APP_ID
       // Application key
       sudGameConfigModel.appKey = SUDMGP_APP_KEY
       // Set to YES during the test and NO when publishing online
       sudGameConfigModel.isTestEnv = true
       // ID of the game to be loaded
       sudGameConfigModel.gameId = gameId
       // Assign a game room, and people with the same room number are in the same game hall
       sudGameConfigModel.roomId = self.roomId
       // Configure the in-game display language
       sudGameConfigModel.language = "us-EN"
       // Game display view
       sudGameConfigModel.gameView = self.gameView
       // Current user id
       sudGameConfigModel.userId = self.userId

       self.sudGameManager.loadGame(sudGameConfigModel)
   }

   /// Destroy game
   func destroyGame() {
       self.sudGameManager.destroyGame()
   }
  ```
