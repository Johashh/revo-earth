/// @description Step Event obj_enemy

if (!global.game_started) {
    exit;
}

// Update target position (in case Earth moves)
earth_obj = instance_find(obj_earth, 0);
if (earth_obj != noone) {
    target_x = earth_obj.x;
    target_y = earth_obj.y;
}

var base_direction = point_direction(x, y, target_x, target_y);

// Apply zigzag movement if enabled
var final_direction = base_direction;
if (use_zigzag) {
    zigzag_timer += zigzag_frequency;
    var zigzag_offset = sin(zigzag_timer) * zigzag_amplitude;
    
    // Add perpendicular zigzag to the base direction
    final_direction = base_direction + zigzag_offset;
}

var move_x = lengthdir_x(move_speed, final_direction);
var move_y = lengthdir_y(move_speed, final_direction);

x += move_x;
y += move_y;

// Rotate sprite to face movement direction
image_angle += rotation_speed;

// Check collision with player
var player_obj = instance_find(obj_player, 0);
if (player_obj != noone) {
    if (distance_to_object(player_obj) < 20) {        
        player_obj.start_eating();
        
        with(obj_controller_general) {
            player_gold += other.gold_value;
        }
                
        instance_destroy(); 
        exit;
    }
}

// Check collision with Earth (damage Earth)
if (distance_to_point(target_x, target_y) < 80) { 	
    with(obj_controller_general) {
        damage_planet(1); // 1/3 damage
    }
        
    instance_destroy();
    exit;
}

// Remove if too far off-screen
if (x < -100 || x > room_width + 100 || y < -100 || y > room_height + 100) {
    // Only destroy if moving away from Earth
    var distance_to_earth = point_distance(x, y, target_x, target_y);
    var previous_x = x - move_x;
    var previous_y = y - move_y;
    var previous_distance = point_distance(previous_x, previous_y, target_x, target_y);
    
    if (distance_to_earth > previous_distance) {
        instance_destroy();
    }
}