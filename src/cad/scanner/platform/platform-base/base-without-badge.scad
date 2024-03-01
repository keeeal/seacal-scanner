use <../../../utils/shapes/2d/rounded-square.scad>
use <../../../utils/shapes/2d/squircle.scad>
use <../../../utils/shapes/3d/chamfered-cylinder.scad>

module base_without_badge()
{
    difference()
    {
        union()
        {
            difference()
            {
                chamfered_cylinder(60, 160, 160, 1);
                translate([ 0, 0, -1 ]) cylinder(h = 59, r = 150);
                translate([ 0, 0, 57 ]) cylinder(h = 4, r = 115);
            }
            translate([ 91, 0, 0 ]) difference()
            {
                translate([ 19, 0, 0 ]) linear_extrude(45) rounded_square([ 85, 47 ], r = 7, center = true);
                translate([ 50, 0, -2 ]) linear_extrude(45) rounded_square([ 143, 43 ], r = 5, center = true);
                translate([ 0, 0, -1 ]) cylinder(100, r = 12);
                for (i = [ 0, 1, 2, 3 ])
                    rotate(i * 90) translate([ 31.04 / 2, 31.04 / 2, 0 ]) cylinder(100, d = 4);
            }
            for (i = [0:3])
                rotate(i * 120) translate([ -140, 0, -3 ]) chamfered_cylinder(62, 15, 15, 1);
        }
        for (i = [0:3])
            rotate(i * 90) translate([ 85, 85, 0 ]) cylinder(100, d = 5);
    }
}
