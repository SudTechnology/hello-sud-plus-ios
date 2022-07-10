#import "LocalizedService.h"

 @implementation NSString(Localized)
- (NSString *)localized {
    NSBundle *bundle = NSBundle.currentLanguageBundle;
    if (bundle) {
        return [bundle localizedStringForKey:self value:self table:nil];
    }
    return NSLocalizedString(self, comment: self); 
}
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
+ (NSString *)dt_common_forward { return @"dt_common_forward".localized; }
+ (NSString *)dt_common_close { return @"dt_common_close".localized; }
+ (NSString *)dt_common_back { return @"dt_common_back".localized; }

/// Main
+ (NSString *)dt_tab_home { return @"dt_tab_home".localized; }
+ (NSString *)dt_tab_room { return @"dt_tab_room".localized; }
+ (NSString *)dt_tab_setting { return @"dt_tab_setting".localized; }

/// Scenes
+ (NSString *)dt_send { return @"dt_send".localized; }
+ (NSString *)dt_down_mic { return @"dt_down_mic".localized; }
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
+ (NSString *)dt_ticket_choose_pop_des_detail { return @"dt_ticket_choose_pop_des_detail".localized; }
+ (NSString *)dt_ticket_choose_pop_not_alert { return @"dt_ticket_choose_pop_not_alert".localized; }
+ (NSString *)dt_ticket_choose_pop_sure_enter { return @"dt_ticket_choose_pop_sure_enter".localized; }
+ (NSString *)dt_ticket_reward_str { return @"dt_ticket_reward_str".localized; }
+ (NSString *)dt_room_input_text { return @"dt_room_input_text".localized; }
+ (NSString *)dt_room_up_mic { return @"dt_room_up_mic".localized; }
+ (NSString *)dt_room_choose_game { return @"dt_room_choose_game".localized; }
+ (NSString *)dt_room_send { return @"dt_room_send".localized; }
+ (NSString *)dt_room_please_input { return @"dt_room_please_input".localized; }
+ (NSString *)dt_room_end_game { return @"dt_room_end_game".localized; }
+ (NSString *)dt_room_num_id { return @"dt_room_num_id".localized; }
+ (NSString *)dt_room_not_ready { return @"dt_room_not_ready".localized; }
+ (NSString *)dt_room_is_ready { return @"dt_room_is_ready".localized; }
+ (NSString *)dt_room_click_mic { return @"dt_room_click_mic".localized; }
+ (NSString *)dt_room_close_game { return @"dt_room_close_game".localized; }
+ (NSString *)dt_room_confirm_flight { return @"dt_room_confirm_flight".localized; }
+ (NSString *)dt_room_flight_tile { return @"dt_room_flight_tile".localized; }
+ (NSString *)dt_room_sure_end_game { return @"dt_room_sure_end_game".localized; }
+ (NSString *)dt_room_unable_switch_game { return @"dt_room_unable_switch_game".localized; }
+ (NSString *)dt_room_sure_leave_cur_room { return @"dt_room_sure_leave_cur_room".localized; }

+ (NSString *)dt_next_time_again_say { return @"dt_next_time_again_say".localized; }
+ (NSString *)dt_update_now { return @"dt_update_now".localized; }
+ (NSString *)dt_update_app_ver_low { return @"dt_update_app_ver_low".localized; }
+ (NSString *)dt_update_app_ver_new { return @"dt_update_app_ver_new".localized; }

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


