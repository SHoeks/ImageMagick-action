#!/bin/sh -l
#cd $1
#mogrify -path . -auto-orient -thumbnail $2 *.*

# dirs
jpg_dir="jpg/"
current_date=$(date +%Y_%m_%d_%H_%M)
exp_dir="exports_"$current_date

# cd to jpg dir and remove non jpg files
cd $jpg_dir
find . -type f ! -name '*.jpg' -delete
for i in $(ls *.jpg); do
    int=$RANDOM
    printf -v c_name "%04d" $c
    echo $i $c_name
    mv $i "img_"$c_name"_"$(date +%Y%m%d)"_"$int".jpg"
    let c=c+1
    sleep 0.1
done
sleep 1

# move psd to export dir
mkdir $exp_dir
mv *.jpg $exp_dir

# convert files
cd $exp_dir
for i in $(ls *.jpg); do
  echo $i
  w=$(identify -format "%w" $i)
  h=$(identify -format "%h" $i)
  
  if [[ $w -gt $h ]]; then
      convert -quality 90 -resize 400 ${i%%.*}.jpg ${i%%.*}_small.webp
      convert -quality 90 -resize 1000 ${i%%.*}.jpg ${i%%.*}_medium.webp
      convert -quality 90 -resize 1700 ${i%%.*}.jpg ${i%%.*}_large.webp
  else
      convert -quality 90 -resize 400 ${i%%.*}.jpg ${i%%.*}_small.webp
      convert -quality 90 -resize 600 ${i%%.*}.jpg ${i%%.*}_medium.webp
      convert -quality 90 -resize 1200 ${i%%.*}.jpg ${i%%.*}_large.webp
  fi  
  
done

# move webp files
mv *.webp ../../webp
find . -type f ! -name '*.jpg' -delete

# create data
touch new_data.js
for i in $(ls *.jpg); do
    w=$(identify -format "%w" $i)
    h=$(identify -format "%h" $i)

    # echo filename
    filename="${i%.*}"
    echo "$filename"

    if [[ $w -gt $h ]];then
        echo "{'file' : '$filename', 'description' : 'Untitled', 'format' : 'L'}," >> new_data.js
    else
        echo "{'file' : '$filename', 'description' : 'Untitled', 'format' : 'P'}," >> new_data.js
    fi
done

# add data to index
lineNum="$(grep -n "new data gets automatically inserted above" ../../index.html | head -n 1 | cut -d: -f1)"
let lineNum-=3
sed -i.bak "${lineNum}r new_data.js" ../../index.html


