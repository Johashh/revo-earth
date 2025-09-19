/// @description Step Event obj_moon

if (!global.game_started) {
    exit; 
}

earth_obj = instance_find(obj_earth, 0);

if (earth_obj != noone) {
    earth_x = earth_obj.x;
    earth_y = earth_obj.y;
}

if (is_moving) {    
    var current_direction = orbital_direction;
        
    if (global.moon_direction_override != 0) {
        current_direction = global.moon_direction_override;
    }
    
    var current_speed = orbital_speed * global.moon_speed_multiplier * current_direction;

    orbit_angle += current_speed;
    
    if (orbit_angle >= 360) {
        orbit_angle -= 360;
    } else if (orbit_angle < 0) {
        orbit_angle += 360;
    }
    
    x = earth_x + lengthdir_x(orbit_radius, orbit_angle);
    y = earth_y + lengthdir_y(orbit_radius, orbit_angle);
    
    image_angle += current_speed * 0.5;
}

if (keyboard_check_pressed(ord("T"))) {
    is_moving = !is_moving;
}