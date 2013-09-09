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

public class ZActionIcon : Gtk.EventBox {

	public ZLauncher launcher;
	public string icon;
	
	public ZActionIcon (ZLauncher launcher,string icon) {
		// Content
		this.launcher = launcher;
		this.icon = icon;
		Gtk.Image image = new Gtk.Image();
		launcher.loading_content.load_and_set_icon(image,icon);
		this.add(image);
		
    // Colors
    Gdk.RGBA color = {1,1,0.1,1};
		color.parse(launcher.options.launcher.line_color);
		this.override_background_color(Gtk.StateFlags.NORMAL,color);
		color.parse(launcher.options.launcher.background_color);
		this.override_background_color(Gtk.StateFlags.FOCUSED,color);
		
		// Mouse
		this.add_events (Gdk.EventMask.BUTTON_PRESS_MASK);
		this.button_press_event.connect ((e) => {
			action();
			return true;
    });
    this.enter_notify_event.connect((e) =>	{
			this.grab_focus();
			return true;
		});
		
		// Keyboard
		this.set_can_focus(true);
		this.key_press_event.connect ((event) => {
			int key = (int)event.keyval;
			if( key== 32 || key == 65293) // SPACE or ENTER
				action();
			else if( key == 65307) // ESCAPE
				Gtk.main_quit();
			return false;
		});
	}
	
	public signal void action();
}
