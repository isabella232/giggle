gladedir = $(datadir)/giggle/glade
dist_glade_DATA = \
	main-window.ui

desktopdir=$(datadir)/applications
desktop_DATA=giggle.desktop

giggle.desktop.in: giggle.desktop.in.in
	$(AM_V_GEN) $(MSGFMT) --desktop --template $< -d $(top_srcdir)/po -o $@

giggle.desktop: giggle.desktop.in
	$(AM_V_GEN) sed -e 's|@bindir[@]|$(bindir)|g' $< > $@


appdatadir = $(datadir)/appdata
appdata_DATA = giggle.appdata.xml


CLEANFILES = \
	$(desktop_DATA)

EXTRA_DIST= \
	giggle.desktop.in.in \
	giggle.desktop.in \
	$(appdata_DATA)

MAINTAINERCLEANFILES = giggle.desktop.in
