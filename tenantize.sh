#!/bin/bash
#
# tenantize - a script to populate test session files (tc_aura)
#
# Usage: $ tenantize TENANT_COUNT HOST_COUNT
#
#       TENANT_COUNT    - the number of tenants in the test sequence
#       HOST_COUNT      - the number of hosts in the test setup
#
# A quick and dirty (and ugly) fix of a script that uses following:
#       TEMPLATE (file) - header part of the output files,
#       INFILE (file)   - session block template (per tenant),
#       PATTERN         - pattern to be replaced in session block
#       TBASENAME       - name pattern to be used for tenants
#       FBASENAME       - name pattern to be used for output files
#       EXT             - file extension of the output files
# to generate HOST_COUNT number of sequential session playback files
# where the TENANT_COUNT number of session blocks are divided amongst.
#
# TODO: cleanup the repetitive logic
#

ARGS=2
E_BADARGS=65

if [ $# -ne $ARGS ] ; then
    echo "Usage: `basename $0` TENANT_COUNT HOST_COUNT"
    echo "dependencies: bash, bc"
    exit $E_BADARGS
fi

TEMPLATE="./template.xml"
FBASENAME="tsung"
PATTERN="cube0"
TBASENAME="cube"
EXT="xml"
INFILE="./session.xml"

TCOUNT=`echo "sqrt($1^2)" | bc`
HCOUNT=`echo "sqrt($2^2)" | bc`

if [ `echo "$TCOUNT < $HCOUNT" | bc` == 1 ]; then
    echo "HOST_COUNT cannot be larger than TENANT_COUNT"
    exit $E_BADARGS
fi

if [ $TCOUNT != 0 ] && [ $HCOUNT != 0 ]; then
    DIVS=`expr $TCOUNT / $HCOUNT`
    MODS=`expr $TCOUNT % $HCOUNT`
else
    echo "TENANT_COUNT or HOST_COUNT cannot be 0"
    exit $E_BADARGS
fi

if [ $MODS != 0 ]; then
    FCOUNT=`expr $HCOUNT - 1`
    CHUNK=`echo "$DIVS + 1" | bc`

    OUTFILE="${FBASENAME}_${HCOUNT}.${EXT}"
    cp $TEMPLATE ./$OUTFILE
    LCHUNK=`echo "($FCOUNT * $CHUNK) + 1" | bc`
    echo "Writing file... $OUTFILE"
    while [ $LCHUNK -le $TCOUNT ]
    do
        TENANT="$TBASENAME$LCHUNK"
        sed -e "s/$PATTERN/$TENANT/g" $INFILE >> ./$OUTFILE
        LCHUNK=`echo "$LCHUNK+1" | bc`
    done
else
    FCOUNT=$HCOUNT
    CHUNK=$DIVS
fi

for (( f=1; f<=$FCOUNT; f++ )) do
    OUTFILE="${FBASENAME}_$f.${EXT}"
    cp $TEMPLATE ./$OUTFILE
    A=`echo "$f - 1" | bc`
    LCHUNK=`echo "($A * $CHUNK) + 1" | bc`
    ULIMIT=`echo "($f * $CHUNK)" | bc`
    echo "Writing file... $OUTFILE"
    while [ $LCHUNK -le $ULIMIT ]
    do
        TENANT="$TBASENAME$LCHUNK"
        sed -e "s/$PATTERN/$TENANT/g" $INFILE >> ./$OUTFILE
        LCHUNK=`echo "$LCHUNK+1" | bc`
    done
    echo "" >> $OUTFILE
    echo "</sessions>" >> $OUTFILE
    echo "</tsung>" >> $OUTFILE
done
