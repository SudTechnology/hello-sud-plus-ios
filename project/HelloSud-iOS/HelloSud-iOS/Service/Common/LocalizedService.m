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
+ (NSString *)dt_login_welcome { return @"dt_login_welcome".localized; }
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
+ (NSString *)dt_settings_version_info { return @"dt_settings_version_info".localized; }
+ (NSString *)dt_settings_switch_rtc { return @"dt_settings_switch_rtc".localized; }
+ (NSString *)dt_settings_zego { return @"dt_settings_zego".localized; }
+ (NSString *)dt_settings_agora { return @"dt_settings_agora".localized; }
+ (NSString *)dt_settings_rong_cloud { return @"dt_settings_rong_cloud".localized; }
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

/// RoomList
+ (NSString *)dt_room_list_room_number { return @"dt_room_list_room_number".localized; }
+ (NSString *)dt_room_list_users { return @"dt_room_list_users".localized; }
+ (NSString *)dt_room_list_scene { return @"dt_room_list_scene".localized; }
+ (NSString *)dt_room_list_no_room_available { return @"dt_room_list_no_room_available".localized; }

/// Home
+ (NSString *)dt_home_user_id { return @"dt_home_user_id".localized; }
+ (NSString *)dt_home_enter_room_num { return @"dt_home_enter_room_num".localized; }
+ (NSString *)dt_home_enter { return @"dt_home_enter".localized; }
+ (NSString *)dt_home_join { return @"dt_home_join".localized; }
+ (NSString *)dt_home_coming_soon { return @"dt_home_coming_soon".localized; }
+ (NSString *)dt_home_create_room { return @"dt_home_create_room".localized; }
+ (NSString *)dt_home_in_game { return @"dt_home_in_game".localized; }

/// common
+ (NSString *)dt_common_select_all { return @"dt_common_select_all".localized; }
+ (NSString *)dt_common_agree { return @"dt_common_agree".localized; }
+ (NSString *)dt_common_not_agree { return @"dt_common_not_agree".localized; }
+ (NSString *)dt_common_sure { return @"dt_common_sure".localized; }
+ (NSString *)dt_common_cancel { return @"dt_common_cancel".localized; }

/// Main
+ (NSString *)dt_tab_home { return @"dt_tab_home".localized; }
+ (NSString *)dt_tab_room { return @"dt_tab_room".localized; }
+ (NSString *)dt_tab_setting { return @"dt_tab_setting".localized; }

/// Scenes
+ (NSString *)dt_send { return @"dt_send".localized; }
+ (NSString *)dt_down_mic { return @"dt_down_mic".localized; }
+ (NSString *)dt_up_mic { return @"dt_up_mic".localized; }
+ (NSString *)dt_select_person { return @"dt_select_person".localized; }
+ (NSString *)dt_select_gift { return @"dt_select_gift".localized; }
+ (NSString *)dt_send_gift { return @"dt_send_gift".localized; }
+ (NSString *)dt_room_owner { return @"dt_room_owner".localized; }
+ (NSString *)dt_mic_index { return @"dt_mic_index".localized; }
+ (NSString *)dt_mic_name { return @"dt_mic_name".localized; }
+ (NSString *)dt_ticket_choose_item_reward { return @"dt_ticket_choose_item_reward".localized; }
+ (NSString *)dt_ticket_choose_item_join { return @"dt_ticket_choose_item_join".localized; }
+ (NSString *)dt_ticket_choose_play_user_num { return @"dt_ticket_choose_play_user_num".localized; }
+ (NSString *)dt_ticket_choose_level_item_title_one { return @"dt_ticket_choose_level_item_title_one".localized; }
+ (NSString *)dt_ticket_choose_level_item_title_two { return @"dt_ticket_choose_level_item_title_two".localized; }
+ (NSString *)dt_ticket_choose_level_item_title_thr { return @"dt_ticket_choose_level_item_title_thr".localized; }
+ (NSString *)dt_ticket_choose_level_title { return @"dt_ticket_choose_level_title".localized; }
+ (NSString *)dt_ticket_choose_pop_title { return @"dt_ticket_choose_pop_title".localized; }
+ (NSString *)dt_ticket_choose_pop_des_title { return @"dt_ticket_choose_pop_des_title".localized; }
+ (NSString *)dt_ticket_choose_pop_des_detail { return @"dt_ticket_choose_pop_des_detail".localized; }
+ (NSString *)dt_ticket_choose_pop_not_alert { return @"dt_ticket_choose_pop_not_alert".localized; }
+ (NSString *)dt_ticket_choose_pop_sure_enter { return @"dt_ticket_choose_pop_sure_enter".localized; }
+ (NSString *)dt_ticket_reward_str { return @"dt_ticket_reward_str".localized; }
+ (NSString *)dt_room_input_text { return @"dt_room_input_text".localized; }
+ (NSString *)dt_room_up_mic { return @"dt_room_up_mic".localized; }
+ (NSString *)dt_room_choose_game { return @"dt_room_choose_game".localized; }
+ (NSString *)dt_room_send { return @"dt_room_send".localized; }
+ (NSString *)dt_room_please_input { return @"dt_room_please_input".localized; }
+ (NSString *)dt_room_input_not_null { return @"dt_room_input_not_null".localized; }
+ (NSString *)dt_room_end_game { return @"dt_room_end_game".localized; }
+ (NSString *)dt_room_num_id { return @"dt_room_num_id".localized; }
+ (NSString *)dt_room_not_ready { return @"dt_room_not_ready".localized; }
+ (NSString *)dt_room_is_ready { return @"dt_room_is_ready".localized; }
+ (NSString *)dt_room_click_mic { return @"dt_room_click_mic".localized; }
+ (NSString *)dt_room_close_game { return @"dt_room_close_game".localized; }
+ (NSString *)dt_room_there_no_mic { return @"dt_room_there_no_mic".localized; }
+ (NSString *)dt_room_back_game { return @"dt_room_back_game".localized; }
+ (NSString *)dt_room_confirm_flight { return @"dt_room_confirm_flight".localized; }
+ (NSString *)dt_room_flight_tile { return @"dt_room_flight_tile".localized; }
+ (NSString *)dt_room_sure_end_game { return @"dt_room_sure_end_game".localized; }
+ (NSString *)dt_room_unable_switch_game { return @"dt_room_unable_switch_game".localized; }
+ (NSString *)dt_room_sure_leave_cur_room { return @"dt_room_sure_leave_cur_room".localized; }
+ (NSString *)dt_room_unable_speak_present { return @"dt_room_unable_speak_present".localized; }

