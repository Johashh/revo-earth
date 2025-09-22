/// @description Create Event obj_shockwave

sprite_index = spr_shockwave;
image_speed = 1;
image_loop = false;

audio_play_sound(snd_shockwave, 1, false);

image_xscale = 0.3; 
image_yscale = 0.3;

var earth_obj = instance_find(obj_earth, 0);
if (earth_obj != noone) {
    x = earth_obj.x;
    y = earth_obj.y;
}

animation_frames = 5;
animation_duration = animation_frames / 8 * game_get_speed(gamespeed_fps);
expansion_speed = (8.0 - 0.3) / animation_duration;
max_scale = 8.0;

rotation_speed = 2;
image_angle = 0;
timer = 0;

hit_enemies = [];