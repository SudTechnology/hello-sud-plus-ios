//
//  ViewController.swift
//  QuickStartSwiftDemo
//
//  Created by kaniel on 2/13/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let roomBgView = UIImageView(image: UIImage(named: "room_bg"))
    let gameView = UIView()
    let startGameBtn = UIButton()
    let destroyGameBtn = UIButton()
    
    // game config
    let SUDMGP_APP_ID   = "1461564080052506636"
    let SUDMGP_APP_KEY  = "03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"
    let roomId = "1234"
    let gameId:Int64 = 1461228410184400899
    let userId = "1233"
    // game operation object
    let gameEventHandler:QuickStartSudGameEventHandler = QuickStartSudGameEventHandler()
    let sudGameManager = SudGameManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configRoomUI()
        initConfigGameObjects()
        
    }
    
    func initConfigGameObjects() {
        sudGameManager.registerGameEventHandler(gameEventHandler)
    }
    
    /// Load game
    func loadGame(gameId: Int64) {
        // Set the required parameters for loading SudMGP
        let sudGameConfigModel = SudGameLoadConfigModel()
        
        // Application ID
        sudGameConfigModel.appId = SUDMGP_APP_ID
        // Application key
        sudGameConfigModel.appKey = SUDMGP_APP_KEY
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
        self.sudGameManager.loadGame(sudGameConfigModel, success: nil)
    }

    /// Destroy game
    func destroyGame() {
        self.sudGameManager.destroyGame()
    }
    
    func configRoomUI() {
        view.addSubview(roomBgView)
        view.addSubview(gameView)
        view.addSubview(startGameBtn)
        view.addSubview(destroyGameBtn)
        startGameBtn.setTitle("StartGame", for: .normal)
        destroyGameBtn.setTitle("DestroyGame", for: .normal)
        startGameBtn.backgroundColor = .orange
        destroyGameBtn.backgroundColor = .orange
        startGameBtn.addTarget(self, action: #selector(onStartGameBtnClick), for: .touchUpInside)
        destroyGameBtn.addTarget(self, action: #selector(onDestroyGameBtnClick), for: .touchUpInside)
        
        roomBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        startGameBtn.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(120)
            make.bottom.equalTo(-80)
            make.centerX.equalTo(view.snp.centerX).offset(-70)
        }
        destroyGameBtn.snp.makeConstraints { make in
            make.width.height.equalTo(startGameBtn)
            make.leading.equalTo(startGameBtn.snp.trailing).offset(20)
            make.bottom.equalTo(startGameBtn)
        }
    }

    @objc func onStartGameBtnClick(sender:UIButton) {
        print("click start game")
        loadGame(gameId: Int64(gameId))
    }
    
    @objc func onDestroyGameBtnClick(sender:UIButton) {
        print("click start game")
        destroyGame()
    }
    


}

