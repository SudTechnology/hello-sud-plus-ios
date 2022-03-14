#import "LocalizedService.h"

 @implementation NSString(Localized)
- (NSString *)localized { return NSLocalizedString(self, comment: self); }
/* 
  Localizable.strings
  HelloSud-iOS

  Created by Mary on 2022/3/14.
  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
*/

/// 登录
+ (NSString *)login_welcome_helloSud { return @"login_welcome_helloSud".localized; }
+ (NSString *)login_we_take_information { return @"login_we_take_information".localized; }
+ (NSString *)login_user_agreement { return @"login_user_agreement".localized; }
+ (NSString *)login_and { return @"login_and".localized; }
+ (NSString *)login_privacy_policy { return @"login_privacy_policy".localized; }
+ (NSString *)login_click_agree_agreement { return @"login_click_agree_agreement".localized; }
+ (NSString *)login_welcome_to_the { return @"login_welcome_to_the".localized; }
+ (NSString *)login_your_nickname { return @"login_your_nickname".localized; }
+ (NSString *)login_experience_immediately { return @"login_experience_immediately".localized; }
+ (NSString *)login_warm_prompt { return @"login_warm_prompt".localized; }
+ (NSString *)login_warm_prompt_des { return @"login_warm_prompt_des".localized; }
+ (NSString *)login_agree_continue { return @"login_agree_continue".localized; }
+ (NSString *)login_quit_application { return @"login_quit_application".localized; }

/// Settings
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }
+ (NSString *)settings_ { return @"settings_".localized; }


/// common
+ (NSString *)common_agree { return @"common_agree".localized; }
+ (NSString *)common_not_agree { return @"common_not_agree".localized; }
+ (NSString *)dt_common_select_all { return @"dt_common_select_all".localized; }
+ (NSString *)dt_common_cancel { return @"dt_common_cancel".localized; }

/// Main
+ (NSString *)dt_tab_home { return @"dt_tab_home".localized; }
+ (NSString *)dt_tab_room { return @"dt_tab_room".localized; }
+ (NSString *)dt_tab_setting { return @"dt_tab_setting".localized; }

/// Scenes
+ (NSString *)dt_send { return @"dt_send".localized; }
+ (NSString *)dt_down_mic { return @"dt_down_mic".localized; }
+ (NSString *)dt_down_mic { return @"dt_down_mic".localized; }
+ (NSString *)dt_up_mic { return @"dt_up_mic".localized; }
+ (NSString *)dt_select_person { return @"dt_select_person".localized; }
+ (NSString *)dt_select_gift { return @"dt_select_gift".localized; }
+ (NSString *)dt_send_gift { return @"dt_send_gift".localized; }
+ (NSString *)dt_room_owner { return @"dt_room_owner".localized; }
+ (NSString *)dt_mic_index { return @"dt_mic_index".localized; }
+ (NSString *)dt_mic_name { return @"dt_mic_name".localized; }

@end
