/// @description Create Event obj_controller_general

randomize();

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

	    player_gold = 50; 

	    shop_open = false;
	    shop_mouse_over = -1;
    
	    // Shop items system
	    shop_items = ["speed", "shield", "size"];
	    shop_selected_items = array_create(3);
    
	    // Size upgrade system
	    size_upgrade_pending = false;

	    zigzag_chance = 0; 
	    zigzag_active = false;
	    enemies_list = array_create(0);    
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

	function end_wave() {
	    shop_open = true;
	    current_wave++;
    
	    wave_timer = 0; 
	    enemies_spawned = 0;
    
	    // Copy all available items to selected items (for now)
	    for (var i = 0; i < 3; i++) {
	        shop_selected_items[i] = shop_items[i];
	    }
    
	    calculate_spawn_interval();
    
	    if (current_wave <= 3) {
	        enemies_per_wave += 2;
	    }
    
	    if (current_wave >= 4 && (current_wave - 4) % 3 == 0) {
	        zigzag_chance = min(zigzag_chance + 1, 25);
	    }
	}

	function handle_shop_input() {
	    var mouse_gui_x = device_mouse_x_to_gui(0);
	    var mouse_gui_y = device_mouse_y_to_gui(0);    	    
	    var gui_w = display_get_gui_width();
	    var gui_h = display_get_gui_height();
	    var shop_w = 600;
	    var shop_h = 200;
	    var shop_x = gui_w/2 - shop_w/2;
	    var shop_y = gui_h/2 - shop_h/2;
    
	    var total_items = 3;
	    var item_w = 120;
	    var item_h = 60;
	    var available_width = shop_w - 40;
	    var spacing = (available_width - (total_items * item_w)) / (total_items + 1);
    
	    shop_mouse_over = -1;
    
	    for (var i = 0; i < total_items; i++) {
	        var item_x = shop_x + 20 + spacing + (i * (item_w + spacing));
	        var item_y = shop_y + 80;
        
	        if (point_in_rectangle(mouse_gui_x, mouse_gui_y, item_x, item_y, item_x + item_w, item_y + item_h)) {
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
	    var cost = 50; 
    
	    if (player_gold >= cost) {
	        player_gold -= cost;
        
	        var item_type = shop_selected_items[item_id];
        
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
	        }
        
	        close_shop();
	    }
	}
		
	function get_item_description(item_type) {
	    switch(item_type) {
	        case "speed": return "Increases player speed";
	        case "shield": return "Grants 1 shield";
	        case "size": return "Temporarily increases player size";
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
    	    
	    shield_max = 9.0;  
	    shield_current = 3.0; 
	    shield_parts_falling = array_create(0);
	}

	init_health();

	function damage_planet(damage_amount) {
	    if (game_over) return;
    
	    var damage_to_apply = 1; 
    	    
	    if (shield_current > 0) {	        
	        shield_current -= damage_to_apply;
	        create_falling_shield_part();
        	        
	        if (shield_current < 0) {
	            var overflow_damage = abs(shield_current);
	            shield_current = 0;
            	            
	            planet_health -= overflow_damage;
	            planet_health = max(0, planet_health);
	            create_falling_heart_part();
	        }
	    } else {	        
	        planet_health -= damage_to_apply;
	        planet_health = max(0, planet_health);
	        create_falling_heart_part();
	    }
    
	    if (planet_health <= 0) {
	        trigger_game_over();
	    }
	}
		
	function draw_planet_hearts() {
	    var start_x = 20;
	    var start_y = display_get_gui_height() - 60;
	    var heart_part_width = sprite_get_width(spr_left_heart);
	    var full_heart_width = heart_part_width * 3;
	    var heart_spacing = 20;
    
	    // Draw hearts for each of the 3 heart positions
	    for (var i = 0; i < 3; i++) {
	        var heart_x = start_x + (i * (full_heart_width + heart_spacing));
        
	        // Draw heart parts based on current health
	        var parts_for_this_heart = max(0, min(3, planet_health - (i * 3)));
        
	        if (parts_for_this_heart >= 1 && !is_part_falling(i, 0)) {
	            draw_heart_part(heart_x, start_y, "left");
	        }
	        if (parts_for_this_heart >= 2 && !is_part_falling(i, 1)) {
	            draw_heart_part(heart_x + heart_part_width, start_y, "mid");
	        }
	        if (parts_for_this_heart >= 3 && !is_part_falling(i, 2)) {
	            draw_heart_part(heart_x + (heart_part_width * 2), start_y, "right");
	        }
        
	        // Draw shield parts on any heart that has shields
	        var shield_parts_for_heart = max(0, min(3, shield_current - (i * 3)));
        
	        if (shield_parts_for_heart > 0) {
	            var heart_mid_x = heart_x + heart_part_width;
	            var shield_part_width = sprite_get_width(spr_mid_shield);
            
	            if (shield_parts_for_heart >= 1 && !is_shield_part_falling(i, 0)) {
	                draw_shield_part(heart_mid_x - shield_part_width, start_y, "left");
	            }
	            if (shield_parts_for_heart >= 2 && !is_shield_part_falling(i, 1)) {
	                draw_shield_part(heart_mid_x, start_y, "mid");
	            }
	            if (shield_parts_for_heart >= 3 && !is_shield_part_falling(i, 2)) {
	                draw_shield_part(heart_mid_x + shield_part_width, start_y, "right");
	            }
	        }
	    }
    
	    // Draw falling heart parts
	    for (var i = 0; i < array_length(heart_parts_falling); i++) {
	        var part = heart_parts_falling[i];
	        var heart_x = start_x + (part.heart_index * (full_heart_width + heart_spacing));
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
    
	    // Draw falling shield parts
	    for (var i = 0; i < array_length(shield_parts_falling); i++) {
	        var part = shield_parts_falling[i];
	        var heart_x = start_x + (part.heart_index * (full_heart_width + heart_spacing));
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
	    var total_parts_remaining = planet_health;
    
	    // Find which heart and part to remove
	    var heart_index, part_index;
    
	    if (total_parts_remaining >= 6) {
	        // Heart 2 (rightmost) has parts to lose
	        heart_index = 2;
	        if (total_parts_remaining == 8) part_index = 2; 
	        else if (total_parts_remaining == 7) part_index = 1; 
	        else part_index = 0; 
	    } else if (total_parts_remaining >= 3) {
	        // Heart 1 (middle) has parts to lose
	        heart_index = 1;
	        if (total_parts_remaining == 5) part_index = 2; 
	        else if (total_parts_remaining == 4) part_index = 1; 
	        else part_index = 0; 
	    } else {
	        // Heart 0 (leftmost) has parts to lose
	        heart_index = 0;
	        if (total_parts_remaining == 2) part_index = 2; 
	        else if (total_parts_remaining == 1) part_index = 1; 
	        else part_index = 0; 
	    }
    
	    var part_data = {
	        heart_index: heart_index,
	        part_index: part_index,
	        y_pos: display_get_gui_height() - 60,
	        alpha: 1.0,
	        timer: 0,
	        fall_duration: game_get_speed(gamespeed_fps) * 0.5
	    };
    
	    array_push(heart_parts_falling, part_data);
	}
		
	function create_falling_shield_part() {
	    var total_shield_remaining = shield_current;
    
	    // Find which heart and part to remove
	    var heart_index, part_index;
    
		// Heart 2 (rightmost) has shield parts to lose
	    if (total_shield_remaining >= 6) {	        
	        heart_index = 2;
	        if (total_shield_remaining == 8) part_index = 2; 
	        else if (total_shield_remaining == 7) part_index = 1; 
	        else part_index = 0; 
	    } else if (total_shield_remaining >= 3) {
	        // Heart 1 (middle) has shield parts to lose
	        heart_index = 1;
	        if (total_shield_remaining == 5) part_index = 2; 
	        else if (total_shield_remaining == 4) part_index = 1; 
	        else part_index = 0; 
	    } else {
	        // Heart 0 (leftmost) has shield parts to lose
	        heart_index = 0;
	        if (total_shield_remaining == 2) part_index = 2; 
	        else if (total_shield_remaining == 1) part_index = 1; 
	        else part_index = 0; 
	    }
    
	    var part_data = {
	        heart_index: heart_index,
	        part_index: part_index,
	        y_pos: display_get_gui_height() - 60,
	        alpha: 1.0,
	        timer: 0,
	        fall_duration: game_get_speed(gamespeed_fps) * 0.5
	    };
    
	    array_push(shield_parts_falling, part_data);
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
	}

#endregion

calculate_spawn_interval();