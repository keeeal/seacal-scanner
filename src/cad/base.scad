// clang-format off
use <utils/shapes/2d/rounded-square.scad>
use <utils/shapes/2d/squircle.scad>

$fn = 32;
// clang-format on

module base()
{
    difference()
    {
        union()
        {
            difference()
            {
                hull()
                {
                    translate([ 0, 0, 59 ]) linear_extrude(1) circle(r = 140);
                    linear_extrude(2) squircle(r = 160);
                }
                hull()
                {
                    translate([ 0, 0, 57 ]) linear_extrude(1) circle(r = 115);
                    translate([ 0, 0, -1 ]) linear_extrude(2) squircle(r = 130);
                }
                translate([ 0, 0, 57 ]) linear_extrude(4) circle(r = 115);
            }
            translate([ 91, 0, 0 ]) difference()
            {
                translate([ 15, 0, 0 ]) linear_extrude(45) rounded_square([ 77, 47 ], r = 7, center = true);
                translate([ 50, 0, -2 ]) linear_extrude(45) rounded_square([ 143, 43 ], r = 5, center = true);
                translate([ 0, 0, -1 ]) cylinder(100, r = 12);
                for (i = [ 0, 1, 2, 3 ])
                    rotate([ 0, 0, i * 90 ]) translate([ 31.04 / 2, 31.04 / 2, 0 ]) cylinder(100, d = 4);
            }
        }
        translate([ 150, 0, -2 ]) hull()
        {
            linear_extrude(10) square([ 100, 20 ], center = true);
            translate([ 0, 0, 10 ]) linear_extrude(2) square([ 100, 16 ], center = true);
        }
        for (i = [0:3])
            rotate([ 0, 0, i * 90 ])
            {
                translate([ 85, 85, 0 ]) cylinder(100, d = 5);
                translate([ 85, 85, 0 ]) cylinder(58, d = 20);
            }
    }
    // translate([151, 0, 68-48]) rotate([0, 70, 0]) linear_extrude(4) rotate([0, 0, 90])
    // text("S  E  A  C  A  L", size=12, halign="center", valign="center");
}