+ (NSString *)dt_custom_game_system { return @"dt_custom_game_system".localized; }
+ (NSString *)dt_custom_game_cpu { return @"dt_custom_game_cpu".localized; }
+ (NSString *)dt_custom_game_cpu_normal { return @"dt_custom_game_cpu_normal".localized; }
+ (NSString *)dt_custom_game_cpu_low { return @"dt_custom_game_cpu_low".localized; }
+ (NSString *)dt_custom_in_game_sound { return @"dt_custom_in_game_sound".localized; }
+ (NSString *)dt_custom_game_play_sound { return @"dt_custom_game_play_sound".localized; }
+ (NSString *)dt_custom_app_play_sound { return @"dt_custom_app_play_sound".localized; }
+ (NSString *)dt_custom_in_game_volume { return @"dt_custom_in_game_volume".localized; }
+ (NSString *)dt_custom_hide_settlement { return @"dt_custom_hide_settlement".localized; }
+ (NSString *)dt_custom_hide_ping { return @"dt_custom_hide_ping".localized; }
+ (NSString *)dt_custom_hide_version { return @"dt_custom_hide_version".localized; }
+ (NSString *)dt_custom_hide_rank { return @"dt_custom_hide_rank".localized; }
+ (NSString *)dt_custom_hide_lobby_sound { return @"dt_custom_hide_lobby_sound".localized; }
+ (NSString *)dt_custom_hide_lobby_help { return @"dt_custom_hide_lobby_help".localized; }
+ (NSString *)dt_custom_hide_lobby_slot { return @"dt_custom_hide_lobby_slot".localized; }
+ (NSString *)dt_custom_hide_lobby_captain { return @"dt_custom_hide_lobby_captain".localized; }
+ (NSString *)dt_custom_hide_lobby_kick { return @"dt_custom_hide_lobby_kick".localized; }
+ (NSString *)dt_custom_hide_lobby_des { return @"dt_custom_hide_lobby_des".localized; }
+ (NSString *)dt_custom_hide_lobby_settings { return @"dt_custom_hide_lobby_settings".localized; }
+ (NSString *)dt_custom_hide_btn_join_game { return @"dt_custom_hide_btn_join_game".localized; }
+ (NSString *)dt_custom_hide_btn_exit_game { return @"dt_custom_hide_btn_exit_game".localized; }
+ (NSString *)dt_custom_hide_btn_prepare { return @"dt_custom_hide_btn_prepare".localized; }
+ (NSString *)dt_custom_hide_btn_cancel_prepare { return @"dt_custom_hide_btn_cancel_prepare".localized; }
+ (NSString *)dt_custom_hide_btn_start_game { return @"dt_custom_hide_btn_start_game".localized; }
+ (NSString *)dt_custom_hide_btn_share { return @"dt_custom_hide_btn_share".localized; }
+ (NSString *)dt_custom_hide_btn_sound { return @"dt_custom_hide_btn_sound".localized; }
+ (NSString *)dt_custom_hide_btn_help_scene { return @"dt_custom_hide_btn_help_scene".localized; }
+ (NSString *)dt_custom_hide_game_bg { return @"dt_custom_hide_game_bg".localized; }
+ (NSString *)dt_custom_click_join_game { return @"dt_custom_click_join_game".localized; }
+ (NSString *)dt_custom_handle_join_game { return @"dt_custom_handle_join_game".localized; }
+ (NSString *)dt_custom_handle_exit_game { return @"dt_custom_handle_exit_game".localized; }
+ (NSString *)dt_custom_handle_prepare { return @"dt_custom_handle_prepare".localized; }
+ (NSString *)dt_custom_handle_cancel_prepare { return @"dt_custom_handle_cancel_prepare".localized; }
+ (NSString *)dt_custom_handle_start_game { return @"dt_custom_handle_start_game".localized; }
+ (NSString *)dt_custom_handle_share { return @"dt_custom_handle_share".localized; }
+ (NSString *)dt_custom_btn_close { return @"dt_custom_btn_close".localized; }
+ (NSString *)dt_custom_btn_one_more_round { return @"dt_custom_btn_one_more_round".localized; }
+ (NSString *)dt_custom_prevent_change_seat { return @"dt_custom_prevent_change_seat".localized; }
+ (NSString *)dt_custom_false_change_seat { return @"dt_custom_false_change_seat".localized; }
+ (NSString *)dt_custom_true_not_change_seat { return @"dt_custom_true_not_change_seat".localized; }
+ (NSString *)dt_custom_false_ready_state { return @"dt_custom_false_ready_state".localized; }
+ (NSString *)dt_custom_false_close_settlement { return @"dt_custom_false_close_settlement".localized; }
+ (NSString *)dt_custom_true_game_notifies { return @"dt_custom_true_game_notifies".localized; }
+ (NSString *)dt_custom_false_game_processing { return @"dt_custom_false_game_processing".localized; }
+ (NSString *)dt_custom_true_only_notifies { return @"dt_custom_true_only_notifies".localized; }
+ (NSString *)dt_custom_false_show { return @"dt_custom_false_show".localized; }
+ (NSString *)dt_custom_true_hide { return @"dt_custom_true_hide".localized; }

