shader_type canvas_item;

uniform bool active = false;
uniform bool is_hurt = true;

void fragment(){
	vec4 previous_colour = texture(TEXTURE, UV);
	vec4 flash_colour = vec4(1.0, 1.0, 1.0, previous_colour.a);
	if (is_hurt == false){
		flash_colour = vec4(0.0, 1.0, 0.0, previous_colour.a)
	}
	
	vec4 new_colour = previous_colour;
	
	if(active == true){
		new_colour = flash_colour;
		
	}
	
	COLOR = new_colour;
	
}