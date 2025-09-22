/// @description Step Event obj_main_menu

var mouse_x_pos = mouse_x;
var mouse_y_pos = mouse_y;

// Reset hover states
hover_start = false;
hover_score = false;
hover_quit = false;

// Check START button
if (point_in_rectangle(mouse_x_pos, mouse_y_pos, button_x, start_y, button_x + button_width, start_y + button_height)) {
    hover_start = true;
    if (mouse_check_button_released(mb_left)) {
        room_goto(rm_game); 
    }
}

// Check SCORE button
if (point_in_rectangle(mouse_x_pos, mouse_y_pos, button_x, score_y, button_x + button_width, score_y + button_height)) {
    hover_score = true;
    if (mouse_check_button_released(mb_left)) {
        // Mostrar estatísticas (implementar depois)
    }
}

// Check QUIT button
if (point_in_rectangle(mouse_x_pos, mouse_y_pos, button_x, quit_y, button_x + button_width, quit_y + button_height)) {
    hover_quit = true;
    if (mouse_check_button_released(mb_left)) {
        game_end();
    }
}