/// @description Create Event obj_main_menu

// Menu buttons setup
button_width = 200;
button_height = 60;
button_spacing = 20;

// Calculate positions (40px from left, centered vertically)
button_x = 40;
center_y = room_height / 2;

// Button positions
start_y = center_y - button_height - button_spacing;
score_y = center_y;
quit_y = center_y + button_height + button_spacing;

// Hover states
hover_start = false;
hover_score = false;
hover_quit = false;

// Colors
normal_color = c_gray;
hover_color = c_blue;

// Game statistics (load from global or file later)
best_time = 0;
best_wave = 0;
total_games = 0;