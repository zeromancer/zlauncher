/*
    ZLauncher - a customisable menu like launcher
    Copyright (C) 2013 David Siewert

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
public class  ZLauncher_entry_actions: GLib.Object {

	// Actions
	public delegate void ZEntry_action(ZLauncher_entry entry);
	public ZEntry_action action_cmd;
	public ZEntry_action action_config;
	public ZEntry_action action_options;
	public ZEntry_action action_help;
	public ZEntry_action action_duplicate;
	public ZEntry_action action_remove;
	public ZEntry_action action_remove_icon;
	public ZEntry_action action_theme_up;
	public ZEntry_action action_theme_down;
	public ZEntry_action action_move_up;
	public ZEntry_action action_move_down;
	public ZEntry_action action_move_left;
	public ZEntry_action action_move_right;
	public ZEntry_action action_copy_up;
	public ZEntry_action action_copy_down;
	public ZEntry_action action_copy_left;
	public ZEntry_action action_copy_right;
	
	public ZLauncher_entry_actions(){}

	public void initialize_actions(ZLauncher_entry entry){

		// General
		action_cmd = (entry) => { cmd(entry); };
		action_config = (entry) => { edit(entry); };
		action_help = (entry) => { print("TODO\n"); };
		action_options = (entry) => { entry.launcher.options_config.window.show_all(); };
		action_duplicate = (entry) => { copy(entry,0,1); };
		action_remove = (entry) => { remove(entry); };
		action_remove_icon = (entry) => { remove_icon(entry); };
		action_theme_up = (entry) => { theme_up(entry); };
		action_theme_down = (entry) => { theme_down(entry); };
		action_move_down = (entry) => { move(entry,0,1); };
		action_move_up = (entry) => { move(entry,0,-1); };
		action_move_left = (entry) => { move(entry,-1,0); };
		action_move_right = (entry) => { move(entry,1,0); };
		action_copy_down = (entry) => { copy(entry,0,1); };
		action_copy_up = (entry) => { copy(entry,0,-1); };
		action_copy_left = (entry) => { copy(entry,-1,0); };
		action_copy_right = (entry) => { copy(entry,1,0); };

		// Mouse
		entry.add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
		
		if(entry.image != null)
		entry.button_press_event.connect ((event) => {
			// Left Click
			if (event.button == 1 && event.type == Gdk.EventType.BUTTON_PRESS) { // left click
				action_cmd(entry);
			// Right Click
			} else if (event.button == 3 && event.type == Gdk.EventType.BUTTON_PRESS) { // right click
				action_config(entry);
			}
			return true;
    });
    
		//entry.add_events (Gdk.EventMask.BUTTON_RELEASE_MASK);
    //entry.button_release_event.connect((event) => {
		//	print("button release\n");
		//	return true;
		//});
    
    entry.enter_notify_event.connect((event) =>	{
			entry.grab_focus();
			return true;
		});

		// Keyboard
		entry.key_press_event.connect ((event) => {
			int key = (int)event.keyval;
			
			if( key== 32 || key == 65293) // SPACE or ENTER
				action_cmd(entry);
				
			else if( key == 65307) // ESCAPE
				Gtk.main_quit();
			else if (event.str == "q")
				Gtk.main_quit();
			else if (event.str == "r")
				action_remove(entry);
				
			else if (event.str == "e")
				action_config(entry);
			else if (event.str == "o")
				action_options(entry);
			else if (event.str == "+")
				action_theme_up(entry);
			else if (event.str == "-")
				action_theme_down(entry);
			else if (event.str == "c")
				action_duplicate(entry);
			else if (event.str == "i")
				action_remove_icon(entry);
				
			else if (event.str == "a")
				action_move_left(entry);
			else if (event.str == "w")
				action_move_up(entry);
			else if (event.str == "s")
				action_move_down(entry);
			else if (event.str == "d")
				action_move_right(entry);
				
			else if (event.str == "A")
				action_copy_left(entry);
			else if (event.str == "W")
				action_copy_up(entry);
			else if (event.str == "S")
				action_copy_down(entry);
			else if (event.str == "D")
				action_copy_right(entry);
				
//~ 			else if( key == 65361) // Left
//~ 				entry.launcher.focus(Gtk.DirectionType.LEFT);
//~ 			else if( key == 65362) // Up
//~ 				entry.launcher.focus(Gtk.DirectionType.UP);
//~ 			else if( key == 65363) // Right
//~ 				entry.launcher.focus(Gtk.DirectionType.RIGHT);
//~ 			else if( key == 65364) // Down
//~ 				entry.launcher.focus(Gtk.DirectionType.DOWN);

			//else
			//	print("[%d,%d] key: %d = %s\n",entry.grid_x,entry.grid_y,key,event.str);
			return false;
		});

		entry.focus_in_event.connect ((event) => {
			Gdk.RGBA color = {1,1,0.1,1};
			ZLauncher_options_entry theme = entry.options.entries.get(entry.entry_theme);
			color.parse(theme.selected_background_color);
			entry.override_background_color(Gtk.StateFlags.NORMAL,color);
			entry.label.override_background_color(Gtk.StateFlags.NORMAL,color);
			return true;
		});

		entry.focus_out_event.connect ((event) => {
			Gdk.RGBA color = {1,1,0.1,1};
			ZLauncher_options_entry theme = entry.options.entries.get(entry.entry_theme);
			color.parse(theme.icon_background_color);
			entry.override_background_color(Gtk.StateFlags.NORMAL,color);
			color.parse(theme.text_background_color);
			entry.label.override_background_color(Gtk.StateFlags.NORMAL,color);
			return true;
		});

	}




	public void cmd(ZLauncher_entry entry){
		if(entry.entry_command.length<3) return;
		
		try{
			GLib.Process.spawn_command_line_async("bash -c \""+entry.entry_command+"\"");
		}catch (Error e) {
			stderr.printf ("Error executing command: %s\n", entry.entry_command);
		}
			
		//Gtk.main_quit();
	}

	public void edit(ZLauncher_entry entry){
		entry.launcher.entry_config.show_configuration(entry);
		entry.grab_focus();
	}

	public void theme_up(ZLauncher_entry entry){
		int theme = entry.entry_theme;
		entry.set_entry_theme(++theme);
		entry.launcher.saving_content.save_default_content_config();
		entry.grab_focus();
	}
	
	public void theme_down(ZLauncher_entry entry){
		int theme = entry.entry_theme;
		entry.set_entry_theme(--theme);
		entry.launcher.saving_content.save_default_content_config();
		entry.grab_focus();
	}
	
	public void remove(ZLauncher_entry entry){
		ZLauncher launcher = entry.launcher;
		int x = entry.get_grid_x();
		int y = entry.get_grid_y()+1;
		launcher.grid.remove(entry);
		Gtk.Widget widget =  launcher.grid.get_child_at(x,y);
		while(widget != null){
			widget.grab_focus();
			launcher.grid.remove(widget);
			launcher.grid.attach(widget,x,y-1,1,1);
			((ZLauncher_entry)widget).set_grid_posittion(x,y-1);
			widget =  launcher.grid.get_child_at(x,++y);
		}
		launcher.saving_content.save_default_content_config();
	}
	
	public void remove_icon(ZLauncher_entry entry){
		entry.set_entry_icon("");
		//entry.image.clear();
		entry.launcher.saving_content.save_default_content_config();
		entry.grab_focus();
	}

	public void move(ZLauncher_entry entry, int delta_x, int delta_y){
		ZLauncher launcher = entry.launcher;
		int x = entry.get_grid_x();
		int y = entry.get_grid_y();
		int new_x = x+delta_x;
		int new_y = y+delta_y;
		Gtk.Widget widget = launcher.grid.get_child_at(new_x,new_y);
		//string new_widget = widget == null ? "null" : ((ZLauncher_entry)widget).to_string();
		//print("%d,%d -> %d,%d, %s\n",x,y,new_x,new_y,new_widget);
		if(new_x >=0 && new_y >=0 && widget != null && widget != entry){
			launcher.grid.remove(entry);
			launcher.grid.remove(widget);
			launcher.grid.attach(widget,x,y,1,1);
			launcher.grid.attach(entry,new_x,new_y,1,1);
			((ZLauncher_entry)widget).set_grid_posittion(x,y);
			((ZLauncher_entry)entry).set_grid_posittion(new_x,new_y);
		} else {
			launcher.grid.remove(entry);
			launcher.grid.attach(entry,new_x,new_y,1,1);
			((ZLauncher_entry)entry).set_grid_posittion(new_x,new_y);
		}
		launcher.saving_content.save_default_content_config();
		entry.grab_focus();
	}

	public void copy(ZLauncher_entry entry, int delta_x, int delta_y){
		ZLauncher launcher = entry.launcher;
		int x = entry.get_grid_x();
		int y = entry.get_grid_y();
		int ix = x+delta_x;
		int iy = y+delta_y;
		//print("initial %s (%d, %d) -> destination (%d, %d); max_y = %d;\n",entry.to_string(),x,y,ix,iy,launcher.grid.get_entry_y_amount(ix));
		
		
		Gtk.Widget widget =  launcher.grid.get_child_at(ix,iy);
		if(widget != null) // Reorder
			for(iy = launcher.saving_content.y_tries+y; iy >= y+delta_y; iy--){
				widget =  launcher.grid.get_child_at(ix,iy);
				if(widget != null){
					launcher.grid.remove(widget);
					launcher.grid.attach(widget,ix,iy+1,1,1);
					((ZLauncher_entry)widget).set_grid_posittion(ix,iy+1);
					//print("move %s (%d, %d) -> (%d, %d); max_y = %d\n",entry.to_string(),x,(iy),x,(iy+1),launcher.grid.get_entry_y_amount(ix));
				}
			}
			
		iy = y+delta_y;
		//print("create %s (%d, %d)\n",entry.to_string(),ix,iy);
		int theme = entry.entry_theme;
		string icon = entry.entry_icon;
		string text = entry.entry_text;
		string cmd = entry.entry_command;
		var new_entry = new ZLauncher_entry(launcher,ix,iy,icon,theme,text,cmd);
		launcher.grid.attach(new_entry,ix,iy,1,1);
		launcher.grid.show_all();
		launcher.saving_content.save_default_content_config();
		entry.grab_focus();
	}
	


}
