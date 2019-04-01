#!/bin/bash

# first, run auto mode to reload all available monitors
xrandr --auto

# retrieve all active screens
screens=$(xrandr --listmonitors | awk '{print $4}' | awk 'NF > 0')
n_screens=$(echo "$screens" | wc -l)

if [ "$n_screens" -eq 1 ]; then
    # if only 1 screen, then exit
    exit 0
fi

# then select screen to choose
screen=$(echo "$screens" | dmenu)


# select the remaining screens
remain_screens=$(echo "$screens" | sed "s/$screen//" | awk 'NF > 0')
n_remain=$(echo "$remain_screens" | wc -l)


# if only one screen remains, no choice for user
if [ "$n_remain" -eq 1 ]; then
    # if only 1 other screen
    reference_screen=$(echo "$remain_screens" | tr '\n' ' ')
else
    # choose reference screen
    reference_screen=$(echo "$remain_screens" | dmenu "ref screen:")
fi

position=$(echo "left-of
right-of
above
below
same-as
" | dmenu -p "$screen to $reference_screen")



cmd="xrandr --output $screen --$position $reference_screen"
eval $cmd
