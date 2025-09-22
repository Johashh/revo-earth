/// @description Step Event obj_shockwave

if (!global.game_started) {
    exit;
}

timer++;

image_xscale += expansion_speed;
image_yscale += expansion_speed;
image_angle += rotation_speed;

var current_radius = (image_xscale * sprite_get_width(spr_shockwave)) / 2;

with (obj_enemy_meat) {
    var distance_to_wave = point_distance(x, y, other.x, other.y);
    
    if (distance_to_wave <= current_radius) {
        var already_hit = false;
        
        for (var i = 0; i < array_length(other.hit_enemies); i++) {
            if (other.hit_enemies[i] == id) {
                already_hit = true;
                break;
            }
        }
        
        if (!already_hit) {
            array_push(other.hit_enemies, id);
            
            with(obj_controller_general) {
                player_gold += other.gold_value;
            }
            
            instance_destroy();
        }
    }
}

if (timer >= animation_duration || image_index >= animation_frames - 1) {
    instance_destroy();
}