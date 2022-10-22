#!/bin/sh -l
#cd $1
#mogrify -path . -auto-orient -thumbnail $2 *.*
cd jpg/
for i in $(ls *.jpg); do
  echo $i
  w=$(identify -format "%w" $i)
  h=$(identify -format "%h" $i)
  cp $i ${i%%.*}_400.jpg
  if [[ $w > $h ]];then
     mogrify -format webp -quality 80 -resize 400 ${i%%.*}_400.jpg
  else
     mogrify -format webp -quality 80 -resize x400 ${i%%.*}_400.jpg
  fi
done



