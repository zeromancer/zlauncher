all:
		valac --pkg gtk+-3.0 --pkg gio-2.0 --thread --target-glib=2.36 src/*.vala -o zlauncher

clean:
		rm -rf *.o zlauncher

install:
		cp -f zlauncher /usr/bin
		mkdir -p /usr/share/icons/win8/
		cp -r example-icons-dark/* /usr/share/icons/win8/
		cp logo/zlauncher-256.png /usr/share/pixmaps/zlauncher.png

uninstall:
		rm -f /usr/bin/zlauncher
		rm -rf /usr/share/icons/win8/
		rm -f /usr/share/pixmaps/zlauncher.png
