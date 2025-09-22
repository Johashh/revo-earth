/// @description Destroy Event obj_enemy

audio_play_sound(snd_enemy_death, 1, false);

with(obj_controller_general) {
    for (var i = 0; i < array_length(enemies_list); i++) {
        if (enemies_list[i] == other) {
            array_delete(enemies_list, i, 1);
            break;
        }
    }
}