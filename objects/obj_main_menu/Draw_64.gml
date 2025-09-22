/// @description Draw GUI Event obj_main_menu

// Draw START button
var start_color = hover_start ? hover_color : normal_color;
draw_set_color(start_color);
draw_rectangle(button_x, start_y, button_x + button_width, start_y + button_height, false);
draw_set_color(c_white);
draw_rectangle(button_x, start_y, button_x + button_width, start_y + button_height, true);

var start_text = "[fnt_start_message][fa_center][fa_middle][c_white]START";
scribble(start_text).draw(button_x + button_width/2, start_y + button_height/2);

// Draw SCORE button
var score_color = hover_score ? hover_color : normal_color;
draw_set_color(score_color);
draw_rectangle(button_x, score_y, button_x + button_width, score_y + button_height, false);
draw_set_color(c_white);
draw_rectangle(button_x, score_y, button_x + button_width, score_y + button_height, true);

var score_text = "[fnt_start_message][fa_center][fa_middle][c_white]SCORE";
scribble(score_text).draw(button_x + button_width/2, score_y + button_height/2);

// Draw QUIT button
var quit_color = hover_quit ? hover_color : normal_color;
draw_set_color(quit_color);
draw_rectangle(button_x, quit_y, button_x + button_width, quit_y + button_height, false);
draw_set_color(c_white);
draw_rectangle(button_x, quit_y, button_x + button_width, quit_y + button_height, true);

var quit_text = "[fnt_start_message][fa_center][fa_middle][c_white]QUIT";
scribble(quit_text).draw(button_x + button_width/2, quit_y + button_height/2);

// Draw statistics if hovering over SCORE
if (hover_score) {
    var stats_x = button_x + button_width + 20;
    var stats_text = "[fnt_start_message][fa_left][fa_middle][c_white]Best Time: " + string(best_time) + 
                    "\nBest Wave: " + string(best_wave) + 
                    "\nGames Played: " + string(total_games);
    scribble(stats_text).draw(stats_x, score_y + button_height/2);
}