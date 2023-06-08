use <../utils/shapes/2d/rounded-square.scad>

$fn = 32;

module axle()
{
    difference()
    {
        hull()
        {
            linear_extrude(60, center = true) rounded_square(28.6, r = 1.8, center = true);
            linear_extrude(58, center = true) rounded_square(30.2, r = 2.6, center = true);
        }
        linear_extrude(62, center = true) rounded_square(27, r = 1, center = true);
    }
    for (n = [-1:1])
        translate([ 0, 0, n * 12 ]) for (i = [0:3]) rotate(90 * i) hull()
        {
            translate([ -5, 14, -4 ]) sphere(0.5);
            translate([ 5, 14, -4 ]) sphere(0.5);
            translate([ -5, 13.2, 0 ]) sphere(0.5);
            translate([ 5, 13.2, 0 ]) sphere(0.5);
            translate([ -5, 14, +4 ]) sphere(0.5);
            translate([ 5, 14, +4 ]) sphere(0.5);
        }
    translate([ 14, 0, 0 ]) rotate([ 0, 90, 0 ])
    {
        cylinder(2, d = 22);
        difference()
        {
            intersection()
            {
                union()
                {
                    cylinder(29, d = 12);
                    translate([ 0, 0, 28.5 ]) cylinder(5, d1 = 15, d2 = 10.5);
                }
                linear_extrude(100) square([ 9.5, 100 ], center = true);
            }
            hull()
            {
                translate([ 0, 0, 10 ]) rotate([ 0, 90, 0 ]) cylinder(100, d = 4, center = true);
                translate([ 0, 0, 100 ]) rotate([ 0, 90, 0 ]) cylinder(100, d = 4, center = true);
            }
        }
    }
}
