use <../../../../utils/gopro/female.scad>
use <../../../../utils/shapes/2d/rounded-square.scad>

module bottom_limit()
{
    difference()
    {
        linear_extrude(24.2, center = true) difference()
        {
            union()
            {
                rounded_square(30.2, r = 2.6, center = true);
                translate([ -15.1, 0, 0 ]) square([ 10, 23.7 ]);
            }
            rounded_square(27, r = 1, center = true);
        }
        translate([ -16.1, 15.1, -21 / 2 ]) cube([ 12, 7, 21 ]);
    }

    for (n = [-0.5:0.5])
        translate([ 0, 0, n * 12 ]) for (i = [0:3]) rotate(90 * i) hull()
        {
            translate([ -5, 14, -4 ]) sphere(0.5);
            translate([ 5, 14, -4 ]) sphere(0.5);
            translate([ -5, 13.2, 0 ]) sphere(0.5);
            translate([ 5, 13.2, 0 ]) sphere(0.5);
            translate([ -5, 14, +4 ]) sphere(0.5);
            translate([ 5, 14, +4 ]) sphere(0.5);
        }
    intersection()
    {
        union()
        {
            translate([ -8.1, 14.6, -5 ]) sphere(1.5);
            translate([ -8.1, 14.6, +5 ]) sphere(1.5);
            translate([ -8.1, 22.6, -5 ]) sphere(1.5);
            translate([ -8.1, 22.6, +5 ]) sphere(1.5);
        }
        translate([ -16.1, 15.1, -21 / 2 ]) cube([ 12, 7, 21 ]);
    }
}
