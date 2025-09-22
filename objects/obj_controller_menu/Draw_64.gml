/// @description Draw GUI Event obj_controller_menu

// Draw buttons only if fade in is complete and not transitioning
if (fade_complete && !transitioning) {
    // Get button dimensions for fit_to_box
    var button_w = sprite_get_width(spr_menu_button);
    var button_h = sprite_get_height(spr_menu_button);
    
    // Draw START button
    draw_sprite(spr_menu_button, 0, button_x, start_y);
    var start_text;
    if (hover_start) {
        start_text = "[fnt_start_message][fa_center][fa_middle][c_red]START";
    } else {
        start_text = "[fnt_start_message][fa_center][fa_middle][c_white]START";
    }
    scribble(start_text).fit_to_box(button_w - 20, button_h - 20).draw(button_x, start_y);

    // Draw SCORE button
    draw_sprite(spr_menu_button, 0, button_x, score_y);
    var score_text;
    if (hover_score) {
        score_text = "[fnt_start_message][fa_center][fa_middle][c_red]SCORE";
    } else {
        score_text = "[fnt_start_message][fa_center][fa_middle][c_white]SCORE";
    }
    scribble(score_text).fit_to_box(button_w - 20, button_h - 20).draw(button_x, score_y);

    // Draw VOLUME button
    draw_sprite(spr_menu_button, 0, button_x, volume_y);
    var volume_percentage = string(round(global.game_volume * 100)) + "%";
    var volume_text;
    if (hover_volume) {
        volume_text = "[fnt_start_message][fa_center][fa_middle][c_red]VOLUME " + volume_percentage;
    } else {
        volume_text = "[fnt_start_message][fa_center][fa_middle][c_white]VOLUME " + volume_percentage;
    }
    scribble(volume_text).fit_to_box(button_w - 20, button_h - 30).draw(button_x, volume_y);
	
	// Draw volume instructions if hovering over VOLUME
    if (hover_volume) {
        var volume_x = button_x + button_width/2 + 20;
        var volume_instruction_text = "[fnt_start_message][fa_left][fa_middle][c_white]Left click: Increase volume\nRight click: Decrease volume";
        
        scribble(volume_instruction_text).fit_to_box(300, 100).draw(volume_x, volume_y);
    }

    // Draw QUIT button
    draw_sprite(spr_menu_button, 0, button_x, quit_y);
    var quit_text;
    if (hover_quit) {
        quit_text = "[fnt_start_message][fa_center][fa_middle][c_red]QUIT";
    } else {
        quit_text = "[fnt_start_message][fa_center][fa_middle][c_white]QUIT";
    }
    scribble(quit_text).fit_to_box(button_w - 20, button_h - 20).draw(button_x, quit_y);
    
    // Draw statistics if hovering over SCORE 
    if (hover_score) {
        var stats_x = button_x + button_width/2 + 20;
        
        // Mostrar os 3 melhores scores
        if (array_length(global.game_scores) > 0) {
            var scores_text = "[fnt_start_message][fa_left][fa_top][c_white]HIGH SCORES:\n\n";
            
            for (var i = 0; i < array_length(global.game_scores); i++) {
                var score_entry = global.game_scores[i];
                var rank = string(i + 1) + ". ";
                
                // Formatar tempo
                var time_text;
                var minutes = floor(score_entry.time / 60);
                var seconds = score_entry.time % 60;
                if (minutes > 0) {
                    time_text = string(minutes) + "m " + string(seconds) + "s";
                } else {
                    time_text = string(seconds) + "s";
                }
                
                scores_text += rank + "Score: " + string(score_entry.score) + "\n";
                scores_text += "   Time: " + time_text + "\n";
                scores_text += "   Waves: " + string(score_entry.waves) + "\n";
                scores_text += "   Gold: " + string(score_entry.gold) + "\n\n";
            }
            
            // Usar fit_to_box para controlar o tamanho
            var text_width = 300;  
            var text_height = 500; 
            
            scribble(scores_text).fit_to_box(text_width, text_height).draw(stats_x, score_y - 150);
        } else {
            // Se não há scores salvos ainda
            var no_scores_text = "[fnt_start_message][fa_left][fa_middle][c_white]HIGH SCORES:\n\nNo scores yet!\nPlay to set your first score.";
            
            // Fit to box também para o texto de "no scores"
            scribble(no_scores_text).fit_to_box(300, 200).draw(stats_x, score_y);
        }
    }
}

// Draw fade overlay 
if (!fade_complete || transitioning) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1.0);
}