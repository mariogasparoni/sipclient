#!/bin/bash
#Connect a sip user with audio/video in the given conferences.
#usage:
#   ./run-sipclients.sh <SERVER> <ROOM_ID> <NUMBER_OF_INSTANCES> <VIDEO_FILE1>
#     <VIDEO_FILE2> ...
#
#   where SERVER is the server's address/hostname and  ROOM_ID is a
#   the remote use, NUMBER_OF_INSTANCES is the number of running instances and
#   VIDEO_FILE1, VIDEO_FILE2, ... is the path to a video file to be used as
#   input.

SIP_CLIENT_PATH=`dirname $0`/../sipclient.py
SERVER=$1
ROOM_ID=$2
NUMBER_OF_INSTANCES=$3
DELAY=1
SLEEP_TIME=$DELAY
SERVER_PORT=5060

trap 'kill -2 $(jobs -p);exit' INT

if test $3 -le 0
then
  echo "Error: number of instances must be greater than 0 ...";
  exit 1
fi

if test -z "$4"
then
    echo "Error: you must specify at least one video file ..."
    exit 1
fi

shift 3;

for INPUT_FILE in "$@"
do
  if ! test -e "$INPUT_FILE"
  then
      echo "Error: File \"$INPUT_FILE\" not found ..."
      exit 1
  fi
done

files_number=$#;
files_counter=1;
i=0;

for i in `seq $NUMBER_OF_INSTANCES`
do
    INPUT_FILE=${!files_counter};

    if test $files_counter -ge $files_number
    then
      files_counter=1
    else
      files_counter=$((files_counter+1))
    fi

    (sleep $SLEEP_TIME;$SIP_CLIENT_PATH $SERVER $SERVER_PORT $ROOM_ID "sip-client-$i" $INPUT_FILE) &
    SLEEP_TIME=$(($SLEEP_TIME+$DELAY))
done
wait
