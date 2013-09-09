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
public class ZLauncher_info_shortcuts : ZLauncher_template {

	public Gtk.Window window;
	public Gtk.Grid grid;
	
	public ZLauncher_info_shortcuts (ZLauncher launcher) {
		base(launcher);
		
		// Window properties
		window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
		window.title = "ZLauncher Shortcuts";
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
			
		Gtk.Label header = get_label("Shortcuts",0);
		grid.attach(header,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		
		Gtk.Label subheader_move = get_label("Move",1);
		grid.attach(subheader_move,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		add_2_subheaders("w","Move Up");
		add_2_subheaders("a","Move Left");
		add_2_subheaders("s","Move Down");
		add_2_subheaders("d","Move Right");
		
		Gtk.Label subheader_copy = get_label("Copy",1);
		grid.attach(subheader_copy,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		add_2_subheaders("W","Copy Up");
		add_2_subheaders("A","Copy Left");
		add_2_subheaders("S","Copy Down");
		add_2_subheaders("D","Copy Right");
		
		Gtk.Label subheader_edit = get_label("Edit",1);
		grid.attach(subheader_edit,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		add_2_subheaders("e","Edit");
		add_2_subheaders("+","Theme +1");
		add_2_subheaders("-","Theme -1");
		add_2_subheaders("i","Disable icon");
		add_2_subheaders("c","Duplicate");
		add_2_subheaders("r","Remove");
		add_2_subheaders("o","Options");
		add_2_subheaders("h","Shortcuts");
		
		Gtk.Label subheader_done = get_label("Select",1);
		grid.attach(subheader_done,0, widget_lines++,first_widget_width+second_widget_width,widget_height);
		
		add_2_subheaders("Arrow","Select");
		add_2_subheaders("ENTER","Confirm Action");
		add_2_subheaders("ESC","Close Window");
		add_2_subheaders("q","Quit");
		
		
		
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
