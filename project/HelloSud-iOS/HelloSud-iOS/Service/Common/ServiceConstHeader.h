//
//  ServiceConstHeader.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/19.
//

#ifndef ServiceConstHeader_h
#define ServiceConstHeader_h

#if DEBUG
#define InteractURL      @"https://fat-interact.sud.tech"
#define BaseURL          @"https://fat-base.sud.tech"
#define GameURL          @"https://fat-game.sud.tech"
#define GAME_TEST_ENV    YES
#else
#define InteractURL      @"https://interact-hello-sud.sud.tech"
#define BaseURL          @"https://base-hello-sud.sud.tech"
#define GameURL          @"https://game.sud.tech"
#define GAME_TEST_ENV    NO

#endif

#define kBASEURL(url) [NSString stringWithFormat:@"%@/%@",BaseURL, url]
#define kINTERACTURL(url) [NSString stringWithFormat:@"%@/%@",InteractURL, url]
#define kGameURL(url) [NSString stringWithFormat:@"%@/%@",GameURL, url]
#endif /* ServiceConstHeader_h */
