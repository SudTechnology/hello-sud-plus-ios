#import "LocalizedService.h"

 @implementation NSString(Localized)
- (NSString *)localized { return NSLocalizedString(self, comment: self); }
/*
  Localizable.strings
  HelloSud-iOS

  Created by Mary on 2022/3/14.
  Copyright © 2022 Sud.Tech (https://sud.tech). All rights reserved.
*/

/// Login
+ (NSString *)dt_login_welcome_helloSud { return @"dt_login_welcome_helloSud".localized; }
+ (NSString *)dt_login_we_take_information { return @"dt_login_we_take_information".localized; }
+ (NSString *)dt_login_user_agreement { return @"dt_login_user_agreement".localized; }
+ (NSString *)dt_login_and { return @"dt_login_and".localized; }
+ (NSString *)dt_login_privacy_policy { return @"dt_login_privacy_policy".localized; }
+ (NSString *)dt_login_click_agree_agreement { return @"dt_login_click_agree_agreement".localized; }
+ (NSString *)dt_login_welcome_to_the { return @"dt_login_welcome_to_the".localized; }
+ (NSString *)dt_login_your_nickname { return @"dt_login_your_nickname".localized; }
+ (NSString *)dt_login_experience_immediately { return @"dt_login_experience_immediately".localized; }
+ (NSString *)dt_login_warm_prompt { return @"dt_login_warm_prompt".localized; }
+ (NSString *)dt_login_warm_prompt_des { return @"dt_login_warm_prompt_des".localized; }
+ (NSString *)dt_login_agree_continue { return @"dt_login_agree_continue".localized; }
+ (NSString *)dt_login_quit_application { return @"dt_login_quit_application".localized; }

/// Settings
+ (NSString *)dt_settings_total { return @"dt_settings_total".localized; }
+ (NSString *)dt_settings_size_occupied { return @"dt_settings_size_occupied".localized; }
+ (NSString *)dt_settings_set { return @"dt_settings_set".localized; }
+ (NSString *)dt_settings_version_info { return @"dt_settings_version_info".localized; }
+ (NSString *)dt_settings_switch_rtc { return @"dt_settings_switch_rtc".localized; }
+ (NSString *)dt_settings_zego { return @"dt_settings_zego".localized; }
+ (NSString *)dt_settings_agora { return @"dt_settings_agora".localized; }
+ (NSString *)dt_settings_net_ease { return @"dt_settings_net_ease".localized; }
+ (NSString *)dt_settings_volcano { return @"dt_settings_volcano".localized; }
+ (NSString *)dt_settings_alicloud { return @"dt_settings_alicloud".localized; }
+ (NSString *)dt_settings_tencent { return @"dt_settings_tencent".localized; }
+ (NSString *)dt_settings_switch_language { return @"dt_settings_switch_language".localized; }
+ (NSString *)dt_settings_open_source { return @"dt_settings_open_source".localized; }
+ (NSString *)dt_settings_user_agreement { return @"dt_settings_user_agreement".localized; }
+ (NSString *)dt_settings_privacy_policy { return @"dt_settings_privacy_policy".localized; }
+ (NSString *)dt_settings_contact_us { return @"dt_settings_contact_us".localized; }
+ (NSString *)dt_settings_work_in_progress { return @"dt_settings_work_in_progress".localized; }
+ (NSString *)dt_settings_confirm_switch_rtc { return @"dt_settings_confirm_switch_rtc".localized; }


/// common
+ (NSString *)dt_common_agree { return @"dt_common_agree".localized; }
+ (NSString *)dt_common_not_agree { return @"dt_common_not_agree".localized; }
+ (NSString *)dt_common_sure { return @"dt_common_sure".localized; }
+ (NSString *)dt_common_cancel { return @"dt_common_cancel".localized; }

@end
