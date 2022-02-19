//
//  ServiceConstHeader.h
//  HelloSud-iOS
//
//  Created by kaniel on 2022/2/19.
//

#ifndef ServiceConstHeader_h
#define ServiceConstHeader_h

#define InteractURL      @"https://fat-interact.sud.tech"
#define BaseURL      @"https://fat-base.sud.tech"
//#define BaseURL      @"http://192.168.101.223:8081"

#define kBASEURL(url) [NSString stringWithFormat:@"%@/%@",BaseURL, url]
#define kINTERACTURL(url) [NSString stringWithFormat:@"%@/%@",InteractURL, url]
#endif /* ServiceConstHeader_h */
