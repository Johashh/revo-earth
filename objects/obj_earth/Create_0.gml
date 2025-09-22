/// @description Create Event obj_earth

is_infected = false;

function update_earth_sprite() {
    var controller = instance_find(obj_controller_general, 0);
    if (controller == noone) return;
    
    var hp = controller.planet_health;
    
    if (hp >= 9) {
        sprite_index = spr_earth; 
        image_index = 0;
    } else {
        sprite_index = spr_earth_infected; 
        is_infected = true;
        
        if (hp >= 6) {
            image_index = 0; 
        } else if (hp >= 3) {
            image_index = 1; 
        } else {
            image_index = 2; 
        }
    }
}