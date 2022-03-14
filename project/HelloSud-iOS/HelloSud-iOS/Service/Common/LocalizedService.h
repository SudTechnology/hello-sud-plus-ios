#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN 
@interface NSString(Localized)
- (NSString *)localized;
/* 
  Localizable.strings
  HelloSud-iOS

  Created by Mary on 2022/3/14.
  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
*/

/// 登录
+ (NSString *)login_welcome_helloSud;
+ (NSString *)login_we_take_information;
+ (NSString *)login_user_agreement;
+ (NSString *)login_and;
+ (NSString *)login_privacy_policy;
+ (NSString *)login_click_agree_agreement;
+ (NSString *)login_welcome_to_the;
+ (NSString *)login_your_nickname;
+ (NSString *)login_experience_immediately;
+ (NSString *)login_warm_prompt;
+ (NSString *)login_warm_prompt_des;
+ (NSString *)login_agree_continue;
+ (NSString *)login_quit_application;

/// common
+ (NSString *)common_agree;
+ (NSString *)common_not_agree;

// Main
+ (NSString *)dt_tab_home;
+ (NSString *)dt_tab_room;
+ (NSString *)dt_tab_setting;

@end
NS_ASSUME_NONNULL_END
