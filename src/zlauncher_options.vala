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
public class  ZLauncher_options_launcher: GLib.Object {
	// Window
	public Gtk.WindowPosition position = Gtk.WindowPosition.CENTER;
	public string	background_color = "#373737";
	public int		border = 0;
	// Grid
	public int		column_spacing = 60;
	public int		row_spacing = 3;
	// Line
	public string	line_color = "#737373";
	public int		line_width = 15;
	// Config
	public string	button_font = "DejaVuSans 13";
}

public class  ZLauncher_options_entry: GLib.Object {
	// Colors
	public string	icon_background_color = "#292929";
	public string	text_background_color = "#848484";
	public string	selected_background_color = "#E3E0AF";
	public string	initial_text_color = "#292929";
	public string	follow_text_color = "#000000";
	// Font
	public string	font = "DejaVuSans 18";
	// Alignment
	public float	alignment_x = 0.2f;
	public float	alignment_y = 0.5f;
}

public class  ZLauncher_options {

	//			Image Assets
	public	HashTable<string, Gdk.Pixbuf> all_icons;
	public ZLauncher_options_launcher launcher;
	public	HashTable<int, ZLauncher_options_entry> entries;


	public ZLauncher_options () {

		all_icons = new HashTable<string, Gdk.Pixbuf> (str_hash, str_equal);
		launcher = new ZLauncher_options_launcher();
		entries = new HashTable<int, ZLauncher_options_entry> (direct_hash,direct_equal);

		int index = -1;
		// Icon Entries
		// 0
		entries.insert(++index,new ZLauncher_options_entry());
		entries.get(index).icon_background_color = "#292929";
		entries.get(index).text_background_color = "#292929";
		entries.get(index).selected_background_color = "#E6E6E6";
		entries.get(index).initial_text_color = "#E6A1A1";
		entries.get(index).follow_text_color = "#D56C6C";
		entries.get(index).font = "DejaVuSans 30";
		entries.get(index).alignment_x = 0.5f;
		entries.get(index).alignment_y = 0.5f;
		// 1
		entries.insert(++index,new ZLauncher_options_entry());
		entries.get(index).icon_background_color = "#292929";
		entries.get(index).text_background_color = "#292929";
		entries.get(index).selected_background_color = "#DEFF5B";
		entries.get(index).initial_text_color = "#D56C6C";
		entries.get(index).follow_text_color = "#F9F9F9";
		entries.get(index).font = "DejaVuSans 18";
		entries.get(index).alignment_x = 0f;
		entries.get(index).alignment_y = 0.5f;
		// 2
		entries.insert(++index,new ZLauncher_options_entry());
		entries.get(index).icon_background_color = "#292929";
		entries.get(index).text_background_color = "#848484";
		entries.get(index).selected_background_color = "#E3E0AF";
		entries.get(index).initial_text_color = "#292929";
		entries.get(index).follow_text_color = "#000000";
		entries.get(index).font = "DejaVuSans 18";
		entries.get(index).alignment_x = 0.2f;
		entries.get(index).alignment_y = 0.5f;

	}


	public void apply_options_all(ZLauncher launcher_gui){
		apply_options_gui_launcher(launcher_gui);
		apply_options_content(launcher_gui);
	}

	public void apply_options_gui_launcher(ZLauncher gui_launcher){
		//print("apply_options_gui_launcher\npos=%d\nback_color=%s\nborder=%d,line_color=%s",
		//launcher.position,launcher.background_color,launcher.border,launcher.line_color);
		
		// Local Variable
		Gdk.RGBA color = {1,1,1,1};
		// Window
		gui_launcher.window_position = launcher.position;
		color.parse(launcher.background_color);
		gui_launcher.override_background_color(Gtk.StateFlags.NORMAL,color);
		gui_launcher.border_width = launcher.border;
		// Grid
		gui_launcher.grid.set_column_homogeneous(true);
		gui_launcher.grid.set_row_spacing(launcher.row_spacing);
		gui_launcher.grid.set_column_spacing(launcher.column_spacing);
		gui_launcher.grid.set_margin_left(launcher.column_spacing/2);
		gui_launcher.grid.set_margin_right(launcher.column_spacing/2);
		// Lines
		if(gui_launcher.line1 != null && gui_launcher.line2 != null){
			color.parse (launcher.line_color);
			gui_launcher.line1.override_background_color(Gtk.StateFlags.NORMAL,color);
			gui_launcher.line2.override_background_color(Gtk.StateFlags.NORMAL,color);
			gui_launcher.line1.set_size_request(1,launcher.line_width);
			gui_launcher.line2.set_size_request(1,launcher.line_width);
			
		}
		if(gui_launcher.info_icon != null){
			color.parse(launcher.line_color);
			gui_launcher.info_icon.override_background_color(Gtk.StateFlags.NORMAL,color);
			gui_launcher.about_icon.override_background_color(Gtk.StateFlags.NORMAL,color);
			gui_launcher.reset_icon.override_background_color(Gtk.StateFlags.NORMAL,color);
			gui_launcher.option_icon.override_background_color(Gtk.StateFlags.NORMAL,color);
			color.parse(launcher.background_color);
			gui_launcher.info_icon.override_background_color(Gtk.StateFlags.FOCUSED,color);
			gui_launcher.about_icon.override_background_color(Gtk.StateFlags.FOCUSED,color);
			gui_launcher.reset_icon.override_background_color(Gtk.StateFlags.FOCUSED,color);
			gui_launcher.option_icon.override_background_color(Gtk.StateFlags.FOCUSED,color);
		}
	}
	
	
	
	
	public void apply_options_content(ZLauncher launcher){

		//entries.foreach ((index, option) => {
		//print(@"apply_options_content [$index]
		//$(option.icon_background_color)
		//$(option.text_background_color)
		//$(option.selected_background_color)
		//$(option.initial_text_color)
		//$(option.follow_text_color)\n");
		//});
		
		for(int x = 0; x<launcher.saving_content.x_tries;x++)
			for(int y = 0; y<launcher.saving_content.y_tries;y++){
				Gtk.Widget widget = launcher.grid.get_child_at(x,y);
				if(widget != null){
					ZLauncher_entry entry = (ZLauncher_entry)widget;
					entry.set_entry_theme(entry.entry_theme);
				}
			}

	}

}
