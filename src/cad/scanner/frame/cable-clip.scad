use <../../utils/gopro/female.scad>
use <../../utils/shapes/2d/rounded-square.scad>

module cable_clip()
{
    linear_extrude(height = 20, center = true)
    {
        difference()
        {
            rounded_square(30.2, r = 2.6, center = true);
            rounded_square(27, r = 1, center = true);
        }
        translate([ 3, 0 ]) intersection()
        {
            difference()
            {
                rounded_square(30.2, r = 2.6, center = true);
                rounded_square(27, r = 1, center = true);
            }
            square(20);
        }
        translate([ 16.5, -10 ]) square([ 1.6, 10 ]);
        hull()
        {
            translate([ 16.5, -10 ]) circle(d = 1.6);
            translate([ 17.3, -10 ]) circle(d = 1.6);
        }
        translate([ 16.5, -5 ]) circle(d = 1.6);
        translate([ 16.5, 0 ]) circle(d = 1.6);
        translate([ 16.5, 5 ]) circle(d = 1.6);
        translate([ 16.5, 10 ]) circle(d = 1.6);
    }
    for (n = [-0.5:0.5])
        translate([ 0, 0, n * 9 ]) for (i = [0:3]) rotate(90 * i) hull()
        {
            translate([ -5, 14, -4 ]) sphere(0.5);
            translate([ 5, 14, -4 ]) sphere(0.5);
            translate([ -5, 13.2, 0 ]) sphere(0.5);
            translate([ 5, 13.2, 0 ]) sphere(0.5);
            translate([ -5, 14, +4 ]) sphere(0.5);
            translate([ 5, 14, +4 ]) sphere(0.5);
        }
}
