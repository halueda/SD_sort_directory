#!/bin/sh

# Usage: SD-sort.sh [directory...]
#   SD-sort.sh makes directory entry as same order as sorted filename.
#   Directory name is recommended to use absolute path rather than relative path,
#   because this command drastically change whole sub directories.
#
# .* file is moved under .t directory
# ToDo:  .? file/directory should be moved under .t directory as well
# 
# ファイルの glob は、LANG=ja_JPとかだとうまくいかない。また、中で設定してもshell自身のglobには反映しない。
# execで呼びなおすことにした。
# 
#TOBELANG=ja_JP.utf8
#TOBELANG=POSIX
TOBELANG=C

if [ x"$LANG" != x"$TOBELANG" ]; then
    echo 'Rerun:  LANG='"$TOBELANG" "$0" "$@"
    export LANG="$TOBELANG"
    exec $0 "$@"
fi

resortDir () {
(
    cd "$1" || exit -1
    echo Enter: `pwd`
    mkdir .t
#    mv * .??* .t
    echo "  move    '*' to  .t"
    set    *; if [ "$1" !=    "*" ] ; then mv "$@" .t ; fi
    echo "  move '.??*' to  .t"
    set .??*; if [ "$1" != ".??*" ] ; then mv "$@" .t ; fi

    echo "  move back from  .t"

    for i in .t/*; do
	if [ -f "$i" ]; then
	    mv "$i" .
#	    ls -f .
	fi
    done

    for i in .t/*; do
	if [ -d "$i" ]; then
	    mv "$i" .
#	    ls -f .
	    dir=$(basename "$i")
	    resortDir "$dir"
	fi
    done

    rmdir .t >/dev/null 2>&1 
    if [ -d .t -a -d ../.t ] ; then
	updir=`basename $PWD`
	mv .t ../.t/$updir
    fi
)
}

for i in  "$@"; do
    resortDir "$i"
done

