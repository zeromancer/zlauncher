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
public class ZLauncher_options_config : ZLauncher_template {

	public Gtk.Grid grid;
	public Gtk.Window window;

	public ZLauncher_options_config(ZLauncher launcher){
		base(launcher);

		// Window properties
		window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
		window.title = "Configuration Menu";
		window.destroy.connect (Gtk.main_quit);
		window.set_type_hint(Gdk.WindowTypeHint.DIALOG);

		// Grid
		this.grid = new Gtk.Grid();
		// Options
		grid.row_spacing = options.launcher.row_spacing;
		Gdk.RGBA c = {1,1,1,1};
		Gdk.Color? cc = null;
		c.parse(options.launcher.background_color);
		window.override_background_color(Gtk.StateFlags.NORMAL,c);
		window.add(grid);

			
		Gtk.Label label_launcher = get_header("Launcher options");
		grid.attach(label_launcher,x_first,y++,width_first+width_second,height);

		Gtk.ColorButton launcher_backround_color = get_color_button("Background");
		Gdk.Color.parse (options.launcher.background_color, out cc);
		launcher_backround_color.set_color (cc);
		launcher_backround_color.color_set.connect (() => {
			options.launcher.background_color = convert_to_string(launcher_backround_color.rgba);
			options.apply_options_gui_launcher(launcher);
		});

		Gtk.SpinButton launcher_border = get_spin_button("Border",0,100,1);
		launcher_border.set_value((double)(options.launcher.border));
		launcher_border.value_changed.connect (() => {
			options.launcher.border = launcher_border.get_value_as_int();
			//print("Border %d\n",launcher_border.get_value_as_int());
			options.apply_options_gui_launcher(launcher);
		});
		
		Gtk.SpinButton launcher_column_spacing = get_spin_button("Column spacing",0,100,1);
		launcher_column_spacing.set_value((double)(options.launcher.column_spacing));
		launcher_column_spacing.value_changed.connect (() => {
			options.launcher.column_spacing = launcher_column_spacing.get_value_as_int();
			options.apply_options_gui_launcher(launcher);
		});
		Gtk.SpinButton launcher_row_spacing = get_spin_button("Row spacing",0,100,1);
		launcher_row_spacing.set_value((double)(options.launcher.row_spacing));
		launcher_row_spacing.value_changed.connect (() => {
			options.launcher.row_spacing = launcher_row_spacing.get_value_as_int();
			options.apply_options_gui_launcher(launcher);
		});
		
		Gtk.ColorButton launcher_line_color = get_color_button("Line color");
		Gdk.Color.parse (options.launcher.line_color, out cc);
		launcher_line_color.set_color (cc);
		launcher_line_color.color_set.connect (() => {
			options.launcher.line_color = convert_to_string(launcher_line_color.rgba);
			options.apply_options_gui_launcher(launcher);
		});

		Gtk.SpinButton launcher_line_width = get_spin_button("Line width",0,100,1);
		launcher_line_width.set_value((double)(options.launcher.line_width));
		launcher_line_width.value_changed.connect (() => {
			options.launcher.line_width = launcher_line_width.get_value_as_int();
			options.apply_options_gui_launcher(launcher);
		});
		
		Gtk.FontButton launcher_button_font = get_font_button("Button Font");
		launcher_button_font.set_font_name(options.launcher.button_font);
		launcher_button_font.font_set.connect (() => {
			options.launcher.button_font = launcher_button_font.get_font_name();
			options.apply_options_gui_launcher(launcher);
		});
		
		


		x_first+=3;
		x_second+=3;
		y = 0;
		Gtk.Label label_entry = get_header("Entry options");
		grid.attach(label_entry,x_first,y++,width_first+width_second,height);


		Gtk.SpinButton entry_theme = get_spin_button("Entry theme",0,10,1);

		Gtk.ColorButton entry_icon_background = get_color_button("Icon background");
		Gdk.Color.parse (options.entries.get(0).icon_background_color, out cc);
		entry_icon_background.set_color (cc);
		entry_icon_background.color_set.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).icon_background_color = convert_to_string(entry_icon_background.rgba);
			options.apply_options_content(launcher);
		});

		Gtk.ColorButton entry_text_background = get_color_button("Text background");
		Gdk.Color.parse (options.entries.get(0).text_background_color, out cc);
		entry_text_background.set_color (cc);
		entry_text_background.color_set.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).text_background_color = convert_to_string(entry_text_background.rgba);
			options.apply_options_content(launcher);
		});

		Gtk.ColorButton entry_selected_background = get_color_button("Selected background");
		Gdk.Color.parse (options.entries.get(0).selected_background_color, out cc);
		entry_selected_background.set_color (cc);
		entry_selected_background.color_set.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).selected_background_color = convert_to_string(entry_selected_background.rgba);
			options.apply_options_content(launcher);
		});

		Gtk.ColorButton entry_initial_text_color = get_color_button("First letter");
		Gdk.Color.parse (options.entries.get(0).initial_text_color, out cc);
		entry_initial_text_color.set_color (cc);
		entry_initial_text_color.color_set.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).initial_text_color = convert_to_string(entry_initial_text_color.rgba);
			options.apply_options_content(launcher);
		});

		Gtk.ColorButton entry_follow_text_color = get_color_button("Following letters");
		Gdk.Color.parse (options.entries.get(0).follow_text_color, out cc);
		entry_follow_text_color.set_color (cc);
		entry_follow_text_color.color_set.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).follow_text_color = convert_to_string(entry_follow_text_color.rgba);
			options.apply_options_content(launcher);
		});

		Gtk.FontButton entry_font = get_font_button("Font");
		entry_font.set_font_name(options.entries.get(0).font);
		entry_font.font_set.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).font = entry_font.get_font_name();
			options.apply_options_content(launcher);
		});

		Gtk.SpinButton entry_alignment_x = get_spin_button("Alignment x",0,1,0.1);
		entry_alignment_x.set_value((double)(options.entries.get(0).alignment_x));
		entry_alignment_x.value_changed.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).alignment_x = (float)entry_alignment_x.get_value();
			options.apply_options_content(launcher);
		});

		Gtk.SpinButton entry_alignment_y = get_spin_button("Alignment y",0,1,0.1);
		entry_alignment_y.set_value((double)(options.entries.get(0).alignment_y));
		entry_alignment_y.value_changed.connect (() => {
			int theme = entry_theme.get_value_as_int();
			options.entries.get(theme).alignment_y = (float)entry_alignment_y.get_value();
			options.apply_options_content(launcher);
		});


		entry_theme.value_changed.connect (() => {

			int theme = entry_theme.get_value_as_int();
			if( !options.entries.contains(theme))
				options.entries.insert(theme,new ZLauncher_options_entry());
			ZLauncher_options_entry  option = options.entries.get(theme);

			entry_icon_background.rgba.parse(option.icon_background_color);

			Gdk.Color.parse (option.icon_background_color, out cc);
			entry_icon_background.set_color (cc);

			Gdk.Color.parse (option.text_background_color, out cc);
			entry_text_background.set_color (cc);

			Gdk.Color.parse (option.selected_background_color, out cc);
			entry_selected_background.set_color (cc);

			Gdk.Color.parse (option.initial_text_color, out cc);
			entry_initial_text_color.set_color (cc);

			Gdk.Color.parse (option.follow_text_color, out cc);
			entry_follow_text_color.set_color (cc);

			entry_font.set_font_name(option.font);
			entry_alignment_x.set_value((double)(option.alignment_x));
			entry_alignment_y.set_value((double)(option.alignment_y));
		});


		Gtk.Button button = get_button("Save changes");
		grid.attach(button,0,y++,(width_first+width_second)*3,height);
		button.clicked.connect (() => {
			launcher.saving_cosmetic.save_default_gui_config();
			window.hide();
		});
		
		
		window.key_press_event.connect ((event) => {
			int key = (int)event.keyval;
			if (event.str == "q")
				Gtk.main_quit();
				
			if(key == 65307){ // ESCAPE
				launcher.saving_cosmetic.save_default_gui_config();
				window.hide();
				return true;
			}
			return false;
		});

//~ 		window.focus_out_event.connect ((event) => {
//~ 			action_apply_and_save();
//~ 			return true;
//~ 		});


	}

//~ 	public static string convert_to_string(Gdk.RGBA c){
//~ 		string s = "#%02x%02x%02x%02x".printf(
//~ 								(uint)(Math.round(c.red*255)),
//~ 								(uint)(Math.round(c.green*255)),
//~ 								(uint)(Math.round(c.blue*255)),
//~ 								(uint)(Math.round(c.alpha*255)))
//~ 								.up();
//~ 		stdout.printf("%s\n", s);
//~ 		return s;
//~ 	}

	public static string convert_to_string(Gdk.RGBA c){
		string red = "%02x".printf((uint)(c.red*255));
		string green = "%02x".printf((uint)(c.green*255));
		string blue = "%02x".printf((uint)(c.blue*255));
		//string alpha = "%02x".printf((uint)(c.alpha*255));
		string s = ("#"+red+green+blue).up();//+alpha
		//stdout.printf("%s\n", s);
		return s;
	}

	private int x_first = 0;
	private int x_second = 2;
	private int width_first = 2;
	private int width_second = 1;
	private int height =1;
	private int y = 0;

	public Gtk.SpinButton get_spin_button(string text,double start,double end,double increment){
		Gtk.SpinButton button = new Gtk.SpinButton.with_range (start,end,increment);
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		get_pair(text,button);
		return button;
	}
	public Gtk.ColorButton get_color_button(string text){
		Gtk.ColorButton button = new Gtk.ColorButton ();
		get_pair(text,button);
		return button;
	}
	public Gtk.FontButton get_font_button(string text){
		Gtk.FontButton button = new Gtk.FontButton ();
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		//button.set_title ("font");
		button.set_show_style(false);
		button.set_show_size(false);
		get_pair(text,button);
		return button;
	}

	public void get_pair(string text, Gtk.Widget widget){
		Gtk.Label label = get_subheader(text);
		grid.attach(label,x_first,y,width_first,height);
		grid.attach(widget,x_second,y++,width_second,height);
		label.margin_left = 20;
		widget.margin_right = 20;
		grid.show_all();
	}

	public Gtk.Label get_header(string text){
		Gtk.Label label = get_label(text,0);
		label.margin_left = 20;
		label.margin_right = 20;
		label.set_alignment(1,0.5f);
		return label;
	}
	public Gtk.Label get_subheader(string text){
		Gtk.Label label = get_label(text,1);
		label.set_alignment(1,0.5f);
		return label;
	}

	public Gtk.Button get_button(string text){
		Gtk.Button button = new Gtk.Button.with_label (text);
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		return button;
	}



}
