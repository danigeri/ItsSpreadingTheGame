extends Node2D

@onready var skin_sound_player = $SkinSoundPlayer
@onready var intro_sound_player = $IntroSoundPlayer
@onready var truck_sound_player = $TruckSoundPlayer

# skins
var adam_skin_sound = preload("res://sfx_scene/skin_sounds/adam_s.mp3")
var anoobis_skin_sound = preload("res://sfx_scene/skin_sounds/anoobis.mp3")
var berlin_skin_sound = preload("res://sfx_scene/skin_sounds/berlin.mp3")
var chonny_jage_skin_sound = preload("res://sfx_scene/skin_sounds/chonny_jage.mp3")
var dragon_trunk_skin_sound = preload("res://sfx_scene/skin_sounds/dragon_trunks.mp3")
var jeans_skin_sound = preload("res://sfx_scene/skin_sounds/jeans.mp3")
var judo_skin_sound = preload("res://sfx_scene/skin_sounds/judo.mp3")
var kingpgin_skin_sound = preload("res://sfx_scene/skin_sounds/kingpin.mp3")
var volvo_skin_sound = preload("res://sfx_scene/skin_sounds/volvo.mp3")

func play_skin_sound(skin_id):
	
	if skin_id == 0:
		skin_sound_player.stream = jeans_skin_sound
	elif skin_id == 1:
		skin_sound_player.stream = adam_skin_sound
	elif skin_id == 2:
		skin_sound_player.stream = dragon_trunk_skin_sound
	elif skin_id == 3:
		skin_sound_player.stream = judo_skin_sound
	elif skin_id == 4:
		skin_sound_player.stream = volvo_skin_sound
	elif skin_id == 5:
		skin_sound_player.stream = berlin_skin_sound
	elif skin_id == 6:
		skin_sound_player.stream = kingpgin_skin_sound
	elif skin_id == 7:
		skin_sound_player.stream = anoobis_skin_sound
	elif skin_id == 8:
		skin_sound_player.stream = chonny_jage_skin_sound
	
	skin_sound_player.play()
	
var jcvd_intro_sound = preload("res://sfx_scene/jcvd_intro.mp3")

func play_jcvd_intro_sound():
	jcvd_intro_sound.stream = jcvd_intro_sound
	intro_sound_player.play()

var truck_sound = preload("res://sfx_scene/truck.mp3")

func play_truck_sound():
	truck_sound_player.stream = truck_sound
	truck_sound_player.play()