/// 1.3.0
+ (NSString *)dt_settings_more_set { return @"dt_settings_more_set".localized; }
+ (NSString *)dt_room_transfer_leader { return @"dt_room_transfer_leader".localized; }
+ (NSString *)dt_room_kick_game { return @"dt_room_kick_game".localized; }
+ (NSString *)dt_network_error_p_check { return @"dt_network_error_p_check".localized; }
+ (NSString *)dt_room_switched_language { return @"dt_room_switched_language".localized; }
+ (NSString *)dt_room_my_order_list { return @"dt_room_my_order_list".localized; }
+ (NSString *)dt_room_select_mic_users { return @"dt_room_select_mic_users".localized; }
+ (NSString *)dt_room_designate_mc_anchor { return @"dt_room_designate_mc_anchor".localized; }
+ (NSString *)dt_room_place_order_play { return @"dt_room_place_order_play".localized; }
+ (NSString *)dt_room_seleted_people { return @"dt_room_seleted_people".localized; }
+ (NSString *)dt_home_all_scenes { return @"dt_home_all_scenes".localized; }
+ (NSString *)dt_room_hang_room { return @"dt_room_hang_room".localized; }
+ (NSString *)dt_room_exit_room { return @"dt_room_exit_room".localized; }
+ (NSString *)dt_room_bureau_person { return @"dt_room_bureau_person".localized; }
+ (NSString *)dt_room_need_end_game_can_switch { return @"dt_room_need_end_game_can_switch".localized; }
+ (NSString *)dt_room_hope_play_is_join { return @"dt_room_hope_play_is_join".localized; }
+ (NSString *)dt_room_reject { return @"dt_room_reject".localized; }
+ (NSString *)dt_room_place_order { return @"dt_room_place_order".localized; }
+ (NSString *)dt_room_custom_ready { return @"dt_room_custom_ready".localized; }
+ (NSString *)dt_room_custom_cancel_ready { return @"dt_room_custom_cancel_ready".localized; }
+ (NSString *)dt_room_custom_quit_game { return @"dt_room_custom_quit_game".localized; }
+ (NSString *)dt_room_custom_start_game { return @"dt_room_custom_start_game".localized; }
+ (NSString *)dt_room_custom_escape { return @"dt_room_custom_escape".localized; }
+ (NSString *)dt_room_custom_dissolve_game { return @"dt_room_custom_dissolve_game".localized; }
+ (NSString *)dt_room_game_config { return @"dt_room_game_config".localized; }
+ (NSString *)dt_room_exit_room_reload { return @"dt_room_exit_room_reload".localized; }
+ (NSString *)dt_room_game_stage { return @"dt_room_game_stage".localized; }
+ (NSString *)dt_room_api_interface { return @"dt_room_api_interface".localized; }
+ (NSString *)dt_room_before_join_game { return @"dt_room_before_join_game".localized; }
+ (NSString *)dt_room_c_join_game { return @"dt_room_c_join_game".localized; }
+ (NSString *)dt_room_c_preparation_stage { return @"dt_room_c_preparation_stage".localized; }
+ (NSString *)dt_room_c_preparation { return @"dt_room_c_preparation".localized; }
+ (NSString *)dt_room_cancel_preparation { return @"dt_room_cancel_preparation".localized; }
+ (NSString *)dt_room_c_start_game { return @"dt_room_c_start_game".localized; }
+ (NSString *)dt_room_quit_game { return @"dt_room_quit_game".localized; }
+ (NSString *)dt_room_custom_in_game { return @"dt_room_custom_in_game".localized; }
+ (NSString *)dt_room_base_escape { return @"dt_room_base_escape".localized; }
+ (NSString *)dt_room_dissolve_game { return @"dt_room_dissolve_game".localized; }
+ (NSString *)dt_room_suspend_game { return @"dt_room_suspend_game".localized; }
+ (NSString *)dt_room_enter_game { return @"dt_room_enter_game".localized; }
+ (NSString *)dt_room_select_anchor { return @"dt_room_select_anchor".localized; }
+ (NSString *)dt_room_select_game { return @"dt_room_select_game".localized; }
+ (NSString *)dt_room_to_be_started { return @"dt_room_to_be_started".localized; }
+ (NSString *)dt_room_closed { return @"dt_room_closed".localized; }
+ (NSString *)dt_room_empty_seat { return @"dt_room_empty_seat".localized; }
+ (NSString *)dt_room_pk_cross_room { return @"dt_room_pk_cross_room".localized; }
+ (NSString *)dt_room_start_pk { return @"dt_room_start_pk".localized; }
+ (NSString *)dt_room_pk_settings { return @"dt_room_pk_settings".localized; }
+ (NSString *)dt_room_pk_select_one_game { return @"dt_room_pk_select_one_game".localized; }
+ (NSString *)dt_room_air_room_list { return @"dt_room_air_room_list".localized; }
+ (NSString *)dt_room_pk_rules { return @"dt_room_pk_rules".localized; }
+ (NSString *)dt_room_order_placed { return @"dt_room_order_placed".localized; }
+ (NSString *)dt_room_pk_duration_set { return @"dt_room_pk_duration_set".localized; }
+ (NSString *)dt_room_close_cross_room { return @"dt_room_close_cross_room".localized; }
+ (NSString *)dt_room_minutes { return @"dt_room_minutes".localized; }
+ (NSString *)dt_room_confirm_modification { return @"dt_room_confirm_modification".localized; }
+ (NSString *)dt_room_pk_no_room_available { return @"dt_room_pk_no_room_available".localized; }
+ (NSString *)dt_room_pk_invitation_accept { return @"dt_room_pk_invitation_accept".localized; }
+ (NSString *)dt_room_acceptance { return @"dt_room_acceptance".localized; }
+ (NSString *)dt_room_pk_red_team { return @"dt_room_pk_red_team".localized; }
+ (NSString *)dt_room_pk_blue_team { return @"dt_room_pk_blue_team".localized; }
+ (NSString *)dt_room_pk_enter_other_room_tip { return @"dt_room_pk_enter_other_room_tip".localized; }
+ (NSString *)dt_room_pk_remove_toast_tip { return @"dt_room_pk_remove_toast_tip".localized; }
+ (NSString *)dt_room_pk_remove_gaming_toast_tip { return @"dt_room_pk_remove_gaming_toast_tip".localized; }
+ (NSString *)dt_room_pk_remove_other_tip { return @"dt_room_pk_remove_other_tip".localized; }
+ (NSString *)dt_room_game_system { return @"dt_room_game_system".localized; }
+ (NSString *)dt_room_pk_rules_content { return @"dt_room_pk_rules_content".localized; }
+ (NSString *)dt_room_pk_select_game { return @"dt_room_pk_select_game".localized; }
+ (NSString *)dt_room_pk_wait_onwer_select { return @"dt_room_pk_wait_onwer_select".localized; }
+ (NSString *)dt_room_invitation_failed { return @"dt_room_invitation_failed".localized; }
+ (NSString *)dt_room_invitation_send { return @"dt_room_invitation_send".localized; }
+ (NSString *)dt_room_opposite_room_id_empty { return @"dt_room_opposite_room_id_empty".localized; }
+ (NSString *)dt_room_another_pk { return @"dt_room_another_pk".localized; }
+ (NSString *)dt_room_close_pk { return @"dt_room_close_pk".localized; }
+ (NSString *)dt_room_close_pk_advance_tip { return @"dt_room_close_pk_advance_tip".localized; }
+ (NSString *)dt_room_refuse_invitation_find { return @"dt_room_refuse_invitation_find".localized; }
+ (NSString *)dt_room_round_game_over { return @"dt_room_round_game_over".localized; }
+ (NSString *)dt_room_unable_display_msg { return @"dt_room_unable_display_msg".localized; }
+ (NSString *)dt_room_cross_id_not_empty { return @"dt_room_cross_id_not_empty".localized; }
+ (NSString *)dt_room_load_failed { return @"dt_room_load_failed".localized; }
+ (NSString *)dt_follow_system { return @"dt_follow_system".localized; }
+ (NSString *)dt_unable_microphone_tip { return @"dt_unable_microphone_tip".localized; }
+ (NSString *)dt_unable_microphone_not_have { return @"dt_unable_microphone_not_have".localized; }
+ (NSString *)dt_unable_microphone_open { return @"dt_unable_microphone_open".localized; }
+ (NSString *)dt_login_has_expired { return @"dt_login_has_expired".localized; }
+ (NSString *)dt_room_unable_speak_present { return @"dt_room_unable_speak_present".localized; }
+ (NSString *)dt_room_back_game { return @"dt_room_back_game".localized; }
+ (NSString *)dt_room_there_no_mic { return @"dt_room_there_no_mic".localized; }
+ (NSString *)dt_room_input_not_null { return @"dt_room_input_not_null".localized; }
+ (NSString *)dt_ticket_choose_pop_des_title { return @"dt_ticket_choose_pop_des_title".localized; }
+ (NSString *)dt_ticket_choose_pop_title { return @"dt_ticket_choose_pop_title".localized; }
+ (NSString *)dt_ticket_choose_level_title { return @"dt_ticket_choose_level_title".localized; }
+ (NSString *)dt_up_mic { return @"dt_up_mic".localized; }

