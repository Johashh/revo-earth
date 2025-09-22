/// @description Room Start Event obj_controller_general

load_scores_from_file();

if (room == rm_game) {
    is_in_game_room = true;
        
    if (should_restart_game) {
        init_game(); 
        init_spawn();
        init_health();
        calculate_spawn_interval();
        should_restart_game = false; 
    }
} else {
    is_in_game_room = false;
}


