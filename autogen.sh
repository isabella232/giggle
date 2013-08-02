#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd $srcdir

AUTORECONF=`which autoreconf`
if test -z $AUTORECONF; then
        echo "*** No autoreconf found, please intall it ***"
        exit 1
fi

GNOMEDOC=`which yelp-build`
if test -z $GNOMEDOC; then
        echo "*** The tools to build the documentation are not found,"
        echo "    please intall the yelp-tools package ***"
        exit 1
fi

autoreconf --force --install --verbose || exit $?

cd $olddir
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
