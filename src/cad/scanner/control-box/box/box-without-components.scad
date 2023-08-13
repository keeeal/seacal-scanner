use <../../../utils/shapes/2d/rounded-square.scad>

module box_without_components()
{
    difference()
    {
        hull()
        {
            translate([ 0, 0, 1 ]) linear_extrude(58) rounded_square([ 183.2, 76.2 ], r = 8, center = true);
            linear_extrude(60) rounded_square([ 181.6, 74.6 ], r = 7.2, center = true);
        }
        translate([ -53.5, 0, 1.6 ]) linear_extrude(60) rounded_square([ 73, 73 ], r = 8 - 1.6, center = true);
        translate([ 37.3, 0, 1.6 ]) linear_extrude(60) difference()
        {
            union()
            {
                rounded_square([ 105.4, 73 ], r = 8 - 1.6, center = true);
                translate([ -105.4 / 4, 0 ]) rounded_square([ 105.4 / 2, 73 ], r = 2, center = true);
            }
            hull()
            {
                translate([ 105.4 / 2 - 6, 73 / 2 - 6 ]) circle(d = 8);
                translate([ 105.4 / 2 + 100, 73 / 2 + 100 ]) circle(d = 8);
            }
            hull()
            {
                translate([ 105.4 / 2 - 6, 6 - 73 / 2 ]) circle(d = 8);
                translate([ 105.4 / 2 + 100, 6 - 73 / 2 - 100 ]) circle(d = 8);
            }
            hull()
            {
                translate([ 6 - 105.4 / 2, 0 ]) circle(d = 8);
                translate([ -100, 0 ]) circle(d = 8);
            }
        }
        translate([ 37.3, 0, 60 - 2 ]) linear_extrude(10)
        {
            rounded_square([ 105.4, 73 ], r = 8 - 1.6, center = true);
            translate([ -105.4 / 4, 0 ]) rounded_square([ 105.4 / 2, 73 ], r = 2, center = true);
        }
        translate([ 37.3, 0, 40 ]) linear_extrude(100)
        {
            translate([ 105.4 / 2 - 6, 73 / 2 - 6 ]) circle(d = 4);
            translate([ 105.4 / 2 - 6, 6 - 73 / 2 ]) circle(d = 4);
            translate([ 6 - 105.4 / 2, 0 ]) circle(d = 4);
        }
        translate([ 0, 0, 30 ]) rotate([ 0, 90, 0 ]) linear_extrude(100)
        {
            hull()
            {
                translate([ 21, 0, 0 ]) circle(d = 6);
                translate([ -21, 0, 0 ]) circle(d = 6);
            }
            translate([ 0, 10, 0 ]) hull()
            {
                translate([ 18.5, 0, 0 ]) circle(d = 6);
                translate([ -18.5, 0, 0 ]) circle(d = 6);
            }
            translate([ 0, 20, 0 ]) hull()
            {
                translate([ 6.5, 0, 0 ]) circle(d = 6);
                translate([ -6.5, 0, 0 ]) circle(d = 6);
            }
            translate([ 0, -10, 0 ]) hull()
            {
                translate([ 18.5, 0, 0 ]) circle(d = 6);
                translate([ -18.5, 0, 0 ]) circle(d = 6);
            }
            translate([ 0, -20, 0 ]) hull()
            {
                translate([ 6.5, 0, 0 ]) circle(d = 6);
                translate([ -6.5, 0, 0 ]) circle(d = 6);
            }
            for (n = [0:3])
                rotate(90 * n) translate([ 20, 20, 0 ]) circle(d = 4);
        }
        translate([ 0, 10, 40 ]) rotate([ -90, 0, 0 ]) cylinder(h = 100, d = 16);
        translate([ 24, 10, 40 ]) rotate([ -90, 0, 0 ]) cylinder(h = 100, d = 16);
        translate([ 47, 10, 38.5 ]) rotate([ -90, 0, 0 ]) cylinder(h = 100, d = 12);
        translate([ 68, 10, 38.5 ]) rotate([ -90, 0, 0 ]) cylinder(h = 100, d = 12);
    }
}