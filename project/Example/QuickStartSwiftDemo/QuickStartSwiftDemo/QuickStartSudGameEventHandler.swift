//
//  QuickStartSudGameEventHandler.swift
//  QuickStartSwiftDemo
//
//  Created by kaniel on 2/13/25.
//

import Foundation


class QuickStartSudGameEventHandler: SudGameBaseEventHandler { // Replace SomeBaseClass with the actual superclass if needed

    // Get game configuration
    override func onGetGameCfg() -> GameCfgModel {
        let gameCfgModel = GameCfgModel.default()
        // Configure game settings as needed
        gameCfgModel.gameSoundVolume = 100
        // Additional configurations can be added here
//         gameCfgModel.ui.join_btn.custom = true // Uncomment if needed
        return gameCfgModel
    }

    // Get game view information
    override func onGetGameViewInfo() -> GameViewInfoModel {
        let m = super.onGetGameViewInfo() // Call the superclass method
        // Configure game display view information according to layout requirements
        let safeArea = self.safeAreaInsets()
        let statusBarHeight = safeArea.top == 0 ? 20 : safeArea.top
        
        m.view_game_rect.top = Int(statusBarHeight + 80)
        m.view_game_rect.left = 0
        m.view_game_rect.right = 0
        m.view_game_rect.bottom = Int(safeArea.bottom + 100)
        
        return m
    }

    // Get code for loading game
    override func onGetCode(_ userId: String, success: @escaping SudGmSuccessStringBlock, fail: @escaping SudGmFailedBlock) {
        // Ensure user ID is not empty
        guard !userId.isEmpty else {
            print("用户ID不能为空")
            fail(-1, "用户ID不能为空")
            return
        }

        // URL for getting code
        let getCodeUrl = "https://prod-hellosud-base.s00.tech/login/v3"
        let dicParam: [String: Any] = ["user_id": userId, "app_id": self.loadConfigModel.appId]

        postHttpRequest(withURL: getCodeUrl, param: dicParam, success: { rootDict in
            if let dic = rootDict["data"] as? [String: Any],
               let code = dic["code"] as? String,
               let retCode = rootDict["ret_code"] as? Int64,
               retCode == 0, !code.isEmpty {
                // Callback the code
                success(code)
            } else {
                fail(-1, "get code error")
            }
        }, failure: { error in
            print("login game server error: \(error.localizedDescription)")
            fail(-1, error.localizedDescription)
        })
    }

    // MARK: - Private Methods

    // Device safety zone
    private func safeAreaInsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        }
        return UIEdgeInsets.zero
    }

    // Basic interface request
    private func postHttpRequest(withURL api: String, param: [String: Any]?, success: @escaping ([String: Any]) -> Void, failure: @escaping (Error) -> Void) {
        guard let url = URL(string: api) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let param = param {
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: param, options: [])
                request.httpBody = bodyData
            } catch {
                failure(error)
                return
            }
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    failure(error)
                    return
                }

                guard let data = data else {
                    failure(NSError(domain: "No data", code: -1, userInfo: nil))
                    return
                }

                do {
                    if let responseObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        success(responseObject)
                    }
                } catch {
                    failure(error)
                }
            }
        }
        dataTask.resume()
    }

    // MARK: - Game Life Cycle Callbacks

    // Game started
    override func onGameStarted() {
        // The game is loaded successfully
        print("Game load finished")
    }

    // Game destroyed
    override func onGameDestroyed() {
        print("Game destroyed")
    }

    // MARK: - Game-related Event Status Callbacks

    // Handle join game button event
    override func onGameMGCommonSelfClickJoinBtn(_ handle: ISudFSMStateHandle, model: MGCommonSelfClickJoinBtn) {
        // Handle the event of the 'Join Game' button from the game screen
        // Execute the application's own logic and notify the game to add the current user
//        self.sudFSTAPPDecorator.notifyAppComonSelf(inV2: true, seatIndex: -1, isSeatRandom: true, teamId: 0)
        
    }
}
