/// @description Create Event obj_controller_menu

// Fade in effect for menu
fade_alpha = 1.0;
fade_duration = game_get_speed(gamespeed_fps);
fade_timer = 0;
fade_complete = false;
transitioning = false;
fade_out_timer = 0;
fade_out_duration = game_get_speed(gamespeed_fps); 

// Menu buttons setup
button_spacing = 20;

// Calculate button dimensions
button_width = sprite_get_width(spr_menu_button);
button_height = sprite_get_height(spr_menu_button);

// Button X position: width da sprite + 20px
button_x = button_width - 30;

// First button at middle of room height
first_button_y = room_height / 2;

// Button positions
start_y = first_button_y;
score_y = first_button_y + button_height + button_spacing;
volume_y = first_button_y + (button_height + button_spacing) * 2;
quit_y = first_button_y + (button_height + button_spacing) * 3;

// Hover states
hover_start = false;
hover_score = false;
hover_volume = false;
hover_quit = false;

// Load game statistics
if (!variable_global_exists("best_time")) {
    global.best_time = 0;
    global.best_wave = 0;
    global.total_games = 0;
}

// NOVO: Sistema de high scores
if (!variable_global_exists("game_scores")) {
    global.game_scores = []; 
}

// Volume system
if (!variable_global_exists("game_volume")) {
    global.game_volume = 1.0; // 100%
}