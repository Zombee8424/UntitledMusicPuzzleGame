extends AudioStreamPlayer


var note_timer: Timer;
var volume_control: AnimationPlayer;


func init(synth_wave: AudioStreamMP3, note_pitch_scale: float, note_length: float) -> void:
	note_timer = get_node("NoteTimer");
	volume_control = get_node("VolumeControl");
	
	stream = synth_wave;
	
	pitch_scale = note_pitch_scale;
	volume_control.play("Start");
	
	note_timer.start(note_length);
	assert(note_timer.connect("timeout", self, "trigger_stop") == OK);


func trigger_stop() -> void:
	volume_control.play("Stop");
	yield (volume_control, "animation_finished");
	queue_free();