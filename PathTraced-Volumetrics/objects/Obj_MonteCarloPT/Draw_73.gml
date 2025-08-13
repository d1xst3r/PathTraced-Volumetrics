var gpu_blend = gpu_get_blendenable();
var gpu_texrepeat = gpu_get_tex_repeat();
var gpu_filter = gpu_get_tex_filter();

gpu_set_blendenable(false);
gpu_set_texrepeat(false);
gpu_set_tex_filter(false);

		shader_set(montecarlopt_u_Shader);
		shader_texture(montecarlopt_u_Emissivity, surface_source(render_emissivity));
		shader_texture(montecarlopt_u_Absorption, surface_source(render_absorption));
		texture_set_stage(montecarlopt_u_BlueNoise, sprite_get_texture(Spr_BlueNoise, 0));
		shader_vec2(montecarlopt_u_WorldExtent, render_size, render_size);
		shader_float(montecarlopt_u_RayCount, render_rays);
			surface_set_target(surface_source(render_fluence));
			draw_clear_alpha(c_black, 0);
				draw_sprite_stretched(Spr_SurfaceTexture, 0, 0, 0, render_size, render_size);
			surface_reset_target();
		shader_reset();

gpu_set_blendenable(gpu_blend);
gpu_set_texrepeat(gpu_texrepeat);
gpu_set_tex_filter(gpu_filter);

draw_surface_ext(surface_source(render_fluence), 0, 0, view_wport[0]/render_size, view_hport[0]/render_size, 0, c_white, 1);
//draw_surface_ext(surface_source(render_emissivity), 0, 0, 4, 4, 0, c_white, 1);
//draw_surface_ext(surface_source(render_absorption), 0, 0, 4, 4, 0, c_white, 1);

draw_set_font(Spr_PixelFont);
draw_set_color(c_yellow);
draw_text(5,  5, "Frame Time:   " + string(delta_time / 1000) + " / " + string(1000 * (1.0/game_get_speed(gamespeed_fps))));
draw_set_color(c_yellow);
draw_rectangle(1, 1, 1022, 1022, true);
draw_set_color(c_white);