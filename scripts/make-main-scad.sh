#!/bin/sh

output=$(dirname $1)/main.scad

echo "\$fn = 32;  // [16:128]" > $output
echo >> $output

find $1 -type f -name "*.scad" -printf "%P\n" | while read -r file; do
    echo "use <$(basename $1)/$file>" >> $output
done

echo >> $output
echo -n "part = \"$(basename $1)\"; // [" >> $output

find $1 -type f -name "*.scad" | while read -r file; do
    if [ $(basename $file .scad) = "__subassembly__" ]; then
        part=$(basename $(dirname $file))
    else
        part=$(basename $file .scad)
    fi
    echo -n "$part, " >> $output
done

sed -i '$ s/..$//' $output
echo ] >> $output
echo >> $output

find $1 -type f -name "*.scad" | while read -r file; do
    if [ $(basename $file .scad) = "__subassembly__" ]; then
        part=$(basename $(dirname $file))
    else
        part=$(basename $file .scad)
    fi
    echo "if (part == \"$part\") $(echo $part | sed 's/-/_/g')();" >> $output
done
