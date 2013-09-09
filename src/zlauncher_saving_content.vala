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
public class  ZLauncher_saving_content: GLib.Object {

	ZLauncher launcher;

	DataOutputStream dos;

	public int x_tries = 20;
	public int y_tries = 60;
	
	
	public ZLauncher_saving_content (ZLauncher launcher) {
		this.launcher = launcher;
	}

	public void save_default_content_config(){
		save_content_config(launcher.zconfig_content);
	}

	public void save_content_config(string path){
		var file = File.new_for_path (path);
		try {
			if (file.query_exists ()) {
				file.delete ();
			}
			dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
			save_entries();
		} catch (Error e) {
			stderr.printf ("Cannot save config file:%s\n%s\n", path,e.message);
		}
	}

	public void save_entries() throws IOError {
		
		//syntax:
		//	[x,y]entry⋮style=2⋮icon=leaf3-26⋮text=text⋮cmd=
	
		for(int x = 0; x<x_tries;x++)
			for(int y = 0; y<y_tries;y++){
				Gtk.Widget widget = launcher.grid.get_child_at(x,y);
				if(widget == null)
					continue;
				ZLauncher_entry entry = (ZLauncher_entry)widget;
				int style = entry.entry_theme;
				string icon = entry.entry_icon;
				string text = entry.entry_text;
				string cmd = entry.entry_command;
				string line = "[%02d,%02d]entry⋮style=%d⋮icon=%s⋮text=%s⋮cmd=%s".printf(x,y,style,icon,text,cmd);
				write_line(line);
			}
			
	}
	
	public void write_line(string line) throws IOError {
		//print("writing line: %s\n",line);
		dos.put_string (line.concat("\n"));
	}



	public void reset_to_default_content_config(){
		reset_content_config(launcher.zconfig_content);
	}

	public void reset_content_config(string path){
		var file = File.new_for_path (path);
		try {
			if (file.query_exists ())
				file.delete ();
			dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
			reset_entries();
		} catch (Error e) {
			stderr.printf ("Cannot save config file:%s\n%s\n", path,e.message);
		} catch (IOError e) {
			stderr.printf ("Cannot save config file:%s\n%s\n", path,e.message);
		}
	}

