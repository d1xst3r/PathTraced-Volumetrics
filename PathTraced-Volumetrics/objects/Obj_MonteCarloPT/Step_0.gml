occluder_size += (mouse_wheel_up() - mouse_wheel_down()) * 8;
occluder_size = clamp(occluder_size, 8, 128);