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
public class ZLauncher_loading_thread : GLib.Object {

	ZLauncher launcher;

	Array<string> icons = new Array<string> ();
	Array<Gtk.Image> icon_imgs = new Array<Gtk.Image> ();

	public ZLauncher_loading_thread (ZLauncher launcher) {
		this.launcher = launcher;
	}

	public void add_icon_pair(string name, Gtk.Image image){
		icons.append_val(name);
		icon_imgs.append_val(image);
	}


	public void start_loading_thread(){

		try {
	        //Thread<void*> thread_a =
	        new Thread<void*>.try ("ZLauncher_loading_thread", this.function);
		} catch (Error e) {
			string msg = e.message;
			stderr.printf(@"Thread error: $msg\n");
		 }

	}

	public void* function () {

		// Create config launcher icons
		launcher.construct_config_gui_first();
		
		// Load Icons
		for(int i=0;i<icons.length;i++){
			string name = icons.index(i);
			if(name != "disable_icon"){
				launcher.loading_content.load_single_icon(name);
				Gtk.Image image = icon_imgs.index(i);
				image.set_from_pixbuf(launcher.options.all_icons.lookup(name));
			}
		}
		
		// Clear Loading Data
		if(icons.length>0)
			icons.remove_range(0,icons.length);
		if(icon_imgs.length>0)
			icon_imgs.remove_range(0,icon_imgs.length);

		// Config loaded with current icons
		launcher.construct_config_gui_second();
		
		// Load all icons
		launcher.loading_content.load_all_icons();
		
		// Reload all icons
		launcher.entry_config.list.clear();
		launcher.options.all_icons.foreach ((key, val) => {
			Gtk.TreeIter iter;
			launcher.entry_config.list.append (out iter);
			launcher.entry_config.list.set (iter, 0, val, 1, key);
			//stdout.printf ("%s => %p\n", key, val);
		});
		
		//Load logo
		launcher.load_logo("../logo/logo-26.png");
		Gdk.Pixbuf p = launcher.loading_content.load_single_pixbuf("../logo/logo-256.png");
		launcher.about.image.set_from_pixbuf(p);
		
		//Apply some visual changes
		//launcher.options.apply_options_gui_launcher(launcher);
		
		return null;
	}


}
