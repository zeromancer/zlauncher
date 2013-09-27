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
public class  ZLauncher_entry_config: GLib.Object {

	// content
	public ZLauncher launcher;
	public ZLauncher_options options;
	public ZLauncher_entry entry;
	// container
	public Gtk.Window window;
	public Gtk.Box box;
	// icon
	public Gtk.ScrolledWindow scroll;
	public Gtk.ListStore list;
	public Gtk.IconView view;
	public string new_icon;
	// text
	public Gtk.Entry new_text_entry;
	public Gtk.Entry new_command_entry;
	// theme
	public Gtk.SpinButton new_theme_spin;
	
	public ZLauncher_entry_config (ZLauncher launcher){
		this.launcher = launcher;
		this.options = launcher.options;
		
		// Window properties
		window = new Gtk.Window(Gtk.WindowType.TOPLEVEL);
		window.title = "Configuration Menu";
		window.destroy.connect (Gtk.main_quit);
		window.set_type_hint(Gdk.WindowTypeHint.DIALOG);
		Gdk.RGBA c = {1,1,1,1};
		c.parse(options.launcher.background_color);
		window.override_background_color(Gtk.StateFlags.NORMAL,c);
		
		// Container
		box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		if(options != null)
			box.set_spacing(options.launcher.row_spacing);
		window.add(box);

		window.key_press_event.connect ((event) => {
			int key = (int)event.keyval;
			if(key == 65293){ // ENTER
				action_apply_and_save();
				return true;
			}else if(key == 65307){// ESCAPE
				window.hide();
				return true;
			}
			return false;
		});
		
		window.focus_out_event.connect ((event) => {
			action_apply_and_save();
			return true;
		});
		
		
		window.title = "ZLauncher Entry Configuration";
		
		add_subheader("Theme:");
		new_theme_spin = add_button_with_spin(0,20,1);
		new_theme_spin.value_changed.connect (() => {
			int val = new_theme_spin.get_value_as_int ();
			change_style(val);
		});
		
		add_subheader("Select Icon:");
		add_icon_grid(options.all_icons);
		select_icon("disable_icon");
		
		add_subheader("Edit Text:");
		new_text_entry = add_text("default text");
		
		add_subheader("Edit Command:");
		new_command_entry =  add_text("default cmd");

		
		add_subheader("Move:");
		
		Gtk.Button move_up = add_button("Move Up");
		move_up.clicked.connect (() => {
			launcher.entry_actions.action_move_up(entry);
			action_apply_and_save();
		});
		
		Gtk.Button move_down = add_button("Move Down");
		move_down.clicked.connect (() => {
			launcher.entry_actions.action_move_down(entry);
			action_apply_and_save();
		});
		
		Gtk.Button move_left = add_button("Move Left");
		move_left.clicked.connect (() => {
			launcher.entry_actions.action_move_left(entry);
			action_apply_and_save();
		});
		
		Gtk.Button move_right = add_button("Move Right");
		move_right.clicked.connect (() => {
			launcher.entry_actions.action_move_right(entry);
			action_apply_and_save();
		});
		
		add_subheader("Create and delete:");
		Gtk.Button duplicate = add_button("Duplicate");
		duplicate.clicked.connect (() => {
			launcher.entry_actions.action_duplicate(entry);
			action_apply_and_save();
		});
		
		Gtk.Button remove = add_button("Remove");
		remove.clicked.connect (() => {
			launcher.entry_actions.action_remove(entry);
			action_apply_and_save();
		});
		
		//add_subheader("Left Margin:");
		//new_theme_spin = add_button_with_spin(0,100,5);
		//new_theme_spin.value_changed.connect (() => {
		//	int val = new_theme_spin.get_value_as_int ();
		//	stdout.printf ("%d\n", val);
		//	entry.margin_left = val;
		//});
		
	}
	
