#!/bin/sh -l

WebsitePath=$(dirname $0)
echo "Website path: "$WebsitePath
cd "$WebsitePath"
cd "images"

qlty=80
current_date=$(date +%Y_%m_%d_%H_%M)
exp_dir="exports_"$current_date
mkdir $exp_dir
mv *.jpg $exp_dir
cd $exp_dir
touch monochrom_tmp.js

echo "converting the following images for web:"
ls *.jpg
echo " "
for f in *\ *; do mv "$f" "${f// /_}"; done

# for i in $(ls *.jpg); do
#     #mogrify -auto-level $i
#     mogrify -contrast-stretch 0.5x0.05% "$i"

#     w=$(identify -format "%w" $i)
#     h=$(identify -format "%h" $i)
#     if [[ $h -gt $w ]];then
#         mogrify -rotate 90 $i
#         w2=$h; h2=$w
#     else
#         w2=$w; h2=$h
#     fi
#     ratio=$(echo "($w2/$h2)" | bc -l)
#     border_size_h=3
#     border_size_b=$(echo "($border_size_h*$ratio)" | bc)
#     new_height=$(echo "(3000/$ratio)" | bc)

#     echo "resizing to: 3000x"$new_height
#     mogrify -resize 3000x$new_height $i
#     mogrify -bordercolor 'rgb(248,248,248)' -border $border_size_h%x$border_size_b% $i
#     if [[ $h -gt $w ]];then
#         mogrify -rotate -90 $i
#     fi
# done 


n=$(ls *.jpg | wc -l); c=1
for i in $(ls *.jpg); do

    echo $c "/" $n ":" $i
    echo "{" >> monochrom_tmp.js
    echo "'id' : '${i%%.*}'," >> monochrom_tmp.js
    w=$(identify -format "%w" $i)
    h=$(identify -format "%h" $i)

    if [[ $w -gt $h ]];then

        # 2048w
        convert -quality $qlty -resize 2048 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_large' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'large_width' : '$w', 'large_height' : '$h'," >> monochrom_tmp.js
        
        # 1536w
        convert -quality $qlty -resize 1536 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_medium' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'medium_width' : '$w', 'medium_height' : '$h'," >> monochrom_tmp.js

        # 960w
        convert -quality $qlty -resize 960 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_small' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'small_width' : '$w', 'small_height' : '$h'," >> monochrom_tmp.js

        # 768w
        convert -quality $qlty -resize 768 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_tiny' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'tiny_width' : '$w', 'tiny_height' : '$h'," >> monochrom_tmp.js

        echo "'description' : 'Test gallery 2'," >> monochrom_tmp.js
        echo "'format' : 'landscape'," >> monochrom_tmp.js
        echo "}," >> monochrom_tmp.js

    else

        # 2048w
        convert -quality $qlty -resize x2048 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_large' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'large_width' : '$w', 'large_height' : '$h'," >> monochrom_tmp.js
        
        # 1536w
        convert -quality $qlty -resize x1536 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_medium' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'medium_width' : '$w', 'medium_height' : '$h'," >> monochrom_tmp.js

        # 960w
        convert -quality $qlty -resize x960 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_small' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'small_width' : '$w', 'small_height' : '$h'," >> monochrom_tmp.js

        # 768w
        convert -quality $qlty -resize x768 $i tmp.webp
        w=$(identify -format "%w" tmp.webp)
        h=$(identify -format "%h" tmp.webp)
        mv tmp.webp ${i%%.*}_$w"x"$h".webp"
        echo "'file_tiny' : '$exp_dir"/"${i%%.*}_$w"x"$h.webp'," >> monochrom_tmp.js
        echo "'tiny_width' : '$w', 'tiny_height' : '$h'," >> monochrom_tmp.js

        echo "'description' : 'Test gallery 2'," >> monochrom_tmp.js
        echo "'format' : 'portrait'," >> monochrom_tmp.js
        echo "}," >> monochrom_tmp.js

    fi

    rm $i
    let c=c+1 

done

lineNum="$(grep -n "new data gets automatically inserted above" ../../monochrom.js | head -n 1 | cut -d: -f1)"
let lineNum-=3
sed -i.bak "${lineNum}r monochrom_tmp.js" ../../monochrom.js
rm "monochrom_tmp.js"
cd ../../


