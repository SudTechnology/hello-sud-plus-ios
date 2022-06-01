//
//  QSSudMGPConfigHeader.h
//  QuickStart
//
//  Created by kaniel on 2022/5/26.
//  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
//

#ifndef QSSudMGPConfigHeader_h
#define QSSudMGPConfigHeader_h
/// SudMGPSDK相关配置

// TODO: 登录接入方服务器url
#define SUDMGP_GAME_LOGIN_URL          @"https://fat-mgp-hello.sudden.ltd/login/v2"

// TODO: 必须填写由SudMGP提供的appId 及 appKey
#define SUDMGP_APP_ID                  @"1461564080052506636"
#define SUDMGP_APP_KEY                 @"03pNxK2lEXsKiiwrBQ9GbH541Fk2Sfnc"

// TODO: 是否是测试环境,生产环境必须设置为NO
#if DEBUG
#define GAME_TEST_ENV    YES
#else
#define GAME_TEST_ENV    NO
#endif

#endif /* QSSudMGPConfigHeader_h */
