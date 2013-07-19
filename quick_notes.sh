#!/bin/bash

FILENAME=$1 #"standup.txt"

#if file does not exist create it
if [ ! -f $FILENAME ]
then
    echo "creating file..."
    date +"%a %b %d %Y" >> $FILENAME
    echo "---" >> $FILENAME
fi

#is the file a week old?
PREV=$(grep -m 1 "Mon \|Tue \|Wed \|Thu \|Fri \|Sat \|Sun Jul" $FILENAME)
PREV_NOTE_DAY=$(date -j -f "%a %b %d %Y" "$PREV" "+%j")
PREV_NOTE_WEEK=$(date -j -f "%a %b %d %Y" "$PREV" "+%V")

NOW=$(date)
NEW_NOTE_DAY=$(date -j -f "%a %b %d %T %Z %Y" "$NOW" "+%j")
NEW_NOTE_WEEK=$(date -j -f "%a %b %d %T %Z %Y" "$NOW" "+%V")

DELTA_WEEK=$(($NEW_NOTE_WEEK-$PREV_NOTE_WEEK))
DELTA_DAY=$(($NEW_NOTE_DAY-$PREV_NOTE_DAY))

#if the file is older than 1 week we archive it and create a new one
if [ $DELTA_WEEK -gt 0 ]
then
    DELTA_DAY=0
    ARCHIVE_FILENAME=`date +"%b_%d_%Y_$FILENAME"` 
    #if the archive file exists we append to it, otherwise we create it and 
    #make a clean version of the active file
    if [ -f  $ARCHIVE_FILENAME ]
    then 
        echo "archive alredy exists."
        echo "appending contents of $FILENAME to archaive"
        cat $ARCHIVE_FILENAME $FILENAME > $ARCHIVE_FILENAME
    else    
        mv $FILENAME $ARCHIVE_FILENAME
        echo "archiving the $FILENAME"
        date +"%a %b %d %Y" >> $FILENAME
        echo "---" >> $FILENAME
    fi
fi

#if its a new day we create a new timestamp "heading" with day, month, year at 
#the top of the file (newest to oldest)
if [ $DELTA_DAY -gt 0 ]
then
    echo "it's a new day"
    echo "" | cat - $FILENAME > $FILENAME.tmp && mv $FILENAME.tmp $FILENAME
    echo "---" | cat - $FILENAME > $FILENAME.tmp && mv $FILENAME.tmp $FILENAME
    date +"%a %b %d %Y" | cat - $FILENAME > $FILENAME.tmp && mv $FILENAME.tmp $FILENAME
fi

#open file up and put cursor on line 2
# need to move curor to new line
#enable spell check with this command:
# :setlocal spell spelllang=en_us
vim +2 +":setlocal spell spelllang=en_us" $FILENAME

