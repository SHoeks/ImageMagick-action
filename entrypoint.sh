#!/bin/sh -l
#cd $1
#mogrify -path . -auto-orient -thumbnail $2 *.*
cd /jpg/
for i in $(ls *.jpg); do
  echo $i
  w=$(identify -format "%w" $i)
  h=$(identify -format "%h" $i)
  if [[ $w > $h ]];then
     convert -quality 80 -resize 400 ${1%%.*}_400.webp
  else
     convert -quality 80 -resize x400 $i ${1%%.*}_400.webp
  fi
done