	public void action_apply_and_save(){
		
		string new_text = new_text_entry.get_text();
		string new_cmd = new_command_entry.get_text();
		int new_theme = new_theme_spin.get_value_as_int();
		
		if(entry.entry_icon != new_icon || 
				entry.entry_text != new_text ||
				entry.entry_command != new_cmd ||
				entry.entry_theme != new_theme ){
			entry.set_entry_icon(new_icon);
			entry.set_entry_text(new_text);
			entry.set_entry_command(new_cmd);
			entry.set_entry_theme(new_theme);
			launcher.saving_content.save_default_content_config();
		}
		window.hide();
	}
	
	public void show_configuration(ZLauncher_entry entry){
		this.entry = entry;
		new_icon = entry.entry_icon;
		select_icon(new_icon);
		new_text_entry.set_text(entry.entry_text);
		new_command_entry.set_text(entry.entry_command);
		new_theme_spin.set_value(entry.entry_theme);
		window.show_all();
		
		// change style
		change_style(entry.entry_theme);
	}
	
	public void change_style(int new_style){
		
		//return;
		//print("change style = %d\n",new_style);
		
		if(!options.entries.contains(new_style))
			return;
		
		//Gdk.RGBA color = {Random.next_double() ,Random.next_double(),Random.next_double(),1};
		Gdk.RGBA color = {1,1,1,1};
		color.parse(options.entries.get(new_style).icon_background_color);
		scroll.override_background_color(Gtk.StateFlags.NORMAL,color);
		
		view.override_background_color(Gtk.StateFlags.NORMAL,color);
		//color.parse("#958FFF");
		//view.override_background_color(Gtk.StateFlags.FOCUSED,color);
		//color.parse("#C10E54");
		color.parse(options.entries.get(new_style).selected_background_color);
		view.override_background_color(Gtk.StateFlags.SELECTED,color);
	}
	

	

	public Gtk.Label add_header(string text){
		ZLauncher_options_entry o = options.entries.get(0);
		Gtk.Label label = add_label(text,o.font,o.initial_text_color, o.follow_text_color);
		label.set_alignment(0.5f,0.5f);

		Gdk.RGBA color = {1,1,1,1};
		color.parse(o.text_background_color);
		label.override_background_color(Gtk.StateFlags.NORMAL,color);
		return label;
	}
	public Gtk.Label add_subheader(string text){
		ZLauncher_options_entry o = options.entries.get(1);
		Gtk.Label label = add_label(text,o.font,o.initial_text_color, o.follow_text_color);
		label.set_alignment(0.0f,0.5f);

		Gdk.RGBA color = {1,1,1,1};
		color.parse(o.text_background_color);
		label.override_background_color(Gtk.StateFlags.NORMAL,color);
		return label;
	}
	public Gtk.Label add_label(string text,string font, string initial_color,string follow_color){
		string label_text = get_label_text(text,initial_color,follow_color);
		Gtk.Label label = new Gtk.Label(label_text);
		label.override_font (Pango.FontDescription.from_string (font));
		label.use_markup = true;
		box.pack_start (label, false, false, 0);
		return label;
	}
	public static string get_label_text(string text,string initial_color, string follow_color){
		if(text.length == 0)
			return " ";
		else if(text.length == 1)
			return "<b><span foreground=\"%s\">%s</span></b>".printf(initial_color,text);
		string first = text.substring(0,1);
		string second = text.splice(0,1,"");
		string result = "<b>".concat("<span foreground=\"").concat(initial_color).concat("\">").concat(first);
		result = result.concat("</span><span foreground=\"").concat(follow_color).concat("\">");
		result = result.concat(second).concat("</span>").concat("</b>");
		return result;
	}

	public Gtk.ToggleButton add_button_with_toggle(string text){
		Gtk.ToggleButton button = new Gtk.ToggleButton.with_label (text);
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		button.set_active (false);
		box.pack_start (button, false, false, 0);
		return button;
	}
	public Gtk.ToggleButton add_button_with_toggle_icon(string text,string icon){
		Gtk.ToggleButton button = add_button_with_toggle(text);
		Gtk.Image image = new Gtk.Image.from_pixbuf(options.all_icons.get(icon));
		button.set_image(image);
		return button;
	}

