use <../apex.scad>
use <../../../utils/shapes/2d/rounded-square.scad>

module apex_limit()
{
    apex();

    difference()
    {
        union()
        {
            translate([ -8.5, -13, 30 ]) cube([ 17, 2, 80 ]);
            translate([ -8.5, -11, 100 ]) rotate([ 90, 0, 0 ])
                linear_extrude(2) rounded_square([ 38.5, 20 ], r = 5);
        }
        translate([ 22.1, -10, 110 ]) rotate([ 90, 0, 0 ]) cube([ 1.8, 11, 4 ]);
    }

    hull()
    {
        translate([ -8.5, -13, 35.25 ]) cube([ 17, 24, 2 ]);
        translate([ -8.5, -13, 35.25 ]) cube([ 17, 2, 13 ]);
    }
    translate([ 7.5, 0, 0 ]) hull()
    {
        translate([ -1, -13, 35.25 ]) cube([ 2, 24, 2 ]);
        translate([ -1, -13, 35.25 ]) cube([ 2, 2, 80 ]);
    }
    translate([ -7.5, 0, 0 ]) hull()
    {
        translate([ -1, -13, 35.25 ]) cube([ 2, 24, 2 ]);
        translate([ -1, -13, 35.25 ]) cube([ 2, 2, 80 ]);
    }
}
