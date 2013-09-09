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
public class  ZLauncher_entry: Gtk.EventBox {

	// Gui
	public ZLauncher launcher;
	public ZLauncher_options options;

	// Grid Position
	public int grid_x;
	public int grid_y;

	// Data
	public int		entry_theme;
	public string	entry_icon;
	public string	entry_text;
	public string	entry_command;

	// Image
	public Gtk.Box box;
	public Gtk.Label label;
	public Gtk.Image image;

	public ZLauncher_entry (ZLauncher launcher, int x, int y, string icon, int theme , string text, string cmd) {
		this.launcher = launcher;
		this.options = launcher.options;
		this.grid_x = x;
		this.grid_y = y;
		this.entry_theme = theme;
		this.entry_icon = icon;
		this.entry_text = text;
		this.entry_command = cmd;

		construct_gui();
		launcher.entry_actions.initialize_actions(this);
	}

	private void construct_gui(){
		// Box
		box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		box.set_spacing(0);
		this.add(box);
		this.set_can_focus(true);
		this.grab_focus();
		// Image
		image = new Gtk.Image();
		launcher.loading_content.load_and_set_icon(image,entry_icon);
		box.pack_start(image, false, false, 10);
		// Label
		label = new Gtk.Label(entry_text);
		box.pack_start(label, true, true, 0);
		// Theme
		set_entry_theme(entry_theme);
	}

	// Get Data
	public string get_entry_icon(){
		return entry_icon;
	}

	// Set Data
	public void set_entry_theme(int entry_theme){
		this.entry_theme = entry_theme;
		if( !options.entries.contains(entry_theme))
			options.entries.insert(entry_theme,new ZLauncher_options_entry());
		ZLauncher_options_entry  option= options.entries.get(entry_theme);
		Gdk.RGBA color = {1,1,1,1};
		// Label
		string new_text = get_label_text(entry_text,option.initial_text_color,option.follow_text_color);
		label.set_markup(new_text);
		label.override_font (Pango.FontDescription.from_string (option.font));
		label.set_alignment(option.alignment_x,option.alignment_y);
		// Colors
		color.parse(option.icon_background_color);
		this.override_background_color(Gtk.StateFlags.NORMAL,color);
		color.parse(option.text_background_color);
		label.override_background_color(Gtk.StateFlags.NORMAL,color);
		//margin_left = 10*((int)options.entries.size() - entry_theme);
	}

	public void set_entry_icon(string new_image){
		if(this.entry_icon == new_image)
			return;
		launcher.loading_content.set_icon(image,new_image);
		this.entry_icon = new_image;
	}

	public void set_entry_text(string new_text){
		entry_text = new_text;
		ZLauncher_options_entry option= options.entries.get(entry_theme);
		string temp_text = get_label_text(entry_text,option.initial_text_color,option.follow_text_color);
		label.set_markup(temp_text);
	}

	public void set_entry_command(string new_command){
		this.entry_command = new_command;
	}





	public static string get_label_text(string text,string initial_color, string follow_color){
		if(text.length == 0)
			return " ";
		else if(text.length == 1)
			return "<b><span foreground=\"%s\">%s</span></b>".printf(initial_color,text);
		string first = text.substring(0,1);
		string second = text.splice(0,1,"");
		string result = "<b><span foreground=\"%s\">%s</span>".printf(initial_color,first);
		result += "<span foreground=\"%s\">%s</span></b>".printf(follow_color,second);
		return result;
	}


	// Interface
	public int get_grid_x(){
		return grid_x;
	}
	public void set_grid_x(int x){
		grid_x = x;
	}
	public int get_grid_y(){
		return grid_y;
	}
	public void set_grid_y(int y){
		grid_y = y;
	}
	public void set_grid_posittion(int x, int y){
		grid_x = x;
		grid_y = y;
	}
	public string to_string(){
		//return "Icon:".concat(entry_icon);
		return entry_text;
	}
	public string to_string_all(){
		return "Entry[%d,%d]%s; %s; %s".printf (grid_x,grid_y,entry_icon,entry_text,entry_command);
	}
}
