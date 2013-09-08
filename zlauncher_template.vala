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
public class ZLauncher_template : GLib.Object {
	
	public ZLauncher launcher;
	public ZLauncher_options options;
	
	public ZLauncher_template (ZLauncher launcher) {
		this.launcher = launcher;
		this.options = launcher.options;
	}

	public Gtk.Label get_label(string text,int theme){
		ZLauncher_options_entry o = options.entries.get(theme);
		string label_text = get_label_text(text,o.initial_text_color,o.follow_text_color);
		Gtk.Label label = new Gtk.Label(label_text);
		label.use_markup = true;
		label.set_alignment(o.alignment_x,o.alignment_y);
		label.override_font (Pango.FontDescription.from_string (o.font));
		Gdk.RGBA color = {1,1,1,1};
		color.parse(o.text_background_color);
		label.override_background_color(Gtk.StateFlags.NORMAL,color);
		return label;
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
	
}
