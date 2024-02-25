use <../../../utils/shapes/2d/rounded-square.scad>
use <dupont.scad>

EPS = 1e-3;

module arduino()
{
    color([ 0.1, 0.2, 0.3 ]) linear_extrude(height = 1.5)
    {
        rounded_square([ 66, 53.5 ], r = 1, center = true, $fn = 4);
        translate([ 33, -4 ]) rounded_square([ 5 + EPS, 39 ], r = 2.5, center = true, $fn = 4);
    }
    translate([ 32, 25.2, 1.5 ]) rotate(180) dupont(8);
    translate([ 10.4, 25.2, 1.5 ]) rotate(180) dupont(10);
    translate([ 32, -22.7, 1.5 ]) rotate(180) dupont(6);
    translate([ 14.8, -22.7, 1.5 ]) rotate(180) dupont(8);

    translate([ -35, -23.2, 1.5 ])
    {
        color([ 0.2, 0.2, 0.2 ]) difference()
        {
            union()
            {
                hull()
                {
                    translate([ 0, 4.5, 6.2 ]) rotate([ 0, 90, 0 ]) cylinder(h = 14, d = 9);
                    linear_extrude(height = 1) square([ 14, 9 ]);
                }
                cube([ 3, 9, 11 ]);
            }
            translate([ -4, 4.5, 6.2 ]) rotate([ 0, 90, 0 ]) cylinder(h = 14, d = 6.5);
        }
        color([ 0.5, 0.5, 0.5 ]) translate([ 1.5, 4.5, 6.2 ]) rotate([ 0, 90, 0 ]) cylinder(h = 12, d = 2);
    }

    translate([ -27, 23, 1.5 ])
    {
        color([ 0.2, 0.2, 0.2 ]) linear_extrude(height = 3.5) rotate(-90) rounded_square(6, r = 1, center = true);
        color([ 0.5, 0.5, 0.5 ]) translate([ 0, 0, 3.5 ]) linear_extrude(height = 0.5) rotate(-90) rounded_square(6, r = 1, center = true);
        color([ 0.5, 0.2, 0.2 ]) cylinder(5, d = 3);
    }

    color([ 0.5, 0.5, 0.5 ]) translate([ -28.5, 11.5, 3 ]) rotate([ 0, -90, 0 ]) hull()
    {
        translate([ 0, +2, 0 ]) cylinder(h = 6, d = 3);
        translate([ 0, -2, 0 ]) cylinder(h = 6, d = 3);
    }
}
