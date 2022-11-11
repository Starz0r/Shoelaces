#macro range __iterator


function __iterator(container, func, caller=undefined) {
	var idx = 0;
	var working = true;
	if (is_string(container)) {
		var len = string_length(container);
		while ((working) and (idx != len)) {
			var value = string_char_at(container, idx);
			working = func(value, idx++, container) ?? true ? true : false;
		}
	} else if (is_array(container)) {
		var len = array_length(container);
		while ((working) and (idx != len)) {
			var value = array_get(container, idx);
			working = func(value, idx++, container) ?? true ? true : false;
		}
	} else if (ds_exists(container, ds_type_list)) {
		var len = ds_list_size(container);
		while ((working) and (idx != len)) {
			var value = ds_list_find_value(container, idx);
			working = func(value, idx++, container)?? true ? true : false;
		}
	} else if (ds_exists(container, ds_type_map)) {
		var len = ds_map_size(container);
		var key = ds_map_find_first(container);
		if (key == undefined) or (len == 0) {
			return;
		}
		while ((working) and (idx != len)) {
			var value = ds_map_find_value(container, key);
			working = func(value, key, container) ?? true ? true : false;
			key = ds_map_find_next(container, key);
			if (key == undefined) {
				break;
			}
			++idx;
		}
	} else if (ds_exists(container, ds_type_stack)) {
		var len = ds_stack_size(container);
		var tmp = ds_stack_create(); // keep a temporary stack to put displaced elements
		while ((working) and (idx != len)) {
			var value = ds_stack_pop(container);
			working = func(value, len - idx, container) ?? true ? true : false;
			ds_stack_push(tmp, value);
			++idx;
		}
		
		// push all the displaced elements back onto the main stack
		while (ds_stack_size(tmp) != 0) {
			ds_stack_push(container, ds_stack_pop(tmp));
		}
		ds_stack_destroy(tmp);
	} else if (ds_exists(container, ds_type_queue)) {
		var len = ds_queue_size(container);
		var tmp = ds_queue_create(); // keep a temporary queue for displaced elements
		while ((working) and (idx != len)) {
			var value = ds_queue_dequeue(container);
			working = func(value, idx, container) ?? true ? true : false;
			ds_queue_enqueue(tmp, value);
			++idx;
		}
		
		// move all displaced elements onto the temporary queue
		while (ds_queue_size(container) != 0) {
			ds_queue_enqueue(tmp, ds_queue_dequeue(container));
		}
		// then move them all back
		while (ds_queue_size(tmp) != 0) {
			ds_queue_enqueue(container, ds_queue_dequeue(tmp));
		}
		ds_queue_destroy(tmp);
	} else if (ds_exists(container, ds_type_grid)) {
		var width = ds_grid_width(container);
		var height = ds_grid_height(container);
		var len = width + height;
		while ((working) and (idx != len)) {
			for (var i = 0; i < width; ++i) {
				for (var j = 0; j < height; ++j) {
					var v2idx = new Vec2(i, j);
					var value = ds_grid_get(container, i, j);
					working = func(value, v2idx, container) ?? true ? true : false;
					if not (working) {
						break;
					}
					++idx;
				}
				if not (working) {
					break;
				}
			}
			if not (working) {
				break;
			}
		}
	} else if (ds_exists(container, ds_type_priority)) {
		/*
		var len = ds_priority_size(container);
		var tmp = ds_priority_create();
		var lower = ds_priority_find_min(container);
		var upper = ds_priority_find_max(container);*/
		// we need ds_priority_delete_priority for this to work :(
		throw {
			message: "unimplemented iterator",
			longMessage: "DS Priority Queues are not supported with iterators, and do not have a defined iterator implementation.",
			stacktrace: debug_get_callstack(),
			script: "Iterators",
		}
	} else if (is_struct(container)) {
		var len = variable_struct_names_count(container);
		var keys = variable_struct_get_names(container);
		while ((working) and (idx != len)) {
			var key = keys[idx++];
			var value = variable_struct_get(container, key);
			working = func(value, key, container) ?? true ? true : false;
		}
	}
}