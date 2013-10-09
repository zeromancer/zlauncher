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
public class ZLauncher : Gtk.Window  {

	//	Frontend
	//		GUI
	public Gtk.Grid grid;
	public Gtk.Box box;
	public Gtk.Box line_box;
	public Gtk.Label line1;
	public Gtk.Label line2;
	public ZActionIcon info_icon;
	public ZActionIcon about_icon;
	public ZActionIcon option_icon;
	public ZActionIcon reset_icon;
	//		Classes
	public ZLauncher_entry_config entry_config;
	public ZLauncher_options_config options_config;
	public ZLauncher_info_about about;
	public ZLauncher_info_shortcuts info;
	public ZLauncher_info_reset reset;
	
	// Backend
	public ZLauncher_options options;
	public ZLauncher_entry_actions entry_actions;
	public ZLauncher_loading_content loading_content;
	public ZLauncher_loading_cosmetic loading_cosmetic;
	public ZLauncher_loading_thread loading_thread;
	public ZLauncher_saving_content saving_content;
	public ZLauncher_saving_cosmetic saving_cosmetic;

	// Config
	//		User
	public string zconfig_directory;
	public string zconfig_icon_directory;
	public string zconfig_content;
	public string zconfig_cosmetic;
	//		System
	public string zconfig_icon_directory_fallback = "example-icons-dark";
	public string zconfig_icon_directory_fallback2 = "/usr/share/icons/win8";
	public string zconfig_icon_directory_fallback3 = "/share/icons/win8";
	public string zconfig_content_filename = "zconfig_content.txt";
	public string zconfig_cosmetic_filename = "zconfig_cosmetic.txt";

	public ZLauncher () {

		// Initialize Backend
		options = new ZLauncher_options();
		entry_actions = new ZLauncher_entry_actions();
		loading_content = new ZLauncher_loading_content(this);
		loading_cosmetic = new ZLauncher_loading_cosmetic(this);
		loading_thread = new ZLauncher_loading_thread(this);
		saving_content = new ZLauncher_saving_content(this);
		saving_cosmetic = new ZLauncher_saving_cosmetic(this);
		
		// Initialize Configuration Files
		initialize_zconfigs();

		// Construct Main GUI
		construct_main_gui();
		
		// Load
		loading_cosmetic.load_default_cosmetic_config();
		loading_content.load_default_content_config();
		options.apply_options_gui_launcher(this);
		loading_thread.start_loading_thread();
		
		// Following line is a way to circumvent a bug
		Thread.usleep (10000);
		
	}
	
	public void initialize_zconfigs(){
		
		zconfig_directory = GLib.Environment.get_user_config_dir()+"/"+"zlauncher";
		zconfig_icon_directory = zconfig_directory + "/" + "icons";
		zconfig_content = zconfig_directory + "/" + zconfig_content_filename;
		zconfig_cosmetic = zconfig_directory + "/" + zconfig_cosmetic_filename;
		
		try {
			File directory = File.new_for_path(zconfig_directory);
			
			if (!directory.query_exists ())
				directory.make_directory ();
			
			File content = File.new_for_path(zconfig_content);
			if (!content.query_exists ())
				saving_content.reset_to_default_content_config();
				
			File cosmetic = File.new_for_path(zconfig_cosmetic);
			if (!cosmetic.query_exists ())
				saving_cosmetic.reset_to_default_cosmetic_config();
			
			
			File icon_directory = File.new_for_path(zconfig_icon_directory);
			
			
			if (!icon_directory.query_exists ()){
				icon_directory.make_directory ();
			
				File default_icon_directory;
				default_icon_directory = File.new_for_path(zconfig_icon_directory_fallback);	
				
				if(!default_icon_directory.query_exists())
					default_icon_directory = File.new_for_path(zconfig_icon_directory_fallback2);	
					
				if(!default_icon_directory.query_exists())
					default_icon_directory = File.new_for_path(zconfig_icon_directory_fallback3);
					
				assert (default_icon_directory.query_exists());
				
				var enumerator = default_icon_directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);
				FileInfo file_info;
				while ((file_info = enumerator.next_file ()) != null) {
					File file = File.new_for_path(zconfig_icon_directory+"/"+file_info.get_name());
					file.make_symbolic_link(default_icon_directory.get_path()+"/"+file_info.get_name());
				}	
			}
			
		} catch (Error e) {
			stdout.printf ("Error: %s\n", e.message);
		}
		
	}
	
	private void construct_main_gui(){
		title = "ZLauncher";
		destroy.connect (Gtk.main_quit);
		//add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
		box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		add(box);
		line1 = new Gtk.Label("");
		grid = new Gtk.Grid();
		line2 = new Gtk.Label("");
		box.pack_start (line1, false, false, 0);
		box.pack_start (grid, false, false, 10);
		
		line_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL,0);
		box.pack_start (line_box, false, false, 0);
		line_box.pack_start (line2, true, true, 0);
		
		option_icon = new ZActionIcon(this,"engineering-26");
		line_box.pack_start (option_icon, false, false, 0);
		option_icon.action.connect ((s) => options_config.window.show_all());
		
		reset_icon = new ZActionIcon(this,"undo-26");
		line_box.pack_start (reset_icon, false, false, 0);
		reset_icon.action.connect ((s) => reset.window.show_all());
		
		info_icon = new ZActionIcon(this,"info-26");
		line_box.pack_start (info_icon, false, false, 0);
		info_icon.action.connect ((s) => info.window.show_all());
		
		about_icon = new ZActionIcon(this,"generic_text-26");
		line_box.pack_start (about_icon, false, false, 0);
		about_icon.action.connect ((s) => about.window.show_all());
	}
		
	public void construct_config_gui_first(){
	}
	
	public void construct_config_gui_second(){
		entry_config = new ZLauncher_entry_config(this);
		options_config = new ZLauncher_options_config(this);
		about = new ZLauncher_info_about(this);
		info = new ZLauncher_info_shortcuts(this);
		reset = new ZLauncher_info_reset(this);
	}
		

	
}



int main (string[] args) {
	Gtk.init (ref args);
	ZLauncher gui = new ZLauncher();
	gui.window_position = Gtk.WindowPosition.CENTER;
	gui.show_all();
	Gtk.main ();
	return 0;
}
public static int min(int a, int b){
	return a<b?a:b;
}

public static int max(int a, int b){
	return a>=b?a:b;
}
