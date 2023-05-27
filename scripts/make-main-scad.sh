target=src/cad/__main__.scad
source=(src/cad/*.scad)

echo > $target

for f in ${source[@]}
do
    echo "use <$(basename $f)>" >> $target
done

echo >> $target
echo -n "part=\"__assembly__\"; // [" >> $target

for f in ${source[@]}
do
    echo -n "$(basename $f .scad), " >> $target
done

sed -i '$ s/..$//' $target
echo ] >> $target
echo >> $target

for f in ${source[@]}
do
    echo "if (part == \"$(basename $f .scad)\") $(basename $f .scad | sed 's/-/_/g')();" >> $target
done
