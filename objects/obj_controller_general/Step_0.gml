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

// Start game
if (show_start_prompt && !game_ready) {
    if (mouse_check_button_released(mb_left)) {
        show_start_prompt = false;
        game_ready = true;
        global.game_started = true;
        
        audio_play_sound(snd_game_music, 1, true);
        audio_sound_gain(snd_game_music, global.game_volume * 0.7, 0);
        
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
		
	// Heal spawn logic
	if (current_wave >= 1) {
	    var heals_per_wave = (current_wave >= 4) ? 2 : 1;
	    var spawn_times = (current_wave >= 4) ? [10 * game_get_speed(gamespeed_fps), 20 * game_get_speed(gamespeed_fps)] : [15 * game_get_speed(gamespeed_fps)];
    
	    for (var i = 0; i < array_length(spawn_times); i++) {
	        if (wave_timer == spawn_times[i] && heal_spawned_this_wave < heals_per_wave) {
	            spawn_heal_item();
	            heal_spawned_this_wave++;
	        }
	    }
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

// Activate shockwave
if (keyboard_check_pressed(vk_space) && global.game_started && !game_over) {
    if (shockwave_cooldown_current <= 0) {    		
        instance_create_layer(0, 0, "Instances", obj_shockwave);
        
        shockwave_cooldown_current = shockwave_cooldown_max;
                
    } else {
        var seconds_left = ceil(shockwave_cooldown_current / game_get_speed(gamespeed_fps));        
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

if (shockwave_cooldown_current > 0) {
    shockwave_cooldown_current--;
}