	public void reset_entries() throws IOError {
		
	string line = """
	
[00,00]entry⋮style=0⋮icon=ok-26⋮text=Todo⋮cmd=geany /home/$USER/Texts/ToDo.txt
[00,01]entry⋮style=1⋮icon=⋮text=Primary⋮cmd=
[00,02]entry⋮style=2⋮icon=1_filled-26⋮text=do this⋮cmd=
[00,03]entry⋮style=2⋮icon=2_filled-26⋮text=do that⋮cmd=
[00,04]entry⋮style=2⋮icon=css-26⋮text=Website⋮cmd=
[00,05]entry⋮style=2⋮icon=server-26⋮text=Webserver⋮cmd=
[00,06]entry⋮style=1⋮icon=⋮text=Secondary⋮cmd=
[00,07]entry⋮style=2⋮icon=1_filled-26⋮text=do this⋮cmd=
[00,08]entry⋮style=2⋮icon=2_filled-26⋮text=do that⋮cmd=
[00,09]entry⋮style=2⋮icon=mysql-26⋮text=Database⋮cmd=
[00,10]entry⋮style=1⋮icon=⋮text=Tetriary⋮cmd=
[00,11]entry⋮style=2⋮icon=coins-26⋮text=Finance⋮cmd=
[00,12]entry⋮style=2⋮icon=ping_pong-26⋮text=Sport⋮cmd=
[00,13]entry⋮style=2⋮icon=mushroom_cloud-26⋮text=Art⋮cmd=
[01,00]entry⋮style=0⋮icon=graduation_cap-26⋮text=Courses⋮cmd=
[01,01]entry⋮style=1⋮icon=⋮text=Homework⋮cmd=
[01,02]entry⋮style=2⋮icon=approve-26⋮text=AI⋮cmd=
[01,03]entry⋮style=2⋮icon=test_tube-26⋮text=Chemistry⋮cmd=
[01,04]entry⋮style=2⋮icon=robot-26⋮text=Robotics⋮cmd=
[01,05]entry⋮style=2⋮icon=biotech-26⋮text=Biology⋮cmd=
[01,06]entry⋮style=2⋮icon=rocket-26⋮text=Rockets⋮cmd=
[01,07]entry⋮style=1⋮icon=⋮text=Timetable⋮cmd=geany /home/$USER/Texts/Timetable.txt
[01,08]entry⋮style=2⋮icon=moon-26⋮text=Wake up⋮cmd=
[01,09]entry⋮style=2⋮icon=administrator-26⋮text=Work⋮cmd=
[02,00]entry⋮style=0⋮icon=pencil-26⋮text=Texts⋮cmd=
[02,01]entry⋮style=1⋮icon=⋮text=User⋮cmd=echo $USER
[02,02]entry⋮style=2⋮icon=linux-26⋮text=Linux⋮cmd=geany /home/$USER/Texts/Linux.txt
[02,03]entry⋮style=2⋮icon=lol-26⋮text=Jokes⋮cmd=geany /home/$USER/Texts/Jokes.txt
[02,04]entry⋮style=2⋮icon=quote-26⋮text=Quotes⋮cmd=geany /home/$USER/Texts/Quotes.txt
[02,05]entry⋮style=2⋮icon=talk-26⋮text=Stories⋮cmd=geany /home/$USER/Texts/Stories.txt
[02,06]entry⋮style=1⋮icon=conference_call-26⋮text=Collaboration⋮cmd=
[02,07]entry⋮style=2⋮icon=hdd-26⋮text=Document 1⋮cmd=
[02,08]entry⋮style=2⋮icon=loudspeaker-26⋮text=Document 2⋮cmd=
[03,00]entry⋮style=0⋮icon=support-26⋮text=Config⋮cmd=
[03,01]entry⋮style=1⋮icon=⋮text=System⋮cmd=
[03,02]entry⋮style=2⋮icon=expand-26⋮text=xinitrc⋮cmd=geany ~/.xinitrc
[03,03]entry⋮style=2⋮icon=console-26⋮text=bashrc⋮cmd=geany ~/.bashrc
[03,04]entry⋮style=1⋮icon=⋮text=Openbox⋮cmd=
[03,05]entry⋮style=2⋮icon=plasmid-26⋮text=autostart⋮cmd=geany ~/.config/openbox/autostart.sh
[03,06]entry⋮style=2⋮icon=card_inserting-26⋮text=rc⋮cmd=geany ~/.config/openbox/rc.xml
[03,07]entry⋮style=2⋮icon=list-26⋮text=menu⋮cmd=geany ~/.config/openbox/menu.xml
[03,08]entry⋮style=1⋮icon=⋮text=Programs⋮cmd=
[03,09]entry⋮style=2⋮icon=line_width-26⋮text=tint2⋮cmd=geany ~/.config/tint2/tint2rc
[03,10]entry⋮style=2⋮icon=invoice-26⋮text=conky⋮cmd=geany ~/.conkyrc
[04,00]entry⋮style=0⋮icon=nas-26⋮text=Develop⋮cmd=
[04,01]entry⋮style=1⋮icon=⋮text=Scripts⋮cmd=
[04,02]entry⋮style=2⋮icon=monitor-26⋮text=desktop⋮cmd=
[04,03]entry⋮style=2⋮icon=resize-26⋮text=art-dl⋮cmd=
[04,04]entry⋮style=2⋮icon=refresh-26⋮text=backup⋮cmd=
[04,05]entry⋮style=1⋮icon=⋮text=Programs⋮cmd=
[04,06]entry⋮style=2⋮icon=paper_plane-26⋮text=ZLauncher⋮cmd=
[04,07]entry⋮style=1⋮icon=⋮text=Games⋮cmd=
[04,08]entry⋮style=2⋮icon=steam-26⋮text=Steam⋮cmd=
[05,00]entry⋮style=0⋮icon=joystick-26⋮text=Games⋮cmd=
[05,01]entry⋮style=2⋮icon=rounded_rectangle-26⋮text=General⋮cmd=
[05,02]entry⋮style=2⋮icon=coderwall-26⋮text=Board⋮cmd=
[05,03]entry⋮style=2⋮icon=climbing-26⋮text=Dexterity⋮cmd=
[05,04]entry⋮style=2⋮icon=gantt_chart-26⋮text=Tactics⋮cmd=
[05,05]entry⋮style=2⋮icon=globe-26⋮text=Strategy⋮cmd=
[05,06]entry⋮style=2⋮icon=hand_biceps-26⋮text=RPG⋮cmd=
[05,07]entry⋮style=2⋮icon=action-26⋮text=Fighting⋮cmd=
[05,08]entry⋮style=2⋮icon=gatling_gun-26⋮text=Shooter⋮cmd=
	
	""";
	write_line(line);
	}




}
