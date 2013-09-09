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
public class  ZLauncher_saving_cosmetic: GLib.Object {

	ZLauncher launcher;

	DataOutputStream dos;

	public ZLauncher_saving_cosmetic (ZLauncher launcher) {
		this.launcher = launcher;
	}

	public void save_default_gui_config(){
		save_gui_config(launcher.zconfig_cosmetic);
	}

	public void save_gui_config(string path){
		var file = File.new_for_path (path);
		try {
			if (file.query_exists ()) {
				file.delete ();
			}
			dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
			save_options();
		} catch (Error e) {
			stderr.printf ("Cannot save config file:%s\n%s\n", path,e.message);
		} catch (IOError e) {
			stderr.printf ("Cannot save config file:%s\n%s\n", path,e.message);
		}
	}

	public void save_options() throws IOError {
		ZLauncher_options options = launcher.options;

		//			Launcher
		//				Window
		write_option_int("launcher.position",options.launcher.position);
		write_option_str("launcher.background_color",options.launcher.background_color);
		write_option_int("launcher.border",options.launcher.border);
		//				Grid
		write_option_int("launcher.column_spacing",options.launcher.column_spacing);
		write_option_int("launcher.row_spacing",options.launcher.row_spacing);
		//				Line
		write_option_str("launcher.line_color",options.launcher.line_color);
		write_option_int("launcher.line_width",options.launcher.line_width);
		//			Config
		write_option_str("launcher.button_font",options.launcher.button_font);

		//			Content
		//				Entries
		options.entries.foreach ((index, icon) => {
			write_content_option_str("icon_background_color",index,icon.icon_background_color);
			write_content_option_str("text_background_color",index,icon.text_background_color);
			write_content_option_str("selected_background_color",index,icon.selected_background_color);
			write_content_option_str("initial_text_color",index,icon.initial_text_color);
			write_content_option_str("follow_text_color",index,icon.follow_text_color);
			write_content_option_str("font",index,icon.font);
			write_content_option_int("alignment_x",index,(int)(icon.alignment_x*1000));
			write_content_option_int("alignment_y",index,(int)(icon.alignment_y*1000));
			//stdout.printf ("\t\t%s => %p\n", key, val);
		});

	}
	public void save_entry_options() throws IOError {
		ZLauncher_options options = launcher.options;

	}

	//syntax:
	//	launcher.line_width=15
	//	entry.style=0.icon_background_color=#292929
		
	public void write_option_bool(string option_name, bool option_value) throws IOError {
		write_line("%s=%s".printf(option_name,option_value.to_string()));
	}
	public void write_option_int(string option_name, int option_value) throws IOError {
		write_line("%s=%s".printf(option_name,option_value.to_string()));
	}
	public void write_option_str(string option_name, string option_value) throws IOError {
		write_line("%s=%s".printf(option_name,option_value));
	}


	public void write_content_option_str(string option_name, int style, string option_value) throws IOError {
		write_line("entry.style=%d.%s=%s".printf(style,option_name,option_value));
	}
	public void write_content_option_int(string option_name, int style, int option_value) throws IOError {
		write_line("entry.style=%d.%s=%s".printf(style,option_name,option_value.to_string()));
	}


	public void write_line(string line) throws IOError {
		//print("writing line: %s\n",line);
		dos.put_string (line.concat("\n"));
	}





	public void reset_to_default_cosmetic_config(){
		reset_gui_config(launcher.zconfig_cosmetic);
	}

	public void reset_gui_config(string path){
		var file = File.new_for_path (path);
		try {
			if (file.query_exists ()) {
				file.delete ();
			}
			dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
			reset_options();
		} catch (Error e) {
			stderr.printf ("Cannot save config file:%s\n%s\n", path,e.message);
		} catch (IOError e) {
			stderr.printf ("Cannot save config file:%s\n%s\n", path,e.message);
		}
	}

	public void reset_options() throws IOError {
		string line = """		
		
launcher.position=1
launcher.background_color=#2E3436
launcher.border=0
launcher.column_spacing=20
launcher.row_spacing=2
launcher.line_color=#BABDB6
launcher.line_width=22
launcher.button_font=DejaVuSans 12
entry.style=0.icon_background_color=#D3D7CF
entry.style=0.text_background_color=#2E3436
entry.style=0.selected_background_color=#729FCF
entry.style=0.initial_text_color=#EEEEEC
entry.style=0.follow_text_color=#BABDB6
entry.style=0.font=DejaVuSans 30
entry.style=0.alignment_x=500
entry.style=0.alignment_y=500
entry.style=1.icon_background_color=#555753
entry.style=1.text_background_color=#555753
entry.style=1.selected_background_color=#729FCF
entry.style=1.initial_text_color=#BABDB6
entry.style=1.follow_text_color=#D3D7CF
entry.style=1.font=DejaVuSans 18
entry.style=1.alignment_x=0
entry.style=1.alignment_y=500
entry.style=3.icon_background_color=#292929
entry.style=3.text_background_color=#848484
entry.style=3.selected_background_color=#E3E0AF
entry.style=3.initial_text_color=#292929
entry.style=3.follow_text_color=#000000
entry.style=3.font=DejaVuSans 18
entry.style=3.alignment_x=200
entry.style=3.alignment_y=500
entry.style=2.icon_background_color=#D3D7CF
entry.style=2.text_background_color=#888A85
entry.style=2.selected_background_color=#729FCF
entry.style=2.initial_text_color=#555753
entry.style=2.follow_text_color=#000000
entry.style=2.font=DejaVuSans 18
entry.style=2.alignment_x=200
entry.style=2.alignment_y=500
entry.style=4.icon_background_color=#292929
entry.style=4.text_background_color=#848484
entry.style=4.selected_background_color=#E3E0AF
entry.style=4.initial_text_color=#292929
entry.style=4.follow_text_color=#000000
entry.style=4.font=DejaVuSans 18
entry.style=4.alignment_x=200
entry.style=4.alignment_y=500
		
		""";
		write_line(line);
	}




}
