earth_obj = instance_create_layer(room_width/2, room_height/2, "Instances", obj_earth);

var earth_x = room_width/2;
var earth_y = room_height/2;

// Create player on Earth surface
var earth_half_height = sprite_get_height(spr_earth) / 2;
var player_half_height = sprite_get_height(spr_player) / 2;
var surface_distance = earth_half_height + player_half_height;
var player_obj = instance_create_layer(earth_x, earth_y - surface_distance, "Instances", obj_player);
player_obj.orbit_radius = surface_distance;
//player_obj.image_yscale = -1;

//player_obj.orbit_angle = 0; 

// Calculate distance: half earth height + half moon height + 40px gap
//var earth_half_height = sprite_get_height(spr_earth) / 2; // 75px
//var moon_half_height = sprite_get_height(spr_moon) / 2;   // 37.5px
//var gap = 40;
//var orbit_distance = earth_half_height + moon_half_height + gap; // 152.5px

//// Create moon 1 (above earth)
//var moon1 = instance_create_layer(earth_x, earth_y - orbit_distance, "Instances", obj_moon);
//moon1.orbit_radius = orbit_distance;
//moon1.orbit_angle = 270; // Top position

//// Create moon 2 (below earth)
//var moon2 = instance_create_layer(earth_x, earth_y + orbit_distance, "Instances", obj_moon);
//moon2.orbit_radius = orbit_distance;
//moon2.orbit_angle = 90; // Bottom position

with(obj_controller_general){
    //array_push(moon_objs, moon1);
    //array_push(moon_objs, moon2);    
    objects_created = true;
}



//with(obj_controller_general){
//     player_obj = player_obj; // se quiser referência no controlador
//}