extends AudioStreamPlayer

@export var sfx : bool = false
@export var volume_boost : float = 0

func _ready() -> void:
    volume_update()
    MainData.settings_changed.connect(settings_updated)

func volume_update() -> void:
    if sfx:
        volume_linear = MainData.sfx_volume / 20 + volume_boost
    else:
        volume_linear = MainData.music_volume / 2 + volume_boost

func settings_updated() -> void:
    volume_update()
