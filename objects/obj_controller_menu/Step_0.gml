/// @description Step Event obj_controller_menu

if (!fade_complete && !transitioning) {
    fade_timer++;
    fade_alpha = max(0, 1.0 - (fade_timer / fade_duration));
    
    if (fade_timer >= fade_duration) {
        fade_complete = true;
        audio_play_sound(snd_game_music, 1, true);
        audio_sound_gain(snd_game_music, global.game_volume * 0.7, 0);
    }
    return; 
}

if (transitioning) {
    fade_out_timer++;
    fade_alpha = min(1.0, fade_out_timer / fade_out_duration);
    
    if (fade_out_timer >= fade_out_duration) {
        audio_stop_sound(snd_game_music);
        if (instance_exists(obj_controller_general)) {
            obj_controller_general.should_restart_game = true;
        }
        room_goto(rm_game); 
    }
    return; 
}

var mouse_x_pos = mouse_x;
var mouse_y_pos = mouse_y;

var prev_hover_start = hover_start;
var prev_hover_score = hover_score;
var prev_hover_volume = hover_volume;
var prev_hover_quit = hover_quit;

hover_start = false;
hover_score = false;
hover_volume = false;
hover_quit = false;

var half_width = button_width / 2;
var half_height = button_height / 2;

// Check START button
var start_left = button_x - half_width;
var start_top = start_y - half_height;
var start_right = button_x + half_width;
var start_bottom = start_y + half_height;

if (point_in_rectangle(mouse_x_pos, mouse_y_pos, start_left, start_top, start_right, start_bottom)) {
    if (!prev_hover_start) {
        audio_play_sound(snd_navigation, 1, false);
    }
    hover_start = true;
    if (mouse_check_button_released(mb_left)) {
        transitioning = true; 
        fade_out_timer = 0;
        audio_sound_gain(snd_game_music, 0, 1000);
    }
}

// Check SCORE button
var score_left = button_x - half_width;
var score_top = score_y - half_height;
var score_right = button_x + half_width;
var score_bottom = score_y + half_height;

if (point_in_rectangle(mouse_x_pos, mouse_y_pos, score_left, score_top, score_right, score_bottom)) {
    if (!prev_hover_score) {
        audio_play_sound(snd_navigation, 1, false);
    }
    hover_score = true;
}

// Check VOLUME button
var volume_left = button_x - half_width;
var volume_top = volume_y - half_height;
var volume_right = button_x + half_width;
var volume_bottom = volume_y + half_height;

if (point_in_rectangle(mouse_x_pos, mouse_y_pos, volume_left, volume_top, volume_right, volume_bottom)) {
    if (!prev_hover_volume) {
        audio_play_sound(snd_navigation, 1, false);
    }
    hover_volume = true;
    
    if (mouse_check_button_released(mb_left)) {        
        if (global.game_volume == 0.0) {
            global.game_volume = 0.25;
        } else if (global.game_volume == 0.25) {
            global.game_volume = 0.5;
        } else if (global.game_volume == 0.5) {
            global.game_volume = 0.75;
        } else if (global.game_volume == 0.75) {
            global.game_volume = 1.0;
        } else {
            global.game_volume = 1.0;
        }
        audio_master_gain(global.game_volume);
        audio_sound_gain(snd_game_music, global.game_volume * 0.7, 0);
    }
    
    if (mouse_check_button_released(mb_right)) {        
        if (global.game_volume == 1.0) {
            global.game_volume = 0.75;
        } else if (global.game_volume == 0.75) {
            global.game_volume = 0.5;
        } else if (global.game_volume == 0.5) {
            global.game_volume = 0.25;
        } else if (global.game_volume == 0.25) {
            global.game_volume = 0.0;
        } else {
            global.game_volume = 0.0;
        }
        audio_master_gain(global.game_volume);
        audio_sound_gain(snd_game_music, global.game_volume * 0.7, 0);
    }
}

// Check QUIT button
var quit_left = button_x - half_width;
var quit_top = quit_y - half_height;
var quit_right = button_x + half_width;
var quit_bottom = quit_y + half_height;

if (point_in_rectangle(mouse_x_pos, mouse_y_pos, quit_left, quit_top, quit_right, quit_bottom)) {
    if (!prev_hover_quit) {
        audio_play_sound(snd_navigation, 1, false);
    }
    hover_quit = true;
    if (mouse_check_button_released(mb_left)) {
        game_end();
    }
}