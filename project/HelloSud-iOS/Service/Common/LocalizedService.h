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

/// Login
+ (NSString *)dt_login_welcome;
+ (NSString *)dt_login_welcome_helloSud;
+ (NSString *)dt_login_we_take_information;
+ (NSString *)dt_login_user_agreement;
+ (NSString *)dt_login_and;
+ (NSString *)dt_login_privacy_policy;
+ (NSString *)dt_login_click_agree_agreement;
+ (NSString *)dt_login_welcome_to_the;
+ (NSString *)dt_login_your_nickname;
+ (NSString *)dt_login_experience_immediately;
+ (NSString *)dt_login_warm_prompt;
+ (NSString *)dt_login_warm_prompt_des;
+ (NSString *)dt_login_agree_continue;
+ (NSString *)dt_login_quit_application;

/// Settings
+ (NSString *)dt_settings_total;
+ (NSString *)dt_settings_size_occupied;
+ (NSString *)dt_settings_version_info;
+ (NSString *)dt_settings_switch_rtc;
+ (NSString *)dt_settings_zego;
+ (NSString *)dt_settings_agora;
+ (NSString *)dt_settings_rong_cloud;
+ (NSString *)dt_settings_net_ease;
+ (NSString *)dt_settings_volcano;
+ (NSString *)dt_settings_alicloud;
+ (NSString *)dt_settings_tencent;
+ (NSString *)dt_settings_switch_language;
+ (NSString *)dt_settings_open_source;
+ (NSString *)dt_settings_user_agreement;
+ (NSString *)dt_settings_privacy_policy;
+ (NSString *)dt_settings_contact_us;
+ (NSString *)dt_settings_work_in_progress;
+ (NSString *)dt_settings_confirm_switch_rtc;

/// RoomList
+ (NSString *)dt_room_list_room_number;
+ (NSString *)dt_room_list_users;
+ (NSString *)dt_room_list_no_room_available;

/// Home
+ (NSString *)dt_home_user_id;
+ (NSString *)dt_home_enter_room_num;
+ (NSString *)dt_home_enter;
+ (NSString *)dt_home_join;
+ (NSString *)dt_home_coming_soon;
+ (NSString *)dt_home_create_room;
+ (NSString *)dt_home_in_game;

/// common
+ (NSString *)dt_common_select_all;
+ (NSString *)dt_common_agree;
+ (NSString *)dt_common_not_agree;
+ (NSString *)dt_common_sure;
+ (NSString *)dt_common_cancel;
+ (NSString *)dt_common_forward;
+ (NSString *)dt_common_close;
+ (NSString *)dt_common_back;

/// Main
+ (NSString *)dt_tab_home;
+ (NSString *)dt_tab_room;
+ (NSString *)dt_tab_setting;

/// Scenes
+ (NSString *)dt_send;
+ (NSString *)dt_down_mic;
+ (NSString *)dt_select_person;
+ (NSString *)dt_select_gift;
+ (NSString *)dt_send_gift;
+ (NSString *)dt_room_owner;
+ (NSString *)dt_mic_index;
+ (NSString *)dt_mic_name;
+ (NSString *)dt_ticket_choose_item_reward;
+ (NSString *)dt_ticket_choose_item_join;
+ (NSString *)dt_ticket_choose_play_user_num;
+ (NSString *)dt_ticket_choose_level_item_title_one;
+ (NSString *)dt_ticket_choose_level_item_title_two;
+ (NSString *)dt_ticket_choose_level_item_title_thr;
+ (NSString *)dt_ticket_choose_pop_des_detail;
+ (NSString *)dt_ticket_choose_pop_not_alert;
+ (NSString *)dt_ticket_choose_pop_sure_enter;
+ (NSString *)dt_ticket_reward_str;
+ (NSString *)dt_room_input_text;
+ (NSString *)dt_room_up_mic;
+ (NSString *)dt_room_choose_game;
+ (NSString *)dt_room_send;
+ (NSString *)dt_room_please_input;
+ (NSString *)dt_room_end_game;
+ (NSString *)dt_room_num_id;
+ (NSString *)dt_room_not_ready;
+ (NSString *)dt_room_is_ready;
+ (NSString *)dt_room_click_mic;
+ (NSString *)dt_room_close_game;
+ (NSString *)dt_room_confirm_flight;
+ (NSString *)dt_room_flight_tile;
+ (NSString *)dt_room_sure_end_game;
+ (NSString *)dt_room_unable_switch_game;
+ (NSString *)dt_room_sure_leave_cur_room;

+ (NSString *)dt_next_time_again_say;
+ (NSString *)dt_update_now;
+ (NSString *)dt_update_app_ver_low;
+ (NSString *)dt_update_app_ver_new;

