use <../../../utils/shapes/2d/rounded-square.scad>
use <../../../utils/shapes/2d/squircle.scad>

module base_without_badge()
{
    difference()
    {
        union()
        {
            difference()
            {
                hull()
                {
                    translate([ 0, 0, 59 ]) linear_extrude(1) circle(d = 304);
                    linear_extrude(2) squircle(r = 160);
                }
                hull()
                {
                    translate([ 0, 0, 57 ]) linear_extrude(1) circle(r = 115);
                    translate([ 0, 0, -1 ]) linear_extrude(2) squircle(r = 145);
                }
                translate([ 0, 0, 57 ]) linear_extrude(4) circle(r = 115);
            }
            translate([ 91, 0, 0 ]) difference()
            {
                translate([ 19, 0, 0 ]) linear_extrude(45) rounded_square([ 85, 47 ], r = 7, center = true);
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
    translate([ 150, 0, 30 ]) rotate([ 0, 80, 0 ]) difference()
    {
        hull()
        {
            linear_extrude(7) rounded_square([ 28, 108 ], r = 8, center = true);
            linear_extrude(1) rounded_square([ 38, 118 ], r = 13, center = true);
        }
        translate([ 0, 0, 6.6 ]) linear_extrude(7) rounded_square([ 24, 104 ], r = 6, center = true);
    }
}
