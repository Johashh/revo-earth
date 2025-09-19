/// @description Create Event obj_moon
draw_self();

// debug
if (keyboard_check(ord("F1"))) {
    draw_set_color(c_white);
    draw_set_font(-1);
    
    var debug_text = "Moon " + string(moon_id) + 
                    "\nSpeed: " + string(orbital_speed * global.moon_speed_multiplier) +
                    "\nDirection: " + (orbital_direction == 1 ? "Counterclockwise" : "Clockwise") +
                    "\nAngle: " + string(round(orbit_angle)) + "°" +
                    "\nRadius: " + string(round(orbit_radius));
    
    draw_text(x + 40, y - 40, debug_text);
}