/// @description Create Event obj_enemy

// Target the Earth
earth_obj = instance_find(obj_earth, 0);
if (earth_obj != noone) {
    target_x = earth_obj.x;
    target_y = earth_obj.y;
} else {
    target_x = room_width / 2;
    target_y = room_height / 2;
}

// Movement properties
move_speed = 1 + random(2); // Speed between 1-3
direction_to_target = point_direction(x, y, target_x, target_y);

// Zigzag properties
use_zigzag = false;
zigzag_timer = 0;
zigzag_amplitude = 50; // How far to zigzag
zigzag_frequency = 0.1; // How fast to zigzag
original_direction = direction_to_target;

rotation_speed = random_range(-2, 2); 

scale_variation = random_range(-30, 30); 
base_size = sprite_width; 
new_scale = (base_size + scale_variation) / base_size; 
image_xscale = new_scale;
image_yscale = new_scale; 

// Health/collision
hp = 1;
gold_value = 5;

// Visual
image_angle = direction_to_target;