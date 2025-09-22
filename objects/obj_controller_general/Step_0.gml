/// @description Step Event obj_controller_general

if (room != rm_game) {
    exit;
}

if (!fade_complete) {
    fade_timer++;
    fade_alpha = max(0, 1.0 - (fade_timer / fade_duration));
    
    if (fade_timer >= fade_duration) {
        fade_complete = true;
        show_start_prompt = true;
    }        
}

if (show_start_prompt && !game_ready) {
    if (mouse_check_button_released(mb_left)) {
        show_start_prompt = false;
        game_ready = true;
        global.game_started = true;
        
        // Enable moon movement
        for (var i = 0; i < array_length(moon_objs); i++) {
            if (instance_exists(moon_objs[i])) {
                moon_objs[i].is_moving = true;
            }
        }
    }
}

if (game_ready && global.game_started && !shop_open) {    
    wave_timer++;       
	total_game_timer++;
    enemy_spawn_timer++;
	
    if (enemy_spawn_timer >= enemy_spawn_interval && 
	    enemies_spawned < enemies_per_wave && 
	    wave_timer <= spawn_duration) { 
	    spawn_enemy();
	    enemies_spawned++;
	    enemy_spawn_timer = 0;
	}
    
    // Check wave completion
    if (wave_timer >= wave_duration && array_length(enemies_list) == 0) {
        end_wave();
    }
    
    // Clean up destroyed enemies
    var i = 0;
    while (i < array_length(enemies_list)) {
        if (!instance_exists(enemies_list[i])) {
            array_delete(enemies_list, i, 1);
        } else {
            i++;
        }
    }
}

// Shop controls
if (shop_open) {
    handle_shop_input();
}

// Update falling heart parts
for (var i = array_length(heart_parts_falling) - 1; i >= 0; i--) {
    var part = heart_parts_falling[i];
    part.timer++;
    part.y_pos += 3; // Fall speed
    part.alpha = 1.0 - (part.timer / part.fall_duration);
    
    if (part.timer >= part.fall_duration) {
        array_delete(heart_parts_falling, i, 1);
    }
}

// Update falling shield parts
for (var i = array_length(shield_parts_falling) - 1; i >= 0; i--) {
    var part = shield_parts_falling[i];
    part.timer++;
    part.y_pos += 3; // Fall speed
    part.alpha = 1.0 - (part.timer / part.fall_duration);
    
    if (part.timer >= part.fall_duration) {
        array_delete(shield_parts_falling, i, 1);
    }
}

// Game over input
if (game_over) {
    if (keyboard_check_pressed(vk_space)) {
        // Restart game
        init_game();	
        init_spawn();
        init_health();
        calculate_spawn_interval();
        
        initialize_all_globals();
        room_restart();
    }
        
    if (keyboard_check_pressed(vk_escape)) {
        // Reset all variables
        init_game();	
        init_spawn();
        init_health();
        calculate_spawn_interval();
        
        initialize_all_globals();
        room_goto(rm_main_menu);
    }
}

