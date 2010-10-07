#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.
(
  cd "$srcdir" &&
  gnome-doc-prepare --automake --copy --force &&
  autopoint --force &&
  AUTOPOINT='intltoolize --automake --copy' autoreconf --force --install
) || exit
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
