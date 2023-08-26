use <../../../../utils/gopro/female.scad>
use <../../../../utils/shapes/2d/rounded-square.scad>

module bottom_limit()
{
    difference()
    {
        mirror([ 0, 0, 1 ]) hull()
        {
            linear_extrude(60, center = true) rounded_square(28.6, r = 1.8, center = true);
            translate([ 0, 0, -0.5 ]) linear_extrude(59, center = true) rounded_square(30.2, r = 2.6, center = true);
            translate([ -15.1, 0, -30 ]) cube([ 15.1, 15.1, 22 ]);
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

    translate([ -15.1, 15.1, 28.4 ]) cube([ 10, 7, 1.6 ]);
    translate([ -15.1, 22, 8 ]) cube([ 10, 1.6, 22 ]);

    translate([ -8.1, 22, 13 ]) sphere(1.2);
    translate([ -8.1, 22, 23 ]) sphere(1.2);
    translate([ -8.1, 15.1, 13 ]) sphere(1.2);
    translate([ -8.1, 15.1, 23 ]) sphere(1.2);
}
