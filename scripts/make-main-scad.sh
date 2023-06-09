#!/bin/sh

target=src/cad/main.scad
components=src/cad/components/*.scad
parts=src/cad/parts/*.scad

echo > $target

for f in $components; do
    echo "use <components/$(basename $f)>" >> $target
done

for f in $parts; do
    echo "use <parts/$(basename $f)>" >> $target
done

echo "use <assembly.scad>" >> $target
echo >> $target
echo -n "part = \"assembly\"; // [assembly" >> $target

for f in $components; do
    echo -n ", $(basename $f .scad)" >> $target
done

for f in $parts; do
    echo -n ", $(basename $f .scad)" >> $target
done

echo ] >> $target
echo >> $target
echo "if (part == \"assembly\") assembly();" >> $target

for f in $components; do
    echo "if (part == \"$(basename $f .scad)\") $(basename $f .scad | sed 's/-/_/g')();" >> $target
done

for f in $parts; do
    echo "if (part == \"$(basename $f .scad)\") $(basename $f .scad | sed 's/-/_/g')();" >> $target
done
