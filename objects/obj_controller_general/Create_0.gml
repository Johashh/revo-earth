/// @description Create Event obj_controller_general

randomize();

should_restar_game = false;
shockwave_cooldown_max = game_get_speed(gamespeed_fps) * 40;

function init_game(){
	fade_alpha = 1.0;
	fade_duration = game_get_speed(gamespeed_fps);
	fade_timer = 0;
	fade_complete = false;
	objects_created = false;
	show_start_prompt = false;
	game_ready = false;
	earth_obj = noone;
	moon_objs = array_create(0);
	shop_itens = ["speed", "shield", "size"];	
	is_in_game_room = false;
	shockwave_cooldown_current = 0;
}

init_game();

#region SPAWN

	function init_spawn(){
	    current_wave = 1;
	    wave_timer = 0;
	    wave_duration = 30 * game_get_speed(gamespeed_fps);  
	    spawn_duration = 25 * game_get_speed(gamespeed_fps); 
	    enemies_spawned = 0;
	    enemies_per_wave = 10;
	    enemy_spawn_timer = 0;
	    enemy_spawn_interval = 0;

	    player_gold = 150; 
	    final_score = 0;

	    shop_open = false;
	    shop_mouse_over = -1;

	    // Shop items system
	    shop_items = ["speed", "shield", "size", "resistance", "heal_up"];
	    shop_selected_items = array_create(3);

	    // Size upgrade system
	    size_upgrade_pending = false;
	    resistance_level = 0;
	    heal_up_level = 0; 

	    zigzag_chance = 0; 
	    zigzag_active = false;
	    enemies_list = array_create(0);
    
	    // Heal spawn system
	    heal_spawned_this_wave = 0;
	    heal_spawn_times = [];
	}

	init_spawn();
	
	function calculate_spawn_interval() {	    
	    var spawn_time_frames = 25 * game_get_speed(gamespeed_fps);
    	    
	    enemy_spawn_interval = spawn_time_frames / enemies_per_wave;
    	
	    var interval_seconds = enemy_spawn_interval / game_get_speed(gamespeed_fps);	    
	}  
	
	function spawn_enemy() {
	    var spawn_side = irandom(3);
	    var spawn_x, spawn_y;
    
	    switch(spawn_side) {
	        case 0: // Top
	            spawn_x = irandom(room_width);
	            spawn_y = -50;
	            break;
	        case 1: // Right
	            spawn_x = room_width + 50;
	            spawn_y = irandom(room_height);
	            break;
	        case 2: // Bottom
	            spawn_x = irandom(room_width);
	            spawn_y = room_height + 50;
	            break;
	        case 3: // Left
	            spawn_x = -50;
	            spawn_y = irandom(room_height);
	            break;
	    }
    
	    var enemy = instance_create_layer(spawn_x, spawn_y, "Instances", obj_enemy_meat);
    	    
	    if (instance_exists(obj_earth)) {
	        var target_x = obj_earth.x;
	        var target_y = obj_earth.y;
	    }
    
	    // Zigzag logic
	    if (current_wave >= 4 && random(100) < zigzag_chance) {
	        enemy.use_zigzag = true;
	        if (!zigzag_active) {
	            zigzag_active = true;
	            zigzag_chance = 1;
	        }
	    }
    
    array_push(enemies_list, enemy);
}
		
	function spawn_heal_item() {
	    var spawn_side = irandom(3);
	    var spawn_x, spawn_y;
    
	    switch(spawn_side) {
	        case 0: // Top
	            spawn_x = irandom(room_width);
	            spawn_y = -50;
	            break;
	        case 1: // Right
	            spawn_x = room_width + 50;
	            spawn_y = irandom(room_height);
	            break;
	        case 2: // Bottom
	            spawn_x = irandom(room_width);
	            spawn_y = room_height + 50;
	            break;
	        case 3: // Left
	            spawn_x = -50;
	            spawn_y = irandom(room_height);
	            break;
	    }
    
	    instance_create_layer(spawn_x, spawn_y, "Instances", obj_heal);
	}

	function end_wave() {
	    shop_open = true;
	    current_wave++;

	    wave_timer = 0; 
	    enemies_spawned = 0;
	    heal_spawned_this_wave = 0; 
    
	    var available_items = [];
	    array_push(available_items, "speed");
	    array_push(available_items, "shield");
	    array_push(available_items, "size");
        
	    if (resistance_level < 2) {
	        array_push(available_items, "resistance");
	    }
    
	    if (heal_up_level < 2) {
	        array_push(available_items, "heal_up");
	    }
       
	    shop_selected_items = array_create(3);
	    var available_copy = array_create(array_length(available_items));
	    array_copy(available_copy, 0, available_items, 0, array_length(available_items));

	    for (var i = 0; i < 3; i++) {
	        if (array_length(available_copy) > 0) {
	            var random_index = irandom(array_length(available_copy) - 1);
	            shop_selected_items[i] = available_copy[random_index];
	            array_delete(available_copy, random_index, 1); 
	        }
	    }

	    calculate_spawn_interval();
	    enemies_per_wave += 4;

	    if (current_wave >= 4 && (current_wave - 4) % 3 == 0) {
	        zigzag_chance = min(zigzag_chance + 1, 25);
	    }
	}

	function handle_shop_input() {
	    var mouse_gui_x = device_mouse_x_to_gui(0);
	    var mouse_gui_y = device_mouse_y_to_gui(0);    	    
	    var gui_w = display_get_gui_width();
	    var gui_h = display_get_gui_height();

	    var shop_x = gui_w/2; 
	    var shop_y = gui_h/2;

	    // Menu box dimensions for upgrade boxes
	    var box_w = sprite_get_width(spr_menu_button);
	    var box_h = sprite_get_height(spr_menu_button);
	    var spacing = 100;  
    	    
	    var box_positions = [
	        { x: shop_x - box_w/2 - spacing, y: shop_y + 100 },  // Bottom left
	        { x: shop_x + box_w/2 + spacing, y: shop_y + 100 },  // Bottom right  
	        { x: shop_x, y: shop_y - 40 }                       // Top center
	    ];

	    shop_mouse_over = -1;

	    for (var i = 0; i < 3; i++) {
	        var pos = box_positions[i];
        
	        if (point_in_rectangle(mouse_gui_x, mouse_gui_y, 
	                              pos.x - box_w/2, pos.y - box_h/2, 
	                              pos.x + box_w/2, pos.y + box_h/2)) {
	            shop_mouse_over = i;
	            if (mouse_check_button_pressed(mb_left)) {
	                buy_shop_item(i);
	            }
	        }
	    }

	    if (keyboard_check_pressed(vk_escape)) {
	        close_shop();
	    }
	}

	function buy_shop_item(item_id) {
	    var item_type = shop_selected_items[item_id];
	    var cost = get_item_cost(item_type);

	    if (player_gold >= cost) {
	        player_gold -= cost;
        
	        audio_play_sound(snd_purchase, 1, false);

	        switch(item_type) {
	            case "speed":
	                if (instance_exists(obj_player)) {
	                    obj_player.orbital_speed += 0.2;
	                }
	                break;
	            case "shield":
	                shield_current += 3; 
	                break;
	            case "size":                
	                size_upgrade_pending = true;
	                break;
	            case "resistance":
	                resistance_level++;
	                damage_to_apply = max(1, damage_to_apply - 1); 
	                break;
					
				case "heal_up":
				    heal_up_level++;
				    break;
	        }

	        close_shop();
	    }
	}
	
	function get_item_cost(item_type) {
	    switch(item_type) {
	        case "speed": return 50;
	        case "shield": return 50;
	        case "size": return 50;
	        case "resistance": 
	            if (resistance_level == 0) return 150;
	            else if (resistance_level == 1) return 300;
	            return 999999; 
			case "heal_up": 
			    if (heal_up_level == 0) return 150;
			    else if (heal_up_level == 1) return 300;
			    return 999999;
				
	        default: return 50;
	    }
	}
		
	function get_item_description(item_type) {
	    switch(item_type) {
	        case "speed": return "Increases player speed";
	        case "shield": return "Grants 3 shield points";
	        case "size": return "Temporarily increases player size";
	        case "resistance": 
	            var next_damage = max(1, damage_to_apply - 1);
	            return "Reduces enemy damage from " + string(damage_to_apply) + " to " + string(next_damage);
			case "heal_up": 
			    var next_heal = 1 + heal_up_level + 1;
			    return "Increases heal items recovery from " + string(1 + heal_up_level) + " to " + string(next_heal);
				
	        default: return "Unknown upgrade";
	    }
	}

	function close_shop() {
	    shop_open = false;
	    global.game_started = true;
    	    
	    calculate_spawn_interval();
		
		if (size_upgrade_pending && global.game_started && !shop_open) {
		    activate_size_upgrade();
		    size_upgrade_pending = false;
		}
	}
		
	function activate_size_upgrade() {
	    if (instance_exists(obj_player)) {
	        obj_player.size_upgrade_active = true;
	        obj_player.size_upgrade_timer = obj_player.size_upgrade_duration;
	        obj_player.current_scale = obj_player.upgraded_scale;
	    }
	}

