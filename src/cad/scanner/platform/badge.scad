use <../../utils/shapes/2d/rounded-square.scad>

$fn = 32;

module badge()
{
    linear_extrude(2) text("S  E  A  C  A  L", halign = "center", valign = "center");
    difference()
    {
        linear_extrude(2) rounded_square([ 103.2, 23.2 ], r = 5.6, center = true);
        translate([ 0, 0, 1.6 ]) linear_extrude(2) rounded_square([ 100, 20 ], r = 4, center = true);
    }
}
