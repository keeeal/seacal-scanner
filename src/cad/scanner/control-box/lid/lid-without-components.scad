use <../../../utils/shapes/2d/rounded-square.scad>

module lid_without_components()
{
    linear_extrude(1.6) difference()
    {
        union()
        {
            rounded_square([ 105, 72 ], r = 6.2, center = true);
            translate([ -105 / 4, 0 ]) rounded_square([ 105 / 2, 72 ], r = 1.8, center = true);
        }
        translate([ -5, 10 ]) circle(d = 8);
        translate([ -25, 10 ]) circle(d = 8);
        translate([ 20, 10 ]) circle(d = 12);
        {
            translate([ 105.4 / 2 - 6, 73 / 2 - 6 ]) circle(d = 5);
            translate([ 105.4 / 2 - 6, 6 - 73 / 2 ]) circle(d = 5);
            translate([ 6 - 105.4 / 2, 0 ]) circle(d = 5);
        }
    }
}
