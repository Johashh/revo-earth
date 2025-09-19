/// @description Draw Event obj_controller_general

// Draw blue circle above earth
if (instance_exists(obj_controller_general) && obj_controller_general.shield_current > 0) {
    var earth_obj = instance_find(obj_earth, 0);
    if (earth_obj != noone) {
        draw_set_alpha(0.3); 
        draw_set_color(c_aqua); 
        draw_circle(earth_obj.x, earth_obj.y, 120, false); 
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
}