#endregion

#region HEALTH SYSTEM
	
	function init_health(){
	    planet_max_health = 9.0;
	    planet_health = planet_max_health;
	    game_over = false;
	    total_game_timer = 0;    	    
	    heart_parts_falling = array_create(0);
    	damage_to_apply = 3;    
		
	    shield_max = 9.0;  
	    shield_current = 3.0; 
	    shield_parts_falling = array_create(0);
	}

	init_health();

	function damage_planet(damage_amount) {
	    if (game_over) return;
    
	    if (shield_current > 0) {	        
	        create_falling_shield_part();
        	        
	        shield_current -= damage_to_apply;
        
	        if (shield_current < 0) {
	            var overflow_damage = abs(shield_current);
	            shield_current = 0;
            
	            if (overflow_damage > 0) {	                
	                var original_damage = damage_to_apply;
	                damage_to_apply = overflow_damage; 
                
	                create_falling_heart_part();
                
	                damage_to_apply = original_damage;
                
	                planet_health -= overflow_damage;
	                planet_health = max(0, planet_health);
	            }
	        }
	    } else {	        
	        create_falling_heart_part();
        	        
	        planet_health -= damage_to_apply;
	        planet_health = max(0, planet_health);
	    }
		
		if (instance_exists(obj_earth)) {
	        obj_earth.update_earth_sprite();
	    }
		
	    if (planet_health <= 0) {
	        trigger_game_over();
	    }
	}
		
	function draw_planet_hearts() {
	    var box_sprite_w = sprite_get_width(spr_heart_box);
	    var box_sprite_h = sprite_get_height(spr_heart_box);
    
	    var box_x = 20 + box_sprite_w/2;
	    var box_y = display_get_gui_height() - 20 - box_sprite_h/2;
    
	    draw_sprite(spr_heart_box, 0, box_x, box_y);
    
	    var heart_part_width = sprite_get_width(spr_left_heart);
	    var full_heart_width = heart_part_width * 3;
	    var heart_spacing = 20;
    
	    var hearts_start_x = box_x - box_sprite_w/2 + 30;
	    var hearts_y = box_y;
    
	    for (var i = 0; i < 3; i++) {
	        var heart_x = hearts_start_x + (i * (full_heart_width + heart_spacing));
        
	        var parts_for_this_heart = max(0, min(3, planet_health - (i * 3)));
        
	        if (parts_for_this_heart >= 1 && !is_part_falling(i, 0)) {
	            draw_heart_part(heart_x, hearts_y, "left");
	        }
	        if (parts_for_this_heart >= 2 && !is_part_falling(i, 1)) {
	            draw_heart_part(heart_x + heart_part_width, hearts_y, "mid");
	        }
	        if (parts_for_this_heart >= 3 && !is_part_falling(i, 2)) {
	            draw_heart_part(heart_x + (heart_part_width * 2), hearts_y, "right");
	        }
        
	        var shield_parts_for_heart = max(0, min(3, shield_current - (i * 3)));
        
	        if (shield_parts_for_heart > 0) {
	            var heart_mid_x = heart_x + heart_part_width;
	            var shield_part_width = sprite_get_width(spr_mid_shield);
            
	            if (shield_parts_for_heart >= 1 && !is_shield_part_falling(i, 0)) {
	                draw_shield_part(heart_mid_x - shield_part_width, hearts_y, "left");
	            }
	            if (shield_parts_for_heart >= 2 && !is_shield_part_falling(i, 1)) {
	                draw_shield_part(heart_mid_x, hearts_y, "mid");
	            }
	            if (shield_parts_for_heart >= 3 && !is_shield_part_falling(i, 2)) {
	                draw_shield_part(heart_mid_x + shield_part_width, hearts_y, "right");
	            }
	        }
	    }
    
	    for (var i = 0; i < array_length(heart_parts_falling); i++) {
	        var part = heart_parts_falling[i];
	        var heart_x = hearts_start_x + (part.heart_index * (full_heart_width + heart_spacing));
	        var part_x = heart_x + (part.part_index * heart_part_width);
        
	        draw_set_alpha(part.alpha);
        
	        var part_type;
	        switch(part.part_index) {
	            case 0: part_type = "left"; break;
	            case 1: part_type = "mid"; break;
	            case 2: part_type = "right"; break;
	        }
        
	        draw_heart_part(part_x, part.y_pos, part_type);
	        draw_set_alpha(1.0);
	    }
    
	    for (var i = 0; i < array_length(shield_parts_falling); i++) {
	        var part = shield_parts_falling[i];
	        var heart_x = hearts_start_x + (part.heart_index * (full_heart_width + heart_spacing));
	        var heart_mid_x = heart_x + heart_part_width;
	        var shield_part_width = sprite_get_width(spr_mid_shield);
        
	        var shield_x;
	        if (part.part_index == 0) {
	            shield_x = heart_mid_x - shield_part_width;
	        } else if (part.part_index == 1) {
	            shield_x = heart_mid_x;
	        } else {
	            shield_x = heart_mid_x + shield_part_width;
	        }
        
	        draw_set_alpha(part.alpha);
        
	        var part_type;
	        switch(part.part_index) {
	            case 0: part_type = "left"; break;
	            case 1: part_type = "mid"; break;
	            case 2: part_type = "right"; break;
	        }
        
	        draw_shield_part(shield_x, part.y_pos, part_type);
	        draw_set_alpha(1.0);
	    }
	}

	function is_part_falling(heart_index, part_index) {
	    for (var i = 0; i < array_length(heart_parts_falling); i++) {
	        var part = heart_parts_falling[i];
	        if (part.heart_index == heart_index && part.part_index == part_index) {
	            return true;
	        }
	    }
	    return false;
	}

	function create_falling_heart_part() {
	    var actual_damage = min(damage_to_apply, planet_health);
    
	    var box_sprite_h = sprite_get_height(spr_heart_box);
	    var initial_y = display_get_gui_height() - 20 - box_sprite_h/2;
    
	    for (var d = 0; d < actual_damage; d++) {
	        var health_before_this_damage = planet_health - d;
        
	        var zero_based_health = health_before_this_damage - 1;
	        var heart_index = floor(zero_based_health / 3);
	        var part_index = zero_based_health % 3;

	        var part_data = {
	            heart_index: heart_index,
	            part_index: part_index,
	            y_pos: initial_y,
	            alpha: 1.0,
	            timer: 0,
	            fall_duration: game_get_speed(gamespeed_fps) * 0.5
	        };

	        array_push(heart_parts_falling, part_data);
	    }
	}

	function create_falling_shield_part() {
	    var actual_damage = min(damage_to_apply, shield_current);
    
	    var box_sprite_h = sprite_get_height(spr_heart_box);
	    var initial_y = display_get_gui_height() - 20 - box_sprite_h/2;
    
	    for (var d = 0; d < actual_damage; d++) {
	        var shield_before_this_damage = shield_current - d;
        
	        var zero_based_shield = shield_before_this_damage - 1;
	        var heart_index = floor(zero_based_shield / 3);
	        var part_index = zero_based_shield % 3;

	        var part_data = {
	            heart_index: heart_index,
	            part_index: part_index,
	            y_pos: initial_y,
	            alpha: 1.0,
	            timer: 0,
	            fall_duration: game_get_speed(gamespeed_fps) * 0.5
	        };

	        array_push(shield_parts_falling, part_data);
	    }
	}

	function draw_heart_part(x, y, part_type) {
	    switch(part_type) {
	        case "left":
	            draw_sprite(spr_left_heart, 0, x, y);
	            break;
	        case "mid":
	            draw_sprite(spr_mid_heart, 0, x, y);
	            break;
	        case "right":
	            draw_sprite(spr_right_heart, 0, x, y);
	            break;
	    }
	}
		
	function draw_shield_part(x, y, part_type) {
	    switch(part_type) {
	        case "left":
	            draw_sprite(spr_left_shield, 0, x, y);
	            break;
	        case "mid":
	            draw_sprite(spr_mid_shield, 0, x, y);
	            break;
	        case "right":
	            draw_sprite(spr_right_shield, 0, x, y);
	            break;
	    }
	}

	function is_shield_part_falling(heart_index, part_index) {
	    for (var i = 0; i < array_length(shield_parts_falling); i++) {
	        var part = shield_parts_falling[i];
	        if (part.heart_index == heart_index && part.part_index == part_index) {
	            return true;
	        }
	    }
	    return false;
	}

	function trigger_game_over() {
	    game_over = true;
	    global.game_started = false;
    
	    audio_stop_sound(snd_game_music);
    
	    var waves_survived = current_wave - 1;
	    var time_seconds = floor(total_game_timer / 60);
	    final_score = (waves_survived * 100) + time_seconds + player_gold;
    
	    save_high_score(final_score, waves_survived, time_seconds, player_gold);
    
	    global.total_games++;
    
	    var time = floor(total_game_timer / 60);
	    if (time > global.best_time) {
	        global.best_time = time;
	    }
    
	    if (current_wave > global.best_wave) {
	        global.best_wave = current_wave;
	    }
	}

	function save_high_score(score, waves, time_seconds, gold) {
	    var score_entry = {
	        score: score,
	        waves: waves,
	        time: time_seconds,
	        gold: gold
	    };
    
	    array_push(global.game_scores, score_entry);
    
	    array_sort(global.game_scores, function(a, b) {
	        return b.score - a.score;
	    });
    
	    if (array_length(global.game_scores) > 3) {
	        array_resize(global.game_scores, 3);
	    }
    	    
	    save_scores_to_file();
    
	    show_debug_message("Score saved: " + string(score) + " (Total scores: " + string(array_length(global.game_scores)) + ")");
	}   

