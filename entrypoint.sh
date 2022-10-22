#!/bin/sh -l
#cd $1
#mogrify -path . -auto-orient -thumbnail $2 *.*
cd jpg/
find . -type f ! -name '*.jpg' -delete

for i in $(ls *.jpg); do
  echo $i
  w=$(identify -format "%w" $i)
  h=$(identify -format "%h" $i)
  cp $i ${i%%.*}_400.jpg
  mogrify -format webp -quality 80 -resize "^400>" ${i%%.*}_400.jpg
done

find . -type f ! -name '*.jpg' -delete