+ (NSString *)dt_win_first_tip { return @"dt_win_first_tip".localized; }
+ (NSString *)dt_win_second_tip { return @"dt_win_second_tip".localized; }
+ (NSString *)dt_win_third_tip { return @"dt_win_third_tip".localized; }
+ (NSString *)dt_room_pk_score_fmt { return @"dt_room_pk_score_fmt".localized; }
+ (NSString *)dt_user_receive_invite_msg { return @"dt_user_receive_invite_msg".localized; }
+ (NSString *)dt_room_pk_show_invite_tip { return @"dt_room_pk_show_invite_tip".localized; }
+ (NSString *)dt_room_join_status { return @"dt_room_join_status".localized; }
+ (NSString *)dt_room_pk_closed_msg { return @"dt_room_pk_closed_msg".localized; }
+ (NSString *)dt_room_pk_status_ing { return @"dt_room_pk_status_ing".localized; }
+ (NSString *)dt_room_pk_waitting { return @"dt_room_pk_waitting".localized; }
+ (NSString *)dt_room_pk_remove_sure { return @"dt_room_pk_remove_sure".localized; }
+ (NSString *)dt_room_pk_invite { return @"dt_room_pk_invite".localized; }
+ (NSString *)dt_ticket_order_msg_fmt { return @"dt_ticket_order_msg_fmt".localized; }
+ (NSString *)dt_room_mic_game_ing { return @"dt_room_mic_game_ing".localized; }