#endregion

#region SAVE/LOAD

	function save_scores_to_file() {
	    var filename = "game_scores.json";
	    var file_path = working_directory + filename;
    
	    try {
	        var json_string = json_stringify(global.game_scores);
	        var file = file_text_open_write(file_path);
	        file_text_write_string(file, json_string);
	        file_text_close(file);
        
	        show_debug_message("Scores saved successfully to: " + file_path);
	    } catch(e) {
	        show_debug_message("Error saving scores: " + string(e));
	    }
	}

	function load_scores_from_file() {
	    var filename = "game_scores.json";
	    var file_path = working_directory + filename;
    
	    if (file_exists(file_path)) {
	        try {
	            var file = file_text_open_read(file_path);
	            var json_string = "";
            
	            while (!file_text_eof(file)) {
	                json_string += file_text_read_string(file);
	                file_text_readln(file);
	            }
            
	            file_text_close(file);
            
	            if (json_string != "") {
	                global.game_scores = json_parse(json_string);
	                show_debug_message("Scores loaded successfully: " + string(array_length(global.game_scores)) + " entries");
	            } else {
	                global.game_scores = [];
	                show_debug_message("Empty file, initializing empty scores array");
	            }
	        } catch(e) {
	            show_debug_message("Error loading scores: " + string(e));
	            global.game_scores = [];
	        }
	    } else {
	        global.game_scores = [];
	        show_debug_message("No scores file found, starting with empty array");
	    }
	}

#endregion 

calculate_spawn_interval();