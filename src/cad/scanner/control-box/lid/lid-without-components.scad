use <../../../utils/shapes/2d/rounded-square.scad>

module lid_without_components()
{
    linear_extrude(3) difference()
    {
        rounded_square([ 97, 72 ], r = 7, center = true);
        translate([ -18, 12 ]) circle(d = 8.5);
        translate([ -32, 12 ]) circle(d = 8.5);
        translate([ -25, -12 ]) circle(d = 12.5);
    }
    linear_extrude(1.6) rounded_square([ 100, 10 ], center = true, r = 1);
}
