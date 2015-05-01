#!/bin/sh

# directory entry is same order as sorted filename
# .* file is moved under .t directory
# ToDo .? file/directory is not changed

unset LANG

resortDir () {
(
    cd "$1" || exit -1
    echo Enter: `pwd`
    mkdir .t
#    mv * .??* .t
    set    *; if [ "$1" !=    "*" ] ; then mv    * .t ; fi
    set .??*; if [ "$1" != ".??*" ] ; then mv .??* .t ; fi

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
	    dir=`basename "$i"`
	    resortDir "$dir"
	fi
    done

    rmdir .t >/dev/null 2>&1 
    if [ -d .t -a -d ../.t ] ; then
	updir=`basename $PWD`
	mv .t ../.t/..$updir
    fi
)
}

for i in  "$@"; do
    resortDir "$i"
done
