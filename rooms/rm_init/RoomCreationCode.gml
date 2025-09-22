if(!instance_exists(obj_controller_general)) instance_create_layer(0, 0, "Instances", obj_controller_general);

initialize_all_globals();
room_goto(rm_main_menu);