/// 1.4.0
+ (NSString *)dt_room_disco_dancing_fmt { return @"dt_room_disco_dancing_fmt".localized; }
+ (NSString *)dt_room_disco_tip_one_fmt { return @"dt_room_disco_tip_one_fmt".localized; }
+ (NSString *)dt_room_disco_tip_two_fmt { return @"dt_room_disco_tip_two_fmt".localized; }
+ (NSString *)dt_room_disco_tip_three_fmt { return @"dt_room_disco_tip_three_fmt".localized; }
+ (NSString *)dt_room_disco_tip_four_fmt { return @"dt_room_disco_tip_four_fmt".localized; }
+ (NSString *)dt_room_disco_tip_five_fmt { return @"dt_room_disco_tip_five_fmt".localized; }
+ (NSString *)dt_room_disco_countdown_fmt { return @"dt_room_disco_countdown_fmt".localized; }
+ (NSString *)dt_room_guess_win_msg_fmt { return @"dt_room_guess_win_msg_fmt".localized; }
+ (NSString *)dt_room_guess_diff_user_win_msg_fmt { return @"dt_room_guess_diff_user_win_msg_fmt".localized; }
+ (NSString *)dt_room_guess_enter_fmt { return @"dt_room_guess_enter_fmt".localized; }
+ (NSString *)dt_room_guess_coin_fmt { return @"dt_room_guess_coin_fmt".localized; }
+ (NSString *)dt_room_guess_support_fmt { return @"dt_room_guess_support_fmt".localized; }
+ (NSString *)dt_room_guess_distance_time_fmt { return @"dt_room_guess_distance_time_fmt".localized; }
+ (NSString *)dt_room_guess_your_support_fmt { return @"dt_room_guess_your_support_fmt".localized; }
+ (NSString *)dt_room_guess_win_me_fmt { return @"dt_room_guess_win_me_fmt".localized; }
+ (NSString *)dt_room_guess_guess_self_fmt { return @"dt_room_guess_guess_self_fmt".localized; }
+ (NSString *)dt_room_guess_confirm_coin_fmt { return @"dt_room_guess_confirm_coin_fmt".localized; }
+ (NSString *)dt_room_guess_close_fmt { return @"dt_room_guess_close_fmt".localized; }
+ (NSString *)dt_room_disco_dancing_minute_fmt { return @"dt_room_disco_dancing_minute_fmt".localized; }
+ (NSString *)dt_room_guess_had_support_fmt { return @"dt_room_guess_had_support_fmt".localized; }

