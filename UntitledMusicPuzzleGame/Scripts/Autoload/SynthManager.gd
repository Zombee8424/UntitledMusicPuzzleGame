extends Node


func get_synth(synth_name: String = "DefaultSynth") -> Node:
	var synth = get_tree().current_scene.get_node(synth_name);
	assert(synth != null, "Synth '" + synth_name + "' not found");
	return synth;
