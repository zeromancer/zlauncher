all:
		valac --pkg gtk+-3.0 --pkg gio-2.0 --thread --target-glib=2.36 src/*.vala -o zlauncher

clean:
		rm -rf *.o zlauncher

install:
		test -z "$(DESTDIR)$(PREFIX)/bin" || mkdir -p "$(DESTDIR)$(PREFIX)/bin";
		cp -a -f zlauncher $(DESTDIR)$(PREFIX)/bin
		test -z "$(DESTDIR)$(PREFIX)/share/icons/win8/" || mkdir -p $(DESTDIR)$(PREFIX)/share/icons/win8/
		cp -a -r example-icons-dark/* $(DESTDIR)$(PREFIX)/share/icons/win8/
		cp -a logo/zlauncher-256.png $(DESTDIR)$(PREFIX)/share/pixmaps/zlauncher.png
		test -z "$(DESTDIR)$(PREFIX)/share/applications" || mkdir -p "$(DESTDIR)$(PREFIX)/share/applications"
		cp -a dist/zlauncher.desktop $(DESTDIR)$(PREFIX)/share/applications/
		
uninstall:
		rm -f $(DESTDIR)$(PREFIX)/bin/zlauncher
		rm -rf $(DESTDIR)$(PREFIX)/share/icons/win8/
		rm -f $(DESTDIR)$(PREFIX)/share/pixmaps/zlauncher.png
		rm -f $(DESTDIR)$(PREFIX)/share/applications/zlauncher.desktop
