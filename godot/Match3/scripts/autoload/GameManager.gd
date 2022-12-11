extends Node

enum STATE {main_menu, choose_team, core_loop, enemy_dead, battle_finished, player_turn}

var current_state;

var heroes = [preload("res://scenes/Anthrazit.tscn")]