+ (NSString *)MJRefreshHeaderIdleText;
+ (NSString *)MJRefreshHeaderPullingText;
+ (NSString *)MJRefreshHeaderRefreshingText;

+ (NSString *)MJRefreshAutoFooterIdleText;
+ (NSString *)MJRefreshAutoFooterRefreshingText;
+ (NSString *)MJRefreshAutoFooterNoMoreDataText;

+ (NSString *)MJRefreshBackFooterIdleText;
+ (NSString *)MJRefreshBackFooterPullingText;
+ (NSString *)MJRefreshBackFooterRefreshingText;
+ (NSString *)MJRefreshBackFooterNoMoreDataText;

+ (NSString *)MJRefreshHeaderLastTimeText;
+ (NSString *)MJRefreshHeaderDateTodayText;
+ (NSString *)MJRefreshHeaderNoneLastDateText;

+ (NSString *)dt_asr_tip;
+ (NSString *)dt_asr_open_mic_tip;
+ (NSString *)dt_asr_open_mic_num_tip;
+ (NSString *)dt_enter_room_tip;
+ (NSString *)dt_game_person_count;


+ (NSString *)dt_custom_game_system;
+ (NSString *)dt_custom_game_cpu;
+ (NSString *)dt_custom_game_cpu_normal;
+ (NSString *)dt_custom_game_cpu_low;
+ (NSString *)dt_custom_in_game_sound;
+ (NSString *)dt_custom_game_play_sound;
+ (NSString *)dt_custom_app_play_sound;
+ (NSString *)dt_custom_in_game_volume;
+ (NSString *)dt_custom_hide_settlement;
+ (NSString *)dt_custom_hide_ping;
+ (NSString *)dt_custom_hide_version;
+ (NSString *)dt_custom_hide_rank;
+ (NSString *)dt_custom_hide_lobby_sound;
+ (NSString *)dt_custom_hide_lobby_help;
+ (NSString *)dt_custom_hide_lobby_slot;
+ (NSString *)dt_custom_hide_lobby_captain;
+ (NSString *)dt_custom_hide_lobby_kick;
+ (NSString *)dt_custom_hide_lobby_des;
+ (NSString *)dt_custom_hide_lobby_settings;
+ (NSString *)dt_custom_hide_btn_join_game;
+ (NSString *)dt_custom_hide_btn_exit_game;
+ (NSString *)dt_custom_hide_btn_prepare;
+ (NSString *)dt_custom_hide_btn_cancel_prepare;
+ (NSString *)dt_custom_hide_btn_start_game;
+ (NSString *)dt_custom_hide_btn_share;
+ (NSString *)dt_custom_hide_btn_sound;
+ (NSString *)dt_custom_hide_btn_help_scene;
+ (NSString *)dt_custom_hide_game_bg;
+ (NSString *)dt_custom_click_join_game;
+ (NSString *)dt_custom_handle_join_game;
+ (NSString *)dt_custom_handle_exit_game;
+ (NSString *)dt_custom_handle_prepare;
+ (NSString *)dt_custom_handle_cancel_prepare;
+ (NSString *)dt_custom_handle_start_game;
+ (NSString *)dt_custom_handle_share;
+ (NSString *)dt_custom_btn_close;
+ (NSString *)dt_custom_btn_one_more_round;
+ (NSString *)dt_custom_prevent_change_seat;
+ (NSString *)dt_custom_false_change_seat;
+ (NSString *)dt_custom_true_not_change_seat;
+ (NSString *)dt_custom_false_ready_state;
+ (NSString *)dt_custom_false_close_settlement;
+ (NSString *)dt_custom_true_game_notifies;
+ (NSString *)dt_custom_false_game_processing;
+ (NSString *)dt_custom_true_only_notifies;
+ (NSString *)dt_custom_false_show;
+ (NSString *)dt_custom_true_hide;

/// 1.3.0
+ (NSString *)dt_settings_more_set;
+ (NSString *)dt_room_transfer_leader;
+ (NSString *)dt_room_kick_game;
+ (NSString *)dt_network_error_p_check;
+ (NSString *)dt_room_switched_language;
+ (NSString *)dt_room_my_order_list;
+ (NSString *)dt_room_select_mic_users;
+ (NSString *)dt_room_designate_mc_anchor;
+ (NSString *)dt_room_place_order_play;
+ (NSString *)dt_room_seleted_people;
+ (NSString *)dt_home_all_scenes;
+ (NSString *)dt_room_hang_room;
+ (NSString *)dt_room_exit_room;
+ (NSString *)dt_room_bureau_person;
+ (NSString *)dt_room_need_end_game_can_switch;
+ (NSString *)dt_room_hope_play_is_join;
+ (NSString *)dt_room_reject;
+ (NSString *)dt_room_place_order;
+ (NSString *)dt_room_custom_ready;
+ (NSString *)dt_room_custom_cancel_ready;
+ (NSString *)dt_room_custom_quit_game;
+ (NSString *)dt_room_custom_start_game;
+ (NSString *)dt_room_custom_escape;
+ (NSString *)dt_room_custom_dissolve_game;
+ (NSString *)dt_room_game_config;
+ (NSString *)dt_room_exit_room_reload;
+ (NSString *)dt_room_game_stage;
+ (NSString *)dt_room_api_interface;
+ (NSString *)dt_room_before_join_game;
+ (NSString *)dt_room_c_join_game;
+ (NSString *)dt_room_c_preparation_stage;
+ (NSString *)dt_room_c_preparation;
+ (NSString *)dt_room_cancel_preparation;
+ (NSString *)dt_room_c_start_game;
+ (NSString *)dt_room_quit_game;
+ (NSString *)dt_room_custom_in_game;
+ (NSString *)dt_room_base_escape;
+ (NSString *)dt_room_dissolve_game;
+ (NSString *)dt_room_suspend_game;
+ (NSString *)dt_room_enter_game;
+ (NSString *)dt_room_select_anchor;
+ (NSString *)dt_room_select_game;
+ (NSString *)dt_room_to_be_started;
+ (NSString *)dt_room_closed;
+ (NSString *)dt_room_empty_seat;
+ (NSString *)dt_room_pk_cross_room;
+ (NSString *)dt_room_start_pk;
+ (NSString *)dt_room_pk_settings;
+ (NSString *)dt_room_pk_select_one_game;
+ (NSString *)dt_room_air_room_list;
+ (NSString *)dt_room_pk_rules;
+ (NSString *)dt_room_order_placed;
+ (NSString *)dt_room_pk_duration_set;
+ (NSString *)dt_room_close_cross_room;
+ (NSString *)dt_room_minutes;
+ (NSString *)dt_room_confirm_modification;
+ (NSString *)dt_room_pk_no_room_available;
+ (NSString *)dt_room_pk_invitation_accept;
+ (NSString *)dt_room_acceptance;
+ (NSString *)dt_room_pk_red_team;
+ (NSString *)dt_room_pk_blue_team;
+ (NSString *)dt_room_pk_enter_other_room_tip;
+ (NSString *)dt_room_pk_remove_toast_tip;
+ (NSString *)dt_room_pk_remove_gaming_toast_tip;
+ (NSString *)dt_room_pk_remove_other_tip;
+ (NSString *)dt_room_game_system;
+ (NSString *)dt_room_pk_rules_content;
+ (NSString *)dt_room_pk_select_game;
+ (NSString *)dt_room_pk_wait_onwer_select;
+ (NSString *)dt_room_invitation_failed;
+ (NSString *)dt_room_invitation_send;
+ (NSString *)dt_room_opposite_room_id_empty;
+ (NSString *)dt_room_another_pk;
+ (NSString *)dt_room_close_pk;
+ (NSString *)dt_room_close_pk_advance_tip;
+ (NSString *)dt_room_refuse_invitation_find;
+ (NSString *)dt_room_round_game_over;
+ (NSString *)dt_room_unable_display_msg;
+ (NSString *)dt_room_cross_id_not_empty;
+ (NSString *)dt_room_load_failed;
+ (NSString *)dt_follow_system;
+ (NSString *)dt_unable_microphone_tip;
+ (NSString *)dt_unable_microphone_not_have;
+ (NSString *)dt_unable_microphone_open;
+ (NSString *)dt_login_has_expired;
+ (NSString *)dt_room_unable_speak_present;
+ (NSString *)dt_room_back_game;
+ (NSString *)dt_room_there_no_mic;
+ (NSString *)dt_room_input_not_null;
+ (NSString *)dt_ticket_choose_pop_des_title;
+ (NSString *)dt_ticket_choose_pop_title;
+ (NSString *)dt_ticket_choose_level_title;
+ (NSString *)dt_up_mic;

+ (NSString *)dt_win_first_tip;
+ (NSString *)dt_win_second_tip;
+ (NSString *)dt_win_third_tip;
+ (NSString *)dt_room_pk_score_fmt;
+ (NSString *)dt_user_receive_invite_msg;
+ (NSString *)dt_room_pk_show_invite_tip;
+ (NSString *)dt_room_join_status;
+ (NSString *)dt_room_pk_closed_msg;
+ (NSString *)dt_room_pk_status_ing;
+ (NSString *)dt_room_pk_waitting;
+ (NSString *)dt_room_pk_remove_sure;
+ (NSString *)dt_room_pk_invite;
+ (NSString *)dt_ticket_order_msg_fmt;
+ (NSString *)dt_room_mic_game_ing;


@end
NS_ASSUME_NONNULL_END
