all:
		valac --pkg gtk+-3.0 --pkg gio-2.0 --thread --target-glib=2.36 *.vala -o zlauncher

clean:
		rm -rf *.o zlauncher

install:
		cp -f zlauncher /usr/bin

uninstall:
		rm -f /usr/bin/zlauncher



