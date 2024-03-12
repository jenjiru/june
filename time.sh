#!/bin/bash

format_time() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

clear
cat <<'END'

     .--.
    |o_o |
    |:_/ |
   //   \ \
  (|     | )
 /'|_   _/'\
 \___)=(___/

END
echo " Rice took"
echo " $(format_time $SECONDS)"
sleep 10
