#!/usr/bin/env bash
#
# beautify - simple script to work with Pandoc (my_doc)
#
# INFMT     - file format of the input files. Eg: markdown
# INEXT     - file extension (without the ".") of the input files. Eg: md
# OUTFMT    - file format of the output files. Eg: html
# OUTEXT    - file extension (without the ".") of the output files. Eg: html
# CSSFILE   - name of the style-sheet to use with its path. Eg: ~/pandoc.css
#
# This script uses all files inside the current directory with names ending
# with the file extension $INEXT to generate files of format $OUTFMT with
# respective file names and the extension $OUTEXT, styled with the stylesheet
# $CSSFILE.
#
# Eg:   If a directory contains the files:
#           file1.md        file2.md        file3.md
#       then, specifying the values INFMT="markdown", INEXT="md",
#       OUTFMT="html", OUTEXT="html", CSSFILE="./pandoc.css" and
#       running this script will generate the files:
#           file1.html      file2.html      file3.html
#       with the styling specified in the pandoc.css file.
#
# Dependencies: requires the 'pandoc' command to be in the $PATH
#

INFMT="markdown"
INEXT="md"
OUTFMT="html"
OUTEXT="html"
CSSFILE="pandoc.css"

for INFILE in $(ls *.$INEXT)
do
    pandoc ./$INFILE -r $INFMT -w $OUTFMT -c $CSSFILE -o ./${INFILE%.*}.$OUTEXT
    echo "Using file: $INFILE to generate file: ${INFILE%.*}.$OUTEXT"
done
