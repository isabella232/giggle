gladedir = $(datadir)/giggle/glade
dist_glade_DATA = \
	main-window.ui

desktopdir=$(datadir)/applications
desktop_DATA=org.gnome.Giggle.desktop

org.gnome.Giggle.desktop.in: org.gnome.Giggle.desktop.in.in
	$(AM_V_GEN) $(MSGFMT) --desktop --template $< -d $(top_srcdir)/po -o $@

org.gnome.Giggle.desktop: org.gnome.Giggle.desktop.in
	$(AM_V_GEN) sed -e 's|@bindir[@]|$(bindir)|g' $< > $@


appdatadir = $(datadir)/appdata
appdata_DATA = giggle.appdata.xml


CLEANFILES = \
	$(desktop_DATA)

EXTRA_DIST= \
	org.gnome.Giggle.desktop.in.in \
	org.gnome.Giggle.desktop.in \
	$(appdata_DATA)

MAINTAINERCLEANFILES = org.gnome.Giggle.desktop.in
