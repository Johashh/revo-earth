/// @description Step Event obj_heal

if (!global.game_started) {
    exit;
}

if (instance_exists(obj_earth)) {
    target_x = obj_earth.x;
    target_y = obj_earth.y;
}

direction = point_direction(x, y, target_x, target_y);

x += lengthdir_x(move_speed, direction);
y += lengthdir_y(move_speed, direction);

with (obj_player) {
    if (place_meeting(x, y, other)) {
        start_eating();
        
        var heal_item = other; // Save reference to heal item
        
        with(obj_controller_general) {                        
            // Heal player based on heal_up level
            var heal_amount = heal_item.heal_value + heal_up_level;
            planet_health = min(planet_health + heal_amount, planet_max_health);
        }
        
        instance_destroy(other);
    }
}

if (place_meeting(x, y, obj_earth)) {
    with(obj_controller_general) {
        damage_planet(3);
    }
    instance_destroy();
}