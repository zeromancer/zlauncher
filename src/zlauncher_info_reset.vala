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
public class ZLauncher_info_reset : ZLauncher_template {

	public Gtk.Window window;
	public Gtk.Grid grid;
	public Gtk.Image image;
	
	public ZLauncher_info_reset (ZLauncher launcher) {
		base(launcher);
		// Window properties
		window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
		window.title = "Zlauncher Reset";
		window.destroy.connect (Gtk.main_quit);
		window.set_type_hint(Gdk.WindowTypeHint.DIALOG);
		Gdk.RGBA c = {1,1,1,1};
		c.parse(options.launcher.background_color);
		window.override_background_color(Gtk.StateFlags.NORMAL,c);

		// Grid
		grid = new Gtk.Grid();
		grid.row_spacing = options.launcher.row_spacing;
		grid.column_spacing = options.launcher.column_spacing;
		window.add(grid);
		
		// Content
			
		Gtk.Label header = get_label("ZLauncher Reset",0);
		grid.attach(header,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		image = new Gtk.Image.from_stock(Gtk.Stock.DELETE,Gtk.IconSize.DIALOG);
		//launcher.loading_content.load_and_set_icon(image,"logo-64");
		grid.attach(image,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		add_subheader("Do you really want to delete all");
		add_subheader("current modifications");
		add_subheader("and reset configuration files?");
		
		Gtk.Button button = new Gtk.Button.with_label ("Yes");
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		grid.attach(button,0,widget_lines++,first_widget_width+second_widget_width,widget_height);
		button.clicked.connect (() => {
			window.hide();
		});
		
		
		Gtk.Button button_no = new Gtk.Button.with_label ("No");
		button_no.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		grid.attach(button_no,0,widget_lines++,first_widget_width+second_widget_width,widget_height);
		button_no.clicked.connect (() => {
			launcher.saving_content.reset_to_default_content_config();
			launcher.saving_cosmetic.reset_to_default_cosmetic_config();
			window.hide();
			Gtk.main_quit();
		});
		
		window.key_press_event.connect ((event) => {
			int key = (int)event.keyval;
			if (event.str == "q")
				Gtk.main_quit();
			if(key == 65307){ // ESCAPE
				window.hide();
				return true;
			}
			return false;
		});
		
	}
	
	
	int widget_lines=0;
	int first_widget_width = 1;
	int second_widget_width = 1;
	int widget_height = 1;
	
	public void add_subheader(string text1){
		
		Gtk.Label label1 = get_label(text1,1);
		label1.margin_left = options.launcher.column_spacing/2;
		label1.margin_right = options.launcher.column_spacing/2;
		grid.attach(label1,0,widget_lines,first_widget_width+second_widget_width,widget_height);
		
		widget_lines++;
	}


}
