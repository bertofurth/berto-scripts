#!/bin/bash
#
# This script converts the contents of the
# pdf files in a given directory to ocr text
# using the tesseract ocr tool.
#
# The script will automatically skip files
# that have already been converted
#
# TODO - Doesn't handle spaces in filenames properly

small_usage()
{
    echo "Usage: $0 <directory>"
}

SCANDIR=$1

if [[ $# -ne 1 ]]; then
    small_usage
    exit 1
fi


command -v tesseract > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Error: Can't find tesseract tool! Exiting."
    exit 1
fi

command -v pdftoppm > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Error: Can't find pdftoppm tool! Exiting."
    exit 1
fi

if [[ ! -d $SCANDIR ]]; then
    echo "Error: Can't find specified scan directory $SCANDIR Exiting."
    exit 1
fi

for pdffile in $(ls $SCANDIR/*.pdf) ; do
    echo "Processing $pdffile"
    filebase=$(basename "$pdffile" .pdf)
    if [[ -e $SCANDIR/$filebase.txt ]]; then
	# Generated text file already exists! Skip!
	echo $SCANDIR/$filebase.txt exists. Skipping.
	continue
    fi
    echo "Filebase is $filebase"
    TEMPFILE=/tmp/DELETE-ME-$filebase-$(date +%Y.%m%d.%H%M%S%N)-TEMP

    # Convert the given pdf to an image file
    pdftoppm -r 300 -png -forcenum $pdffile $TEMPFILE
    if [[ $? -ne 0 ]]; then
	echo "Failed to convert $pdffile to image file. Skipping!"
	rm -f $TEMPFILE*.png
	continue
    fi

    # Convert the temporary image files to text files
    for pngfile in $(ls $TEMPFILE*.png); do
	tesseract $pngfile - >> $SCANDIR/$filebase.txt
    done

    echo "Converted $SCANDIR/$pdffile to $filebase.txt"
    rm -f $TEMPFILE*.png
done
