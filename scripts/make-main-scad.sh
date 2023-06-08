target=src/cad/main.scad
source=(src/cad/parts/*.scad)

echo > $target

for f in ${source[@]}
do
    echo "use <parts/$(basename $f)>" >> $target
done

echo >> $target
echo -n "part = \"assembly\"; // [" >> $target

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
