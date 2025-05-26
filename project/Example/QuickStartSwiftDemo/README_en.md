# SwiftDemo of SudMGP

- Step 1: Add the SudMGP library dependency in the Podfile:

  ```ruby
    pod 'SudGIP', 'x.x.x'
    pod 'SudGIPWrapper'
  ```

- 2: Copy reusable code files into the project under SudGameHelper.
- 3: Create a bridging header file named xxxx-Bridging-Header.h and import the game operation header files inside it:
  ```objc
   #import "SudGameManager.h"
  ```
- Step 4: Create a class that inherits from SudGameBaseEventHandler and implement the necessary return data, referencing QuickStartSudGameEventHandler.QuickStartSudGameEventHandler
- Step 5: Create a game operation object where the game is used, implementing load and destroy:

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
