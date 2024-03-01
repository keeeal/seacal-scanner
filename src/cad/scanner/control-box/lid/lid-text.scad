use <../../../utils/shapes/2d/rounded-square.scad>

EPS = 1e-3;

module lid_text()
{
    translate([ 0, 0, 2.8 + EPS ]) linear_extrude(height = 0.2)
    {
        translate([ -8, -12 ]) difference()
        {
            rounded_square([ 60.4, 24.4 ], r = 4.2, center = true);
            rounded_square([ 59.6, 23.6 ], r = 3.8, center = true);
        }
        translate([ 1, -12 ]) text(text = "START", size = 4, valign = "center", halign = "center");
    }
}
