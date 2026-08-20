extends Node

enum Song {
	NONE,
	SONG_01
}

enum Effect {
	NONE,
	SELECT,
	DESELECT
}

@onready var _songs:Node   = $Songs
@onready var _effects:Node = $Effects

var _song_volumes:Dictionary[Song, float] = {}
var _current_song:Song = Song.NONE

func _ready() -> void:
	for song:Song in Song.values():
		if song not in _song_volumes:
			_song_volumes[song] = _songs.get_child(song).volume_db

func _fade_out(which:Song, target_volume:float) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(_songs.get_child(which), "volume_db", target_volume, .5)
	tween.tween_callback( _stop.bind(which) )

func _fade_in(song:Song) -> void:
	_songs.get_child(song).play()
	var tween:Tween = create_tween()
	tween.tween_property(_songs.get_child(song), "volume_db", _song_volumes[song], .5)

func _stop(song:Song) -> void:
	_songs.get_child(song).stop()

func play_song(which:Song) -> void:
	if which == _current_song:
		return
		
	for song:Song in Song.values():
		if song != which:
			_fade_out(song, -80)
	
	_fade_in(which)

func play_effect(which:Effect) -> void:
	_effects.get_child(which).play(which)
