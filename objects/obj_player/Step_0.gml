/// @description Step Event obj_player

if (!global.game_started) {
    exit; 
}

// Handle eating animation
if (is_eating) {
    eating_timer += eating_frame_speed;
    
    if (eating_timer >= 1) {
        eating_timer = 0;
        image_index++;
        
        if (image_index >= 5) {             
            is_eating = false;
            image_index = 0;
                        
            if (is_moving) {
                sprite_index = spr_player;
            } else {
                sprite_index = spr_idle;
            }
        }
    }
    
    // Stop movement during eating
    return;
}

// Handle size upgrade timer
if (size_upgrade_active) {
    size_upgrade_timer--;
    
    if (size_upgrade_timer <= 0) {
        size_upgrade_active = false;
        current_scale = base_scale;
    }
}

// Apply current scale to sprite
image_xscale = current_scale;
image_yscale = current_scale;

// Update Earth position (if it moves)
earth_obj = instance_find(obj_earth, 0);
if (earth_obj != noone) {
    earth_x = earth_obj.x;
    earth_y = earth_obj.y;
}

var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));

var was_moving = is_moving;

if (key_left) {
    // Counter-clockwise movement
    orbit_angle += orbital_speed;
    is_moving = true;
    last_direction = 1; 
} else if (key_right) {
    // Clockwise movement
    orbit_angle -= orbital_speed;
    is_moving = true;
    last_direction = -1; 
} else {
    is_moving = false;
}

if (orbit_angle >= 360) {
    orbit_angle -= 360;
} else if (orbit_angle < 0) {
    orbit_angle += 360;
}

// Update position on Earth surface
x = earth_x + lengthdir_x(orbit_radius, orbit_angle);
y = earth_y + lengthdir_y(orbit_radius, orbit_angle);

if (is_moving) {    
    if (sprite_index != spr_player) {
        sprite_index = spr_player;
        image_index = 0; 
    }
    
    animation_timer += 0.2; 
    
    if (animation_timer >= 1) {
        animation_timer = 0;
        image_index++;
                
        if (image_index >= image_number) {
            image_index = 0;
        }
    }
        
    image_angle = orbit_angle - 90;
    if (key_left) {        
        image_xscale = current_scale;
    } else if (key_right) {        
        image_xscale = -current_scale;
    }
} else {
    if (sprite_index != spr_idle) {
        sprite_index = spr_idle;
        image_index = 0; 
    }
    
    // Idle
    animation_timer += 0.1; 
    
    if (animation_timer >= 1) {
        animation_timer = 0;
        image_index++;
                
        if (image_index >= image_number) {
            image_index = 0;
        }
    }
        
    image_xscale = current_scale * last_direction;
    image_angle = orbit_angle - 90;
}