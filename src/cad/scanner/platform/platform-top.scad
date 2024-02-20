use <../../utils/shapes/2d/rounded-square.scad>
use <../../utils/shapes/2d/squircle.scad>
use <../../utils/shapes/3d/chamfered-cylinder.scad>

module platform_top()
{
    difference()
    {
        chamfered_cylinder(15, 160, 160, 1);
        translate([ 0, 0, -1 ]) cylinder(h = 11, r = 155);
        difference()
        {
            cylinder(13, d = 230);
            translate([ 0, 0, -1 ]) cylinder(15, d = 200);
        }
    }
    for (i = [0:3])
        rotate(i * 90) translate([ 120.5, 0, 6 ]) chamfered_cylinder(8, 2.5, 2.5, 1);
}
