dnl Process this file with autoconf to produce a configure script.
AC_PREREQ([2.64])
AC_INIT([Giggle],
        [0.7],
        [http://bugzilla.gnome.org/enter_bug.cgi?product=giggle],
        [giggle],
        [http://live.gnome.org/giggle])

AC_CONFIG_HEADERS([config.h])
AC_CONFIG_SRCDIR([configure.ac])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build-aux])

AM_INIT_AUTOMAKE([1.11 check-news -Wall tar-ustar no-dist-gzip dist-xz])
# Support silent build rules, requires at least automake-1.11. Disable
# by either passing --disable-silent-rules to configure or passing V=1
# to make
AM_SILENT_RULES([yes])

# Check for programs
AC_PROG_CC
AC_PROG_CC_C_O
AC_PROG_CC_C99
gl_EARLY

# For gnulib.
gl_INIT

# Initialize libtool
LT_PREREQ([2.2.6])
LT_INIT([disable-static win32-dll])

# Checks for header files.
AC_CHECK_HEADERS([fcntl.h locale.h stdlib.h string.h unistd.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_INLINE

# Checks for library functions.
AC_FUNC_MKTIME
AC_CHECK_FUNCS([localtime_r setlocale strchr strrchr strstr])


AC_PATH_PROG(GLIB_MKENUMS, glib-mkenums)

AC_SUBST([LIBGIGGLE_ABI],     [0:0:0])
AC_SUBST([LIBGIGGLE_GIT_ABI], [0:0:0])


dnl  ------------------
dnl | Pkgconfig checks |---------------------------------------
dnl  ------------------

GLIB_REQUIRED_VERSION=2.30
GDK_PIXBUF_REQUIRED_VERSION=2.22
GTK_REQUIRED_VERSION=3.3.12
GTKSOURCE_REQUIRED_VERSION=3.0
EDS_REQUIRED_VERSION=3.2
VTE_REQUIRED_VERSION=0.28


PKG_CHECK_MODULES(GIGGLE, [
        gio-2.0           >= $GLIB_REQUIRED_VERSION
        glib-2.0          >= $GLIB_REQUIRED_VERSION
        gmodule-2.0       >= $GLIB_REQUIRED_VERSION
        gthread-2.0       >= $GLIB_REQUIRED_VERSION
        gdk-pixbuf-2.0    >= $GDK_PIXBUF_REQUIRED_VERSION
        gdk-3.0           >= $GTK_REQUIRED_VERSION
        gtk+-3.0          >= $GTK_REQUIRED_VERSION
        gtksourceview-3.0 >= $GTKSOURCE_REQUIRED_VERSION
])

dnl  -----------------------
dnl | Evolution Data Server |-----------------------------------
dnl  -----------------------

AC_ARG_ENABLE([evolution-data-server],
              [AS_HELP_STRING([--enable-evolution-data-server=@<:@yes/no@:>@],
                              [Enable features using Evolution Data Server (default=check)])],
              [enable_evolution_data_server=$enableval],
              [enable_evolution_data_server=check])

AS_IF([test "x$enable_evolution_data_server" != xno],
      [
        PKG_CHECK_MODULES([EBOOK],
                          [libebook-1.2 >= $EDS_REQUIRED_VERSION],
                          [have_evolution_data_server=yes
                           AC_DEFINE([HAVE_EDS], [1],
                                     [Use features from libebook])
                          ],
                          [have_evolution_data_server=no
                           AS_IF([test "x$enable_evolution_data_server" != xcheck],
                                 [AC_MSG_FAILURE([--enable-evolution-data-server was given, but libebook-1.2 was not found])])
                          ])
      ])

AM_CONDITIONAL([USE_EDS], [test "$have_evolution_data_server" = "yes"])

dnl  ------------------
dnl | terminal support |-----------------------------------
dnl  ------------------

AC_ARG_ENABLE([terminal],
              [AS_HELP_STRING([--enable-terminal=@<:@yes/no@:>@],
                              [Enable features using vte terminal widget (default=yes)])],
              [enable_terminal=$enableval],
              [enable_terminal=yes])

AS_IF([test "x$enable_terminal" = "xyes"],
      [
        PKG_CHECK_MODULES([VTE],
                          [vte-2.90 >= $VTE_REQUIRED_VERSION],
                          [have_vte=yes
                           AC_DEFINE([HAVE_VTE], [1],
                                     [Use features from vte])
                          ],
                          [have_vte=no])
      ])

AM_CONDITIONAL([USE_VTE], [test "x$have_vte" = "xyes"])

dnl  ----------------------
dnl | library requirements |-----------------------------------
dnl  ----------------------

AC_DEFINE(_GNU_SOURCE, 1, [Enable GNU Extensions])

dnl Make sure that strptime can be used (read: has gnu extensions)
AC_MSG_CHECKING([for GNU extensions of strptime()])
AC_RUN_IFELSE(
  [AC_LANG_PROGRAM(
    [[#include <time.h>]],
    [[const char* date = "1168635922 +0100"; struct tm tm;
      char const* returned = strptime(date, "%s %z", &tm);
      return (!returned || *returned ? 1 : 0);]])],
  [AC_MSG_RESULT(available)
   AC_DEFINE([STRPTIME_HAS_GNU], [1],
             [strptime() has GNU extensions %s and %z])],
  [AC_MSG_RESULT(not available)])

dnl Figure out which format string to use for time_t
AC_MSG_CHECKING([size of time_t type])
AC_RUN_IFELSE(
  [AC_LANG_PROGRAM(
    [[#include <time.h>]],
    [[return (sizeof (time_t) == sizeof (long) ? 0 : 1);]])],
  [AC_MSG_RESULT(long)
   AC_DEFINE([GIGGLE_FORMAT_TIME_T], ["ld"], [format string for time_t])],
  [AC_MSG_RESULT(int)
   AC_DEFINE([GIGGLE_FORMAT_TIME_T], ["d"], [format string for time_t])])

dnl  ------------------
dnl | Language Support |---------------------------------------
dnl  ------------------
IT_PROG_INTLTOOL([0.41.0])

AM_GNU_GETTEXT_VERSION([0.18.1])
AM_GNU_GETTEXT([external])

AC_SUBST([GETTEXT_PACKAGE], [giggle])
AC_DEFINE([GETTEXT_PACKAGE], [PACKAGE_TARNAME],[Define to the gettext package name])

dnl  -------------
dnl | User Manual |---------------------------------------
dnl  -------------
YELP_HELP_INIT

dnl  -----------------------
dnl | GIT command detection |----------------------------------
dnl  -----------------------
AC_ARG_WITH([git-command],
            [AS_HELP_STRING([--with-git-command=PATH], [path to git command])])
GIT_COMMAND=$with_git_command

if test x"$GIT_COMMAND" = x; then
  AC_PATH_PROG(GIT_COMMAND, git, [no])
else
  if ! test -x "$GIT_COMMAND"; then
    GIT_COMMAND=no
  fi
fi

if test "$GIT_COMMAND" = no; then
  AC_MSG_ERROR([git command not found in path])
else
  AC_SUBST(GIT_COMMAND)
  AC_DEFINE_UNQUOTED(GIT_COMMAND,"$GIT_COMMAND",[GIT command path])
fi

dnl ---------------------------------------------------------------------------
dnl - Enable strict warnings (-Werror) (disabled by default)
dnl ---------------------------------------------------------------------------
AC_ARG_ENABLE([strict],
              [AS_HELP_STRING([--enable-strict],
                              [Enable strict compilation warnings '-Werror'])])
AS_IF([test "x$enable_strict" = "xyes"],
      [CPPFLAGS="$CPPFLAGS -Werror"])

dnl ---------------------------------------------------------------------------
dnl - Extra verbose warning switches
dnl ---------------------------------------------------------------------------

gl_MANYWARN_ALL_GCC([warnings])
# Set up the list of the pointless, undesired warnings.
nw=
nw="$nw -Wsystem-headers"       # Don't let system headers trigger warnings
nw="$nw -Wundef"                # All compiler preprocessors support #if UNDEF
nw="$nw -Wtraditional"          # All compilers nowadays support ANSI C
nw="$nw -Wtraditional-conversion"
nw="$nw -Wpadded"               # Happy for compiler to add struct padding
nw="$nw -Wconversion"           # These warnings usually don't point to mistakes.
nw="$nw -Wsign-conversion"      # Likewise.
nw="$nw -Wc++-compat"           # Don't care about C++ compiler compat

# Enable all GCC warnings not in this list.
gl_MANYWARN_COMPLEMENT([warnings], [$warnings], [$nw])
for w in $warnings; do
  gl_WARN_ADD([$w])
done

gl_WARN_ADD([-Wno-unused-parameter]) # Too many warnings for now

dnl -----------------------------------------------------------


AC_CONFIG_FILES([
        Makefile
        data/Makefile
        help/Makefile
        libgiggle/Makefile
        libgiggle-git/Makefile
        pixmaps/Makefile
        plugins/Makefile
        po/Makefile.in
        src/Makefile
        test/Makefile
])

AC_OUTPUT

echo
echo "Prefix:                    $prefix"
echo "datadir:                   ${datadir}"
echo "CFLAGS:                    ${CFLAGS}"
echo "GIT command path:          $GIT_COMMAND"
echo "Use Evolution Data Server: $have_evolution_data_server"
echo "Use VTE terminal widget:   $have_vte"
echo
