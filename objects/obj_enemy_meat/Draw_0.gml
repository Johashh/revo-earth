/// @description Draw Event obj_enemy

draw_self();

// Debug info (optional - remove in final version)
if (keyboard_check(ord("F1"))) {
    draw_set_color(c_white);
    draw_set_font(-1);
    
    var debug_text = "Speed: " + string(move_speed) + 
                    "\nZigzag: " + (use_zigzag ? "Yes" : "No") +
                    "\nDistance: " + string(round(point_distance(x, y, target_x, target_y)));
    
    draw_text(x + 20, y - 30, debug_text);
}

// Optional: Draw line to Earth for debugging
if (keyboard_check(ord("F2"))) {
    draw_set_color(c_red);
    draw_line(x, y, target_x, target_y);
}