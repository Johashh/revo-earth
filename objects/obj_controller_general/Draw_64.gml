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
    
    // Main start message - moved much higher
    var start_text = "[fnt_start_message][fa_center][fa_middle][c_white]CLICK ANYWHERE TO START";
    scribble(start_text).draw(gui_w/2, gui_h/2 - 200);
    
    // Score calculation info - moved higher
    var score_text = "[fnt_start_message][fa_center][fa_middle][c_yellow]YOUR FINAL SCORE IS CALCULATED BASED ON\nTIME SURVIVED, WAVES COMPLETED AND REMAINING GOLD";
    scribble(score_text).draw(gui_w/2, gui_h/2 - 100);
    
    // Controls info - positioned below score text
    var controls_text = "[fnt_start_message][fa_center][fa_middle][c_lime]CONTROLS\n[c_white]Left/Right Arrows or A/D - Move player";
    scribble(controls_text).draw(gui_w/2, gui_h/2 + 100);
    
    // Shockwave info with icon reference - positioned below controls
    var shockwave_text = "[fnt_start_message][fa_center][fa_middle][c_white]SPACE - Activate Shockwave\n(Available when icon below is animated)";
    scribble(shockwave_text).draw(gui_w/2, gui_h/2 + 240);
    
    // Draw small shockwave icon as reference - positioned at bottom
    var icon_ref_x = gui_w/2;
    var icon_ref_y = gui_h/2 + 120;
    var sprite_w = sprite_get_width(spr_shockwave);
    var sprite_h = sprite_get_height(spr_shockwave);
    var ref_size = 60;
    var ref_scale_x = ref_size / sprite_w;
    var ref_scale_y = ref_size / sprite_h;
    
    // Animate the reference icon
    var animation_speed = 8;
    var frame_count = sprite_get_number(spr_shockwave);
    var time_per_frame = game_get_speed(gamespeed_fps) / animation_speed;
    var current_frame = floor((get_timer() / 1000000 * game_get_speed(gamespeed_fps)) / time_per_frame) % frame_count;
    
    draw_sprite_ext(spr_shockwave, current_frame, icon_ref_x, gui_h/2 + 400, ref_scale_x, ref_scale_y, 0, c_white, 1.0);
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
        
    var restart_text = "[fnt_start_message][fa_center][fa_middle][c_white]Press SPACE to restart\nPress ESC to return to main menu";
    
    scribble(restart_text).draw(gui_w/2, gui_h/2 + 220);  
}

// Draw shockwave cooldown icon
if (global.game_started && !game_over && !shop_open) {
    var icon_x = room_width / 2;
    var icon_y = room_height - 120;
    
    // Calculate scale to make it 100x100
    var sprite_w = sprite_get_width(spr_shockwave);
    var sprite_h = sprite_get_height(spr_shockwave);
    var target_size = 100;
    var scale_x = target_size / sprite_w;
    var scale_y = target_size / sprite_h;
    
    if (shockwave_cooldown_current <= 0) {
        // Ready - animate the icon using get_timer() for smooth animation
        var animation_speed = 8; // fps
        var frame_count = sprite_get_number(spr_shockwave);
        var time_per_frame = game_get_speed(gamespeed_fps) / animation_speed;
        var current_frame = floor((get_timer() / 1000000 * game_get_speed(gamespeed_fps)) / time_per_frame) % frame_count;
        
        draw_sprite_ext(spr_shockwave, current_frame, icon_x, icon_y, scale_x, scale_y, 0, c_white, 1.0);
    } else {
        // On cooldown - draw first frame only
        draw_sprite_ext(spr_shockwave, 0, icon_x, icon_y, scale_x, scale_y, 0, c_white, 1.0);
        
        // Draw cooldown overlay (top to bottom)
        var cooldown_progress = shockwave_cooldown_current / shockwave_cooldown_max;
        var overlay_height = target_size * cooldown_progress;
        
        // Calculate overlay position (top-left corner of the icon)
        var overlay_x = icon_x - (target_size / 2);
        var overlay_y = icon_y - (target_size / 2);
        
        // Draw part of the overlay sprite from top
        if (overlay_height > 0) {
            var overlay_sprite_h = sprite_get_height(spr_square_cooldown);
            var overlay_scale_x = target_size / sprite_get_width(spr_square_cooldown);
            
            // Use draw_sprite_part_ext to draw only the top portion
            var source_h = (overlay_height / target_size) * overlay_sprite_h;
            
            draw_sprite_part_ext(spr_square_cooldown, 0, 
                               0, 0, // source x, y
                               sprite_get_width(spr_square_cooldown), source_h, // source width, height
                               overlay_x, overlay_y, // destination x, y
                               overlay_scale_x, 1, // scale x, y
                               c_white, 0.6); // color, alpha (semi-transparent)
        }
    }
}