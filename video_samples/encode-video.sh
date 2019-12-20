#!/bin/bash
INPUT=$1
OUTPUT=$2

ffmpeg -i $INPUT -vcodec libx264 -b:v 1024k -preset ultrafast -g 60 -profile:v baseline -level 3.1 $OUTPUT
