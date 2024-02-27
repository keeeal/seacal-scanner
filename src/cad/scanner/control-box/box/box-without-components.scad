use <../../../utils/shapes/2d/rounded-square.scad>

EPS = 1e-3;

module box_without_components()
{
    difference()
    {
        hull()
        {
            translate([ -40, 0, 0 ]) hull()
            {
                translate([ 0, 0, 2 ]) linear_extrude(56) rounded_square([ 80, 80 ], r = 8, center = true);
                linear_extrude(60) rounded_square([ 76, 76 ], r = 6, center = true);
            }
            translate([ 50, 0, 0 ]) hull()
            {
                translate([ 0, 0, 2 ]) linear_extrude(56) rounded_square([ 100, 80 ], r = 8, center = true);
                linear_extrude(60) rounded_square([ 96, 76 ], r = 6, center = true);
            }
        }
        translate([ -40, 0, 1.6 ]) linear_extrude(60) rounded_square([ 73, 73 ], r = 7, center = true);
        translate([ 47.5, 0, 1.6 ]) linear_extrude(60) rounded_square([ 98, 73 ], r = 7, center = true);
        translate([ 0, 0, 30 ]) rotate([ 0, 90, 0 ])
        {
            hull()
            {
                translate([ 21, 0, 0 ]) cylinder(h = 101, d = 6);
                translate([ -21, 0, 0 ]) cylinder(h = 101, d = 6);
            }
            translate([ 0, 10, 0 ]) hull()
            {
                translate([ 18.5, 0, 0 ]) cylinder(h = 101, d = 6);
                translate([ -18.5, 0, 0 ]) cylinder(h = 101, d = 6);
            }
            translate([ 0, 20, 0 ]) hull()
            {
                translate([ 6.5, 0, 0 ]) cylinder(h = 101, d = 6);
                translate([ -6.5, 0, 0 ]) cylinder(h = 101, d = 6);
            }
            translate([ 0, -10, 0 ]) hull()
            {
                translate([ 18.5, 0, 0 ]) cylinder(h = 101, d = 6);
                translate([ -18.5, 0, 0 ]) cylinder(h = 101, d = 6);
            }
            translate([ 0, -20, 0 ]) hull()
            {
                translate([ 6.5, 0, 0 ]) cylinder(h = 101, d = 6);
                translate([ -6.5, 0, 0 ]) cylinder(h = 101, d = 6);
            }
            for (n = [0:3])
                rotate(90 * n) translate([ 20, 20, 0 ]) cylinder(h = 101, d = 4);
        }
        translate([ 23, 10, 40 ]) rotate([ -90, 0, 0 ]) cylinder(h = 100, d = 16);
        translate([ 47, 10, 40 ]) rotate([ -90, 0, 0 ]) cylinder(h = 100, d = 16);
        translate([ 70, 10, 38.5 ]) rotate([ -90, 0, 0 ]) cylinder(h = 100, d = 12);

        // translate([ 23, 10, 38.5 ]) rotate([ 90, 0, 0 ]) cylinder(h = 100, d = 12);
        translate([ 68.75, 0, 17 ]) rotate([ 90, 0, 0 ]) linear_extrude(height = 100)
            rounded_square([ 11, 13 ], r = 1, center = true, $fn = 4);
        translate([ 62, 0, 32 ]) rotate([ 90, 0, 0 ]) cylinder(h = 100, d = 6);

        translate([ 38.5, 0, 13 ]) rotate([ 90, 0, 0 ]) hull()
        {
            translate([ +2, 0, 0 ]) cylinder(h = 100, d = 8, $fn = 6);
            translate([ -2, 0, 0 ]) cylinder(h = 100, d = 8, $fn = 6);
        }

        translate([ 50, -4, 11 ]) cube([ 55, 70, 2 ], center = true);
        translate([ 50, -4, 30 ]) cube([ 55, 70, 16 ], center = true);
        translate([ 0, 0, 23 ]) rotate([ 0, -90, 0 ]) cylinder(h = 10, d = 20);
        translate([ 47.5, 0, 57 ]) linear_extrude(2) square([ 101, 11 ], center = true);
    }
    translate([ 50, 35, 1 ]) linear_extrude(13) rounded_square([ 20, 8 ], r = 2, center = true);
    translate([ 50, 34, 1 ]) linear_extrude(9) rounded_square([ 20, 10 ], r = 2, center = true);
    translate([ 50, 31, 13 ]) rotate([ 0, 90, 0 ]) cylinder(h = 8, r = 1, center = true);

    difference()
    {
        translate([ 47.5, 0, 55 ]) linear_extrude(2) rounded_square([ 100, 75 ], r = 8, center = true);
        hull()
        {
            translate([ 47.5, 0, 57 ]) linear_extrude(EPS) rounded_square([ 94, 69 ], r = 5, center = true);
            translate([ 47.5, 0, 55 - EPS ]) linear_extrude(EPS) rounded_square([ 98, 73 ], r = 7, center = true);
        }
    }
}
