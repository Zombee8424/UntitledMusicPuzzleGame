class_name Synth
extends Node2D


const mid_octave_freq: Dictionary = {
	"C" : 261.63,
	"C#" : 277.18,
	"D" : 293.66,
	"D#" : 311.13,
	"E" : 329.63,
	"F" : 349.23,
	"F#" : 369.99,
	"G" : 392.00,
	"G#" : 415.30,
	"A" : 440.00,
	"A#" : 466.16,
	"B" : 493.88,
}

export var synth_wave: AudioStreamMP3;
export(String, FILE) var synth_note_path: String;


func play_note(note_name: String, note_octave: int, note_length: float) -> void:
	var note_pitch_scale = (mid_octave_freq[note_name] * pow(2, note_octave-4)) / mid_octave_freq["C"];
	var synth_note = load(synth_note_path).instance();
	add_child(synth_note, true);
	synth_note.init(synth_wave, note_pitch_scale, note_length);