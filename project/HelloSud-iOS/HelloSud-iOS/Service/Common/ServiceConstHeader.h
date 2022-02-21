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
#else
#define InteractURL      @"https://interact-hello-sud.sud.tech"
#define BaseURL          @"https://base-hello-sud.sud.tech"
#endif

#define kBASEURL(url) [NSString stringWithFormat:@"%@/%@",BaseURL, url]
#define kINTERACTURL(url) [NSString stringWithFormat:@"%@/%@",InteractURL, url]
#endif /* ServiceConstHeader_h */
