/// @description Draw GUI Event obj_controller_general

if (!fade_complete) {
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1.0);
}

if (show_start_prompt) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1.0);
    
    // Start message using Scribble
    var message_text = "[fnt_start_message][fa_center][fa_middle][c_white]Click anywhere to start";
    var text_element = scribble(message_text);
    
    text_element.fit_to_box(gui_w - 100, gui_h - 100, true);
    text_element.draw(gui_w/2, gui_h/2);
}

if (game_ready && !shop_open && !game_over) {
    // Timer and wave counter (top-left)
    var total_seconds = floor(total_game_timer / 60);
    var minutes = floor(total_seconds / 60);
    var seconds = total_seconds % 60;
    var time_display = string(minutes) + ":" + string_format(seconds, 2, 0);
    
    var timer_text = "[fnt_start_message][fa_left][fa_top][c_white]Time: " + time_display + "\nWave: " + string(current_wave);
    
    var timer_element = scribble(timer_text);
    timer_element.fit_to_box(224, 48, false);
    timer_element.draw(10, 10);
    
    // Gold counter
    var gold_text = "[fnt_start_message][fa_right][fa_top][c_yellow]Gold: " + string(player_gold);
    scribble(gold_text).draw(display_get_gui_width() - 10, 10);
    
    // Planet health display (bottom-left)
    draw_planet_hearts();
}

// Shop interface
if (shop_open) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1.0);
    
    // Main shop window 
    var shop_w = 600;
    var shop_h = 280;
    var shop_x = gui_w/2 - shop_w/2;  
    var shop_y = gui_h/2 - shop_h/2; 
    
    draw_set_color(c_gray);
    draw_rectangle(shop_x, shop_y, shop_x + shop_w, shop_y + shop_h, false);
    draw_set_color(c_white);
    draw_rectangle(shop_x, shop_y, shop_x + shop_w, shop_y + shop_h, true);
    
    // Shop title 
    var title_text = "[fnt_start_message][fa_center][fa_top][c_white]SHOP - Wave " + string(current_wave);
    scribble(title_text).draw(shop_x + shop_w/2, shop_y + 15);
    
    // Shop items 
    var total_items = 3;
    var item_w = 120;
    var item_h = 60;   
    var available_width = shop_w - 40; 
    var spacing = (available_width - (total_items * item_w)) / (total_items + 1);
    
    for (var i = 0; i < total_items; i++) {
        var item_x = shop_x + 20 + spacing + (i * (item_w + spacing));
        var item_y = shop_y + 100; 
        
        // Item background - blue for hover, dark gray for normal
        var item_color = (shop_mouse_over == i) ? c_blue : c_dkgray;
        draw_set_color(item_color);
        draw_rectangle(item_x, item_y, item_x + item_w, item_y + item_h, false);
        draw_set_color(c_white);
        draw_rectangle(item_x, item_y, item_x + item_w, item_y + item_h, true);
        
        // Item text with upgrade name
        var item_name = string_upper(shop_selected_items[i]);
        var item_text = "[fnt_start_message][fa_center][fa_middle][c_white]" + item_name + "\n50 Gold";
        scribble(item_text)
        .fit_to_box(item_w - 10, item_h - 10)
        .draw(item_x + item_w/2, item_y + item_h/2);
    }
    
    // Description area
    var desc_y = shop_y + 220;
    var description_text;
    
    if (shop_mouse_over != -1) {        
        var item_type = shop_selected_items[shop_mouse_over];
        description_text = "[fnt_start_message][fa_center][fa_middle][c_white]" + get_item_description(item_type);
    } else {
        // Show shop message
        description_text = "[fnt_start_message][fa_center][fa_middle][c_white]Choose an upgrade!";
    }
    
    scribble(description_text).draw(shop_x + shop_w/2, desc_y);
    
    // Close instruction
    var close_text = "[fnt_start_message][fa_center][fa_top][c_white]Press ESC to continue";
    scribble(close_text).draw(shop_x + shop_w/2, shop_y + shop_h + 20);
}

// Game over screen
if (game_over) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    // Semi-transparent overlay
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, gui_w, gui_h, false);
    draw_set_alpha(1.0);
    
    // Game over message
    var total_seconds = floor(total_game_timer / 60);
    var minutes = floor(total_seconds / 60);
    var seconds = total_seconds % 60;
    var time_text = string(minutes) + ":" + string_format(seconds, 2, 0);
    
    var game_over_text = "[fnt_start_message][fa_center][fa_middle][c_white]GAME OVER\n\n" +
                        "Time Survived: " + time_text + "\n" +
                        "Waves Completed: " + string(current_wave - 1) + "\n\n" +
                        "Press space to restart";
    
    scribble(game_over_text).draw(gui_w/2, gui_h/2);
}