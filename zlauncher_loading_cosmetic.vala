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
public class  ZLauncher_loading_cosmetic : GLib.Object {

	ZLauncher launcher;
	ZLauncher_options options;

	public ZLauncher_loading_cosmetic (ZLauncher launcher) {
		this.launcher = launcher;
		this.options = launcher.options;
	}


	public void load_default_cosmetic_config(){	
				
		var file = File.new_for_path(launcher.zconfig_cosmetic);
		if (!file.query_exists()) {
			launcher.saving_cosmetic.reset_to_default_cosmetic_config();
			
			if (file.query_exists())
				load_config(file);
			else
				stderr.printf ("File '%s' doesn't exist or isn't a file.\n", file.get_path ());
				
			// Maybe do: load from memory
			//GLib.InputStream input_stream = new GLib.MemoryInputStream.from_data ("Some string to parse".data, GLib.g_free);
		}else
			load_config(file);
		
	}
	
	public void load_cosmetic_config(string path){
		assert (path.length>0);
		
		var file = File.new_for_path (path);
		if (!file.query_exists ()) {
			stderr.printf ("File '%s' doesn't exist or isn't a file.\n", file.get_path ());
		}
		
		load_config(file);
	}


	private void load_config(GLib.File file){
		
		//stdout.printf ("Trying loading configuration file %s\n", path);
		
		string line;
		DataInputStream dis;

		try {
			dis = new DataInputStream (file.read ());
			while ((line = dis.read_line (null)) != null) {
				//stdout.printf ("\t%s\n", line);
				line = line.strip();
				if(line.has_prefix("#") || line.has_prefix("//") || line.length<5)
					continue;
					
				//syntax:
				//	launcher.line_width=15
				//	entry.style=0.icon_background_color=#292929
				
				if(line.has_prefix("launcher."))
					load_launcher_config(line);
				else if(line.has_prefix("entry."))
					load_entry_config(line);
				else
					stdout.printf("\tfollowing cosmetic line option was not recognised:\n\t%s\n", line);
				
			}
		} catch (Error e) {
			error ("%s", e.message);
			//return false;
		}
	}

	public void load_launcher_config(string line){
		
		string[] vals = line.split("=",2);
		string option_type = vals[0];
		string option_value = vals[1];
		
		if (" " == option_type){
		//			Launcher
		//				Window
		}else if ( option_type.has_prefix("launcher.position") ){
			options.launcher.position = (Gtk.WindowPosition)int.parse(option_value);
		}else if ( option_type.has_prefix("launcher.background_color") ){
			options.launcher.background_color = option_value;
		}else if ( option_type.has_prefix("launcher.border") ){
			options.launcher.border = int.parse(option_value);
		//				Grid
		}else if ( option_type.has_prefix("launcher.column_spacing") ){
			options.launcher.column_spacing = int.parse(option_value);
		}else if ( option_type.has_prefix("launcher.row_spacing") ){
			options.launcher.row_spacing = int.parse(option_value);
		//				Line
		}else if ( option_type.has_prefix("launcher.line_color") ){
			options.launcher.line_color = option_value;
		}else if ( option_type.has_prefix("launcher.line_width") ){
			options.launcher.line_width = int.parse(option_value);
		}else if ( option_type.has_prefix("launcher.button_font") ){
			options.launcher.button_font = option_value;

		// 		Error
		}else{
			stdout.printf ("\tfollowing launcher option was not recognised:\n\t%s\n", line);
		}
	}


	public void load_entry_config(string line){
		
		string new_line = line[12:line.length];
		string[] parts = new_line.split(".",2);
		string[] options_parts = parts[1].split("=",2);
		
		int style = int.parse(parts[0]);
		if(!options.entries.contains(style))
				options.entries.insert(style,new ZLauncher_options_entry());
				
		string content_option_type = options_parts[0];
		string content_options_value = options_parts[1];
		
		//print("%s\n",line);
		//print("[%d] %s = %s\n",style,content_option_type,content_options_value);
		
		if ("   " in content_option_type){

		//			Content
		}else if ( content_option_type.has_prefix("icon_background_color") ){
			options.entries.get(style).icon_background_color = content_options_value;
		}else if (content_option_type.has_prefix("text_background_color")){
			options.entries.get(style).text_background_color = content_options_value;
		}else if (content_option_type.has_prefix("selected_background_color")){
			options.entries.get(style).selected_background_color = content_options_value;
		}else if (content_option_type.has_prefix("initial_text_color")){
			options.entries.get(style).initial_text_color = content_options_value;
		}else if (content_option_type.has_prefix("follow_text_color")){
			options.entries.get(style).follow_text_color = content_options_value;
		}else if (content_option_type.has_prefix("font")){
			options.entries.get(style).font = content_options_value;
		}else if (content_option_type.has_prefix("alignment_x")){
			options.entries.get(style).alignment_x = ((float)(int.parse(content_options_value)))/1000;
		}else if (content_option_type.has_prefix("alignment_y")){
			options.entries.get(style).alignment_y = ((float)(int.parse(content_options_value)))/1000;
		
		// 		Error
		}else{
			stdout.printf ("\t following entry option was not recognised:\n\t%s\n", line);
		}
		
		
	}



}
