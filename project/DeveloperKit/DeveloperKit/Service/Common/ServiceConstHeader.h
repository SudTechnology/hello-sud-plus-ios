//
//  ServiceConstHeader.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/19.
//

#ifndef ServiceConstHeader_h
#define ServiceConstHeader_h

#if DEBUG
#define InteractURL      @"https://fat-interact-hello-sud.sud.tech"
#define BaseURL          @"https://fat-base-hello-sud.sud.tech"
#define GameURL          @"https://fat-game-hello-sud.sud.tech"

#define BASE_MGPURL      @"https://mgp-hello.sudden.ltd"
#define GAME_TEST_ENV    YES
#else
#define InteractURL      @"https://interact-hello-sud.sud.tech"
#define BaseURL          @"https://base-hello-sud.sud.tech"
#define GameURL          @"https://game-hello-sud.sud.tech"

#define BASE_MGPURL      @"https://mgp-hello.sudden.ltd"
#define GAME_TEST_ENV    NO
#endif

#define kBASEURL(url) [NSString stringWithFormat:@"%@/%@",BaseURL, url]
#define kINTERACTURL(url) [NSString stringWithFormat:@"%@/%@",InteractURL, url]
#define kGameURL(url) [NSString stringWithFormat:@"%@/%@",GameURL, url]

#define kMGPURL(path) [NSString stringWithFormat:@"%@/%@", BASE_MGPURL, path]
#endif /* ServiceConstHeader_h */