+ (NSString *)dt_room_disco_waitting { return @"dt_room_disco_waitting".localized; }
+ (NSString *)dt_room_disco_keyword_top_five { return @"dt_room_disco_keyword_top_five".localized; }
+ (NSString *)dt_room_disco_keyword_move { return @"dt_room_disco_keyword_move".localized; }
+ (NSString *)dt_room_disco_keyword_up_sky { return @"dt_room_disco_keyword_up_sky".localized; }
+ (NSString *)dt_room_disco_keyword_witch_role { return @"dt_room_disco_keyword_witch_role".localized; }
+ (NSString *)dt_room_disco_keyword_work { return @"dt_room_disco_keyword_work".localized; }
+ (NSString *)dt_room_disco_keyword_unwork { return @"dt_room_disco_keyword_unwork".localized; }
+ (NSString *)dt_room_disco_keyword_focus { return @"dt_room_disco_keyword_focus".localized; }
+ (NSString *)dt_room_disco_tag_special { return @"dt_room_disco_tag_special".localized; }
+ (NSString *)dt_room_disco_tag_effect { return @"dt_room_disco_tag_effect".localized; }
+ (NSString *)dt_room_guess_more_activity { return @"dt_room_guess_more_activity".localized; }
+ (NSString *)dt_room_guess_aword { return @"dt_room_guess_aword".localized; }
+ (NSString *)dt_room_guess_join_now { return @"dt_room_guess_join_now".localized; }
+ (NSString *)dt_room_guess_remain { return @"dt_room_guess_remain".localized; }


@end
