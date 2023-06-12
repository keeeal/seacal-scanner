use <../../utils/shapes/2d/rounded-square.scad>

EPS = 1e-3;

module stop_button(pressed = false)
{
    color([ .1, .1, .1 ]) hull()
    {
        linear_extrude(EPS) rounded_square(70, r = 5.5, center = true);
        translate([ 0, 0, 37 ]) linear_extrude(EPS) rounded_square(72, r = 6.5, center = true);
    }
    color([ .7, .5, .1 ]) difference()
    {
        translate([ 0, 0, 37 ]) linear_extrude(21) difference()
        {
            rounded_square(72, r = 6.5, center = true);
            for (n = [0:3])
                rotate(90 * n) translate([ 59 / 2, 59 / 2 ]) circle(d = 8);
        }
        // translate([ 0, 23.5, 57.5 ]) linear_extrude(1) rounded_square([ 23, 12 ], r = 1, center = true);
    }
    color([ .6, .6, .6 ]) translate([ 0, 0, 1 ]) linear_extrude(55) rounded_square(69, r = 5, center = true);
    color([ .1, .1, .1 ]) translate([ 0, 0, 58 ])
    {
        hull()
        {
            cylinder(h = 3, d = 30);
            cylinder(h = 5, d = 28);
        }
        cylinder(h = 25, d = 28);
    }
    color([ .6, .1, .1 ]) translate([ 0, 0, pressed ? 65 : 70 ])
    {
        cylinder(h = 15, d = 30);
        translate([ 0, 0, 13 ]) hull()
        {
            cylinder(h = 4, d = 40);
            cylinder(h = 6, d = 30);
        }
    }
}
