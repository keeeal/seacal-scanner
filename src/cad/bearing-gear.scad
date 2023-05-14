// clang-format off
use <utils/gears/simple.scad>
use <utils/gears/herringbone.scad>

$fn = 32;
// clang-format on

module bearing_gear()
{
    difference()
    {
        linear_extrude(12) difference()
        {
            circle(d = 225);
            circle(d = 156);
        }
        difference()
        {
            translate([ 0, 0, -0.25 ]) herringbone_gear(10.5, teeth = 140, twist = 32);
            translate([ 0, 0, -1 ]) cylinder(12, r = 80);
        }

        for (i = [0:3])
            rotate([ 0, 0, i * 90 ])
            {
                translate([ 108, 0, -1 ]) cylinder(100, d = 5);
                translate([ 108, 0, -1 ]) rotate([ 0, 0, 30 ]) cylinder(11, d = 8, $fn = 6);
            }
    }
}
