use <../../utils/shapes/2d/rounded-square.scad>

module foot()
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

    module profile(size, r) difference()
    {
        square(size, center = true);
        translate([ -size[0] / 2, -size[1] / 2 ]) circle(r, $fn = 4);
        translate([ -size[0] / 2, +size[1] / 2 ]) circle(r, $fn = 4);
    }

    difference()
    {
        union()
        {
            hull()
            {
                translate([ 0, 0, -20 ]) linear_extrude(2, center = true)
                    rounded_square([ 26, 26 ], r = 2, center = true, $fn = 4);
                translate([ -2.5, 0, -14 ]) linear_extrude(2, center = true) profile([ 31, 30 ], r = 2);
                translate([ -2.5, 0, 12 ]) linear_extrude(2, center = true) profile([ 31, 30 ], r = 2);
                translate([ 0, -15, 25.5 / 2 ]) rotate([ 30, 0, 0 ]) translate([ 0, 13, -1 ])
                    linear_extrude(2, center = true) rounded_square([ 26, 26 ], r = 2, center = true, $fn = 4);
            }
            rotate([ 90, 0, 0 ]) end(43);
            translate([ 0, 0, 12.5 ]) rotate([ 30, 0, 0 ]) end(33);
        }
        translate([ -16, 0, 0 ]) rotate([ 0, 90, 0 ]) linear_extrude(100) minkowski()
        {
            square(24, center = true);
            circle(1, $fn = 4);
        }
    }
}
