use <../../../utils/shapes/2d/rounded-square.scad>

EPS = 1e-3;

module arduino()
{
    color([ 0.1, 0.2, 0.3 ]) linear_extrude(1.5)
    {
        rounded_square([ 66, 53.5 ], r = 1, center = true, $fn = 4);
        translate([ 33, -4 ]) rounded_square([ 5 + EPS, 39 ], r = 2.5, center = true, $fn = 4);
    }
}
