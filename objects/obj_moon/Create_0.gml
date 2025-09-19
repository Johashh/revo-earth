/// @description Create Event obj_moon

earth_obj = instance_find(obj_earth, 0);
if (earth_obj != noone) {
    earth_x = earth_obj.x;
    earth_y = earth_obj.y;
} 

//orbit_radius = point_distance(x, y, earth_x, earth_y);
//orbit_angle = point_direction(earth_x, earth_y, x, y);

orbital_speed = 1.0;
orbital_direction = 1;
is_moving = false; // Start stopped until game begins

moon_id = instance_number(obj_moon);