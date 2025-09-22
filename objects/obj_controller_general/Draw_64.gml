/// @description Draw GUI Event obj_controller_general

if (room != rm_game) {
    exit;
}

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
    text_element.draw(gui_w/2, gui_h/2 - 40);
    
    // Score explanation 
    var score_text = "[fnt_start_message][fa_center][fa_middle][c_yellow]Your final score is calculated based on\ntime survived, waves completed and remaining gold";
    scribble(score_text).draw(gui_w/2, gui_h/2 + 60);
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
    
    // Main shop window using spr_shop
    var shop_x = gui_w/2;  
    var shop_y = gui_h/2;
    
    draw_sprite(spr_shop, 0, shop_x, shop_y);
    
    // Menu box dimensions
    var box_w = sprite_get_width(spr_menu_button);
    var box_h = sprite_get_height(spr_menu_button);
    var spacing = 100;
    
    // Upgrade box positions (2 embaixo, 1 em cima no centro)
    var box_positions = [
        { x: shop_x - box_w/2 - spacing, y: shop_y + 100 },  // Bottom left
        { x: shop_x + box_w/2 + spacing, y: shop_y + 100 },  // Bottom right  
        { x: shop_x, y: shop_y - 40 }                       // Top center
    ];
    
       // Draw upgrade boxes
    for (var i = 0; i < 3; i++) {
        var pos = box_positions[i];
        
        // Draw menu box sprite
        draw_sprite(spr_menu_button, 0, pos.x, pos.y);
        
        // Item text with fit_to_box
        var item_name = string_upper(shop_selected_items[i]);
        var item_cost = get_item_cost(shop_selected_items[i]);
        
        var item_text = "";
        if (shop_mouse_over == i) {
            item_text = "[fnt_start_message][fa_center][fa_middle][c_yellow]" + 
                       item_name + "\n" + string(item_cost) + " Gold";
        } else {
            item_text = "[fnt_start_message][fa_center][fa_middle][c_white]" + 
                       item_name + "\n" + string(item_cost) + " Gold";
        }
        
        scribble(item_text)
            .fit_to_box(box_w - 30, box_h - 30)  
            .draw(pos.x, pos.y);
    }
    
    // Description area 
    var desc_y = shop_y + 120;  
    var description_text;
    
    if (shop_mouse_over != -1) {        
        var item_type = shop_selected_items[shop_mouse_over];
        description_text = "[fnt_start_message][fa_center][fa_middle][c_white]" + get_item_description(item_type);
    } else {
        description_text = "[fnt_start_message][fa_center][fa_middle][c_white]Choose an upgrade!";
    }
    
    // Fit description text to shop area
    var shop_w = sprite_get_width(spr_shop);
	var description_height = string_height(description_text)
    scribble(description_text)
        .fit_to_box(shop_w - 480, description_height * 3)  
        .draw(shop_x, desc_y + 120);
    
    // Close instruction 
    var close_text = "[fnt_start_message][fa_center][fa_top][c_red]Press ESC to continue";
    scribble(close_text).draw(shop_x, shop_y + 450);
}

// Game over screen
if (game_over) {
    var gui_w = display_get_gui_width();
    var gui_h = display_get_gui_height();
    
    // Draw game over sprite (pivot middle center)
    draw_sprite(spr_game_over, 0, gui_w/2, gui_h/2);
    
    // Calculate time statistics
    var total_seconds = floor(total_game_timer / 60);
    var minutes = floor(total_seconds / 60);
    var seconds = total_seconds % 60;
    var time_text;
    if (minutes > 0) {
        time_text = string(minutes) + "m " + string(seconds) + "s";
    } else {
        time_text = string(seconds) + "s";
    }
    
    // Statistics text (ABOVE the game over sprite)
    var waves_survived = current_wave - 1;
    var stats_text = "[fnt_start_message][fa_center][fa_middle][c_white]Time Survived: " + time_text + 
                    "\nWaves Survived: " + string(waves_survived) +
                    "\nGold Remaining: " + string(player_gold) +
                    "\nFinal Score: " + string(final_score);
    
    scribble(stats_text).draw(gui_w/2, gui_h/2 - 200);  
    
    // NOVO: Comandos atualizados (BELOW the game over sprite)
    var restart_text = "[fnt_start_message][fa_center][fa_middle][c_white]Press SPACE to restart\nPress ESC to return to main menu";
    
    scribble(restart_text).draw(gui_w/2, gui_h/2 + 220);  
}