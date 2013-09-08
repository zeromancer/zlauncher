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
public class  ZLauncher_loading_content : GLib.Object {

	ZLauncher launcher;
	ZLauncher_options options;

	public ZLauncher_loading_content (ZLauncher launcher) {
		this.launcher = launcher;
		this.options = launcher.options;
	}
	

	public void load_default_content_config(){	
				
		var file = File.new_for_path(launcher.zconfig_content);
		if (!file.query_exists()) {
			launcher.saving_content.reset_to_default_content_config();
			
			if (file.query_exists())
				load_config(file);
			else
				stderr.printf ("File '%s' doesn't exist or isn't a file.\n", file.get_path ());
				
			// Maybe do: load from memory
			//GLib.InputStream input_stream = new GLib.MemoryInputStream.from_data ("Some string to parse".data, GLib.g_free);
		}else
			load_config(file);
		
	}
	
	public void load_content_config(string path){
		assert (path.length>0);
		
		var file = File.new_for_path (path);
		if (!file.query_exists ()) {
			stderr.printf ("File '%s' doesn't exist or isn't a file.\n", file.get_path ());
		}
		
		load_config(file);
	}



	private void load_config(GLib.File file){
		
		//stdout.printf ("Trying loading configuration file %s\n", path);
		
		string line;
		DataInputStream dis;

		try {
			dis = new DataInputStream (file.read ());
			while ((line = dis.read_line (null)) != null) {
				
				
				//syntax:
				//	[x,y]entry⋮style=2⋮icon=leaf3-26⋮text=text⋮cmd=
				
				line = line.strip();
				//stdout.printf ("\t%s\n", line);
				
				if(line.has_prefix("#") || line.has_prefix("//") || line.length<5)
					continue;
					
				line = line[1:line.length];
				string[] division = line.split("]",2);
				string[] coordinates = division[0].split(",",2);
				int x = int.parse(coordinates[0]);
				int y = int.parse(coordinates[1]);
				string[] parts = division[1].split("⋮",5);
				//print("parts 0=%s, 1=%s, 2=%s, 3=%s, 4=%s\n",parts[0],parts[1],parts[2],parts[3],parts[4]);
				
				if(parts[0] == "entry"){
					
					int style = int.parse(parts[1].split("=",2)[1]);
					string icon = parts[2].split("=",2)[1];
					string text = parts[3].split("=",2)[1].strip();
					string cmd = parts[4].split("=",2)[1];
					var entry = new ZLauncher_entry(launcher,x,y,icon,style,text,cmd);
					launcher.grid.attach(entry,x,y,1,1);
					//print("\tPanel %d : %d Added Icon Entry: %s,%s,%s\n",x,y,icon,text,cmd);
					
				} else
					stdout.printf ("\t following line was not recognised and will be skipped: \n\t   %s\n", line);
				
				
			}
		} catch (Error e) {
			error ("%s", e.message);
			//return false;
		}
	}











	public bool set_icon(Gtk.Image image, string icon){
		if(icon == "disable_icon" || icon == ""){
			image.clear();
			return true;
		}else if(options.all_icons.contains(icon)){
			image.set_from_pixbuf(options.all_icons.get(icon));
			return true;
		}else
			return false;
	}
	
	public void load_and_set_icon(Gtk.Image image, string icon){
		if(!set_icon(image,icon))
			launcher.loading_thread.add_icon_pair(icon,image);
	}








	public void load_single_icon(string icon){
			load_single_pixbuf_in_path(options.all_icons,launcher.zconfig_icon_directory,icon);
	}

	public void load_all_icons(){
		load_all_pixbuf_in_path(options.all_icons,launcher.zconfig_icon_directory);
		//load_all_pixbuf_in_path(all_icons,"user-icons");
	}

	public static int load_single_pixbuf_in_path(HashTable<string, Gdk.Pixbuf> table, string path,string name){
		assert (path.length>0);
		assert (name.length>0);
		if(table.contains(name))
			return 0;
		try {
			var pixbuf = new Gdk.Pixbuf.from_file(path+"/"+name+".png");
			//print("\t trying to load pixbuf: %s/%s\n",path,name);
			string new_name = name.replace(".png","");
			table.insert(new_name,pixbuf);
		} catch (Error e) {
			stderr.printf ("Error loading single pixbuf: %s/%s\n%s\n", path,name,e.message);
			return 1;
		}
		return 0;
	}

	public static Gdk.Pixbuf? load_single_pixbuf(string name){
		assert (name.length>0);
		try {
			var p = new Gdk.Pixbuf.from_file(name);
			return p;
		} catch (Error e) {
			stderr.printf ("Error loading single pixbuf: %s\n%s\n", name,e.message);
		}
		return null;
	}

	public static int load_all_pixbuf_in_path(HashTable<string, Gdk.Pixbuf> table, string path){
		try {
			//stdout.printf ("Loading %s\n",path);
			var directory = File.new_for_path (path);
			var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);
			FileInfo file_info;
			while ((file_info = enumerator.next_file ()) != null) {
				string name = file_info.get_name ();
				string new_name = name.replace(".png","");
				if(".png" in name && !table.contains(new_name)){
					var pixbuf = new Gdk.Pixbuf.from_file(path+"/"+name);
					table.insert(new_name,pixbuf);
					//stdout.printf ("\t%s\n", new_name);
				}
			}
		} catch (Error e) {
			stderr.printf ("Error loading pixbufs: %s\n%s\n", path,e.message);
			return 1;
		}
		//stdout.printf ("\tLoaded %5u pixbufs in %s\n", table.size(),path);
		return 0;
	}

}