	public Gtk.SpinButton add_button_with_spin(int from,int to, int increment){
		Gtk.SpinButton button = new Gtk.SpinButton.with_range (from, to, increment);
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		box.pack_start (button, false, false, 0);
		return button;
	}



	public Gtk.Button add_button(string text){
		Gtk.Button button = new Gtk.Button.with_label (text);
		button.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		//button.set_alignment(1,0);
		box.pack_start (button, false, false, 0);
		return button;
	}
	public Gtk.Button add_button_with_icon(string text,string icon){
		Gtk.Button button = add_button(text);
		assert (options.all_icons.contains(icon));
		Gtk.Image image = new Gtk.Image.from_pixbuf(options.all_icons.get(icon));
		button.set_image(image);
		return button;
	}

	public Gtk.Image add_image(string path){
		Gtk.Image image = new Gtk.Image.from_file(path);
		box.pack_start (image, false, false, 0);
		return image;
	}

	public Gtk.Entry add_text(string text){
		Gtk.Entry entry = new Gtk.Entry ();
		entry.set_text (text);
		entry.override_font (Pango.FontDescription.from_string (options.launcher.button_font));
		box.pack_start (entry, false, false, 0);
		return entry;
	}

	private Gtk.ScrolledWindow add_icon_grid(HashTable<string, Gdk.Pixbuf> images){

		list = new Gtk.ListStore (2, typeof (Gdk.Pixbuf), typeof (string));
		view = new Gtk.IconView.with_model (list);
		
		view.set_pixbuf_column (0);
		//view.set_text_column (1);
		//view.set_markup_column(2);
		
		view.set_item_padding(0);
		view.set_spacing(0);
		view.set_row_spacing(1);
		view.set_column_spacing(1);
		view.set_selection_mode(Gtk.SelectionMode.BROWSE);

		Gdk.RGBA color = {1,1,1,1};
		color.parse(options.launcher.background_color);
		view.override_background_color(Gtk.StateFlags.NORMAL,color);

		images.foreach ((key, val) => {
			Gtk.TreeIter iter;
			list.append (out iter);
			list.set (iter, 0, val, 1, key);
			//stdout.printf ("%s => %p\n", key, val);
		});

		view.selection_changed.connect (() => {
			List<Gtk.TreePath> paths = view.get_selected_items ();
			Value title;
			Value icon;

			foreach (Gtk.TreePath path in paths) {
				Gtk.TreeIter iter;
				bool tmp = list.get_iter (out iter, path);
				assert (tmp == true);
				list.get_value (iter, 0, out icon);
				list.get_value (iter, 1, out title);
				//stdout.printf ("%s: %p\n", (string) title, ((Gdk.Pixbuf) icon));
				//stdout.printf ("%s\n", (string) path.to_string());
				new_icon = (string) title;
			}
		});

		scroll = new Gtk.ScrolledWindow (null, null);
		scroll.set_policy (Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
		scroll.add (view);
		scroll.set_size_request(300,300);
		box.pack_start (scroll, true, true, 0);
		return scroll;
	}


	private void select_icon(string image){
		int selection = 0;
		Gtk.TreeModelForeachFunc search_selection = (model, path, iter) => {
			GLib.Value cell2;
			list.get_value (iter, 1, out cell2);
			string s = (string) cell2;
			//stdout.printf ("\t\t%p , %s \n", p, s);
			if(image == s){
				var p = new Gtk.TreePath.from_indices(selection);
				view.select_path(p);
				view.scroll_to_path (p, false, 0.5f, 0.5f) ;
				return true;
			}
			selection++;
			return false;
		};
		list.foreach (search_selection);
	}





}
