use <../../utils/shapes/2d/rounded-square.scad>

module apex()
{
    module wedge(height) hull()
    {
        linear_extrude(height - 11) square([ 23, 6 ], center = true);
        linear_extrude(height - 3) square([ 20, 6 ], center = true);
    }

    module end(height)
    {
        hull()
        {
            linear_extrude(height) square([ 18, 18 ], center = true);
            linear_extrude(height - 2) square([ 22, 22 ], center = true);
        }
        wedge(height);
        rotate(90) wedge(height);
    }

    difference()
    {
        hull()
        {
            rotate([ 0, -30, 0 ]) linear_extrude(28) translate([ 13, 0 ])
                rounded_square([ 26, 26 ], r = 2, center = true, $fn = 4);
            rotate([ 0, 30, 0 ]) linear_extrude(28) translate([ -13, 0 ])
                rounded_square([ 26, 26 ], r = 2, center = true, $fn = 4);
        }
        translate([ 0, 0, 20 ]) rotate([ 90, 0, 0 ]) cylinder(39, d = 13, center = true);
    }
    rotate([ 0, 150, 0 ]) translate([ -13, 0, -10 ]) end(43);
    rotate([ 0, -150, 0 ]) translate([ 13, 0, -10 ]) end(43);
}
