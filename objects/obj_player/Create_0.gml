/// @description Create Event obj_player

animation_timer = 0;

last_direction = 1;

earth_obj = instance_find(obj_earth, 0);
if (earth_obj != noone) {
    earth_x = earth_obj.x;
    earth_y = earth_obj.y;
} else {
    earth_x = room_width / 2;
    earth_y = room_height / 2;
}

orbit_radius = 0; 
orbit_angle = 90;
orbital_speed = 2.0;
is_moving = false;
depth = -2000;

// Size upgrade system
size_upgrade_active = false;
size_upgrade_timer = 0;
size_upgrade_duration = 15 * game_get_speed(gamespeed_fps); // 15 seconds
base_scale = 1.0;
upgraded_scale = 1.5; // 50% larger
current_scale = base_scale;