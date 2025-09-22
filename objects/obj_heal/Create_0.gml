/// @description Create Event obj_heal

sprite_index = spr_heal;
image_speed = 0;

earth_obj = instance_find(obj_earth, 0);
if (earth_obj != noone) {
    target_x = earth_obj.x;
    target_y = earth_obj.y;
} else {
    target_x = room_width / 2;
    target_y = room_height / 2;
}

move_speed = 1.5;
gold_value = 25;
heal_value = 1;

direction = point_direction(x, y, target_x, target_y);