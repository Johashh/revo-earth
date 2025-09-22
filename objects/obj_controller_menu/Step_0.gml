/// @description Step Event obj_controller_menu

// Handle fade in
if (!fade_complete && !transitioning) {
    fade_timer++;
    fade_alpha = max(0, 1.0 - (fade_timer / fade_duration));
    
    if (fade_timer >= fade_duration) {
        fade_complete = true;
    }
    return; 
}

// Handle fade out transition
if (transitioning) {
    fade_out_timer++;
    fade_alpha = min(1.0, fade_out_timer / fade_out_duration);
    
    if (fade_out_timer >= fade_out_duration) {
        if (instance_exists(obj_controller_general)) {
            obj_controller_general.should_restart_game = true;
        }
        room_goto(rm_game); 
    }
    return; 
}

var mouse_x_pos = mouse_x;
var mouse_y_pos = mouse_y;

// Reset hover states
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
    hover_start = true;
    if (mouse_check_button_released(mb_left)) {
        transitioning = true; 
        fade_out_timer = 0;		
    }
}

// Check SCORE button
var score_left = button_x - half_width;
var score_top = score_y - half_height;
var score_right = button_x + half_width;
var score_bottom = score_y + half_height;

if (point_in_rectangle(mouse_x_pos, mouse_y_pos, score_left, score_top, score_right, score_bottom)) {
    hover_score = true;
    if (mouse_check_button_released(mb_left)) {
        // Show Score
    }
}

// Check VOLUME button
var volume_left = button_x - half_width;
var volume_top = volume_y - half_height;
var volume_right = button_x + half_width;
var volume_bottom = volume_y + half_height;

if (point_in_rectangle(mouse_x_pos, mouse_y_pos, volume_left, volume_top, volume_right, volume_bottom)) {
    hover_volume = true;
    
    // Left click 
    if (mouse_check_button_released(mb_left)) {        
        if (global.game_volume == 0.0) {
            global.game_volume = 0.25;      // 0% -> 25%
        } else if (global.game_volume == 0.25) {
            global.game_volume = 0.5;       // 25% -> 50%
        } else if (global.game_volume == 0.5) {
            global.game_volume = 0.75;      // 50% -> 75%
        } else if (global.game_volume == 0.75) {
            global.game_volume = 1.0;       // 75% -> 100%
        } else {
            global.game_volume = 1.0;       
        }
        audio_master_gain(global.game_volume);
    }
    
    // Right click 
    if (mouse_check_button_released(mb_right)) {        
        if (global.game_volume == 1.0) {
            global.game_volume = 0.75;      // 100% -> 75%
        } else if (global.game_volume == 0.75) {
            global.game_volume = 0.5;       // 75% -> 50%
        } else if (global.game_volume == 0.5) {
            global.game_volume = 0.25;      // 50% -> 25%
        } else if (global.game_volume == 0.25) {
            global.game_volume = 0.0;       // 25% -> 0%
        } else {
            global.game_volume = 0.0;       
        }
        audio_master_gain(global.game_volume);
    }
}

// Check QUIT button
var quit_left = button_x - half_width;
var quit_top = quit_y - half_height;
var quit_right = button_x + half_width;
var quit_bottom = quit_y + half_height;

if (point_in_rectangle(mouse_x_pos, mouse_y_pos, quit_left, quit_top, quit_right, quit_bottom)) {
    hover_quit = true;
    if (mouse_check_button_released(mb_left)) {
        game_end();
    }
}