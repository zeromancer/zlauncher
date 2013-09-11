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
public class ZLauncher_info_about : ZLauncher_template {

	public Gtk.Window window;
	public Gtk.Grid grid;
	public Gtk.Image image;
	
	public ZLauncher_info_about (ZLauncher launcher) {
		base(launcher);
		// Window properties
		window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
		window.title = "Zlauncher About";
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
			
		Gtk.Label header = get_label("ZLauncher About",0);
		grid.attach(header,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
//~ 		Gtk.Label subheader_logo = get_label("Logo",1);
//~ 		grid.attach(subheader_logo,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		image = new Gtk.Image();
		//launcher.loading_content.load_and_set_icon(image,"logo-64");
		grid.attach(image,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		
		Gtk.Label subheader_move = get_label("Source Code",1);
		grid.attach(subheader_move,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		add_2_subheaders("Version:","1.0");
		add_2_subheaders("License:","GPL v3");
		add_2_subheaders("Location:","GitHub");
		//add_2_subheaders("","https://github.com/zeromancer/zlauncher");
		add_1_subheader("https://github.com/zeromancer/zlauncher");
		add_2_subheaders("Author:","David Siewert");
		add_1_subheader("Contact:","siewert"+".msc"+"@"+"gmail"+".com");
		
		Gtk.Label subheader_copy = get_label("Icons",1);
		grid.attach(subheader_copy,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		//add_2_subheaders("License:","Creative Commons Attribution-NoDerivs 3.0 Unported");
		add_2_subheaders("License:","Creative Commons");
		add_2_subheaders("","Attribution-NoDerivs");
		add_2_subheaders("","3.0 Unported");
//~ 		add_1_subheader("Attribution-NoDerivs 3.0 Unported");
		add_2_subheaders("Owner:","http://icons8.com/");
		//add_2_subheaders("","http://creativecommons.org/licenses/by-nd/3.0/");

		
		Gtk.Button button = new Gtk.Button.with_label ("Done");
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		grid.attach(button,0,widget_lines++,first_widget_width+second_widget_width,widget_height);
		button.clicked.connect (() => {
			window.hide();
		});
		
		window.key_press_event.connect ((event) => {
			int key = (int)event.keyval;
			if( key== 32 || key == 65293){ // SPACE or ENTER
				window.hide();
				return true;
			}
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
	int second_widget_width = 3;
	int widget_height = 1;
	
	public void add_1_subheader(string text1){
		Gtk.Label label1 = get_label(text1,2);
		label1.margin_left = options.launcher.column_spacing/2;
		label1.margin_right = options.launcher.column_spacing/2;
		grid.attach(label1,0,widget_lines,first_widget_width+second_widget_width,1);
		widget_lines++;
	}
	
	public void add_2_subheaders(string text1, string text2){
		
		Gtk.Label label1 = get_label(text1,2);
		label1.margin_left = options.launcher.column_spacing/2;
		grid.attach(label1,0,widget_lines,first_widget_width,1);
		
		Gtk.Label label2 = get_label(text2,2);
		label2.margin_right = options.launcher.column_spacing/2;
		grid.attach(label2,first_widget_width,widget_lines,second_widget_width,1);
		
		widget_lines++;
	}


}