+ (NSString *)dt_login_has_expired { return @"dt_login_has_expired".localized; }
+ (NSString *)dt_next_time_again_say { return @"dt_next_time_again_say".localized; }
+ (NSString *)dt_update_now { return @"dt_update_now".localized; }
+ (NSString *)dt_update_app_ver_low { return @"dt_update_app_ver_low".localized; }
+ (NSString *)dt_update_app_ver_new { return @"dt_update_app_ver_new".localized; }
+ (NSString *)dt_unable_microphone_open { return @"dt_unable_microphone_open".localized; }
+ (NSString *)dt_unable_microphone_not_have { return @"dt_unable_microphone_not_have".localized; }
+ (NSString *)dt_unable_microphone_tip { return @"dt_unable_microphone_tip".localized; }
+ (NSString *)dt_settings_more_set { return @"dt_settings_more_set".localized; }
+ (NSString *)dt_follow_system { return @"dt_follow_system".localized; }

+ (NSString *)MJRefreshHeaderIdleText { return @"MJRefreshHeaderIdleText".localized; }
+ (NSString *)MJRefreshHeaderPullingText { return @"MJRefreshHeaderPullingText".localized; }
+ (NSString *)MJRefreshHeaderRefreshingText { return @"MJRefreshHeaderRefreshingText".localized; }

+ (NSString *)MJRefreshAutoFooterIdleText { return @"MJRefreshAutoFooterIdleText".localized; }
+ (NSString *)MJRefreshAutoFooterRefreshingText { return @"MJRefreshAutoFooterRefreshingText".localized; }
+ (NSString *)MJRefreshAutoFooterNoMoreDataText { return @"MJRefreshAutoFooterNoMoreDataText".localized; }

+ (NSString *)MJRefreshBackFooterIdleText { return @"MJRefreshBackFooterIdleText".localized; }
+ (NSString *)MJRefreshBackFooterPullingText { return @"MJRefreshBackFooterPullingText".localized; }
+ (NSString *)MJRefreshBackFooterRefreshingText { return @"MJRefreshBackFooterRefreshingText".localized; }
+ (NSString *)MJRefreshBackFooterNoMoreDataText { return @"MJRefreshBackFooterNoMoreDataText".localized; }

+ (NSString *)MJRefreshHeaderLastTimeText { return @"MJRefreshHeaderLastTimeText".localized; }
+ (NSString *)MJRefreshHeaderDateTodayText { return @"MJRefreshHeaderDateTodayText".localized; }
+ (NSString *)MJRefreshHeaderNoneLastDateText { return @"MJRefreshHeaderNoneLastDateText".localized; }

+ (NSString *)dt_asr_tip { return @"dt_asr_tip".localized; }
+ (NSString *)dt_asr_open_mic_tip { return @"dt_asr_open_mic_tip".localized; }
+ (NSString *)dt_asr_open_mic_num_tip { return @"dt_asr_open_mic_num_tip".localized; }
+ (NSString *)dt_enter_room_tip { return @"dt_enter_room_tip".localized; }
+ (NSString *)dt_game_person_count { return @"dt_game_person_count".localized; }

+ (NSString *)dt_network_error_p_check { return @"dt_network_error_p_check".localized; }


@end
