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
        translate([ -10, 0 ]) circle(d = 8);
        translate([ -30, 0 ]) circle(d = 8);
        translate([ 20, 0 ]) circle(d = 12);
    }
}
