#!/bin/zsh -l
#cd $1
#mogrify -path . -auto-orient -thumbnail $2 *.*
cd jpg/
find . -type f ! -name '*.jpg' -delete

for i in $(ls *.jpg); do
  echo $i
  
  w=$(identify -format "%w" $i)
  h=$(identify -format "%h" $i)
  
  
  if [[ $w > $h ]]; then
      convert -quality 80 -resize 300x200\! ${i%%.*}.jpg ${i%%.*}_300x200.webp
  else
      convert -quality 80 -resize 200x300\! ${i%%.*}.jpg ${i%%.*}_200x300.webp
  fi  
  
done

mv *.webp ../webp

find . -type f ! -name '*.jpg' -delete




