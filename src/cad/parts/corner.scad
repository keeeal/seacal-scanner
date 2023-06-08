$fn = 32;

module corner()
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
        translate([ -size[0] / 2, size[1] / 2 ]) circle(r, $fn = 4);
    }

    difference()
    {
        union()
        {
            hull()
            {
                translate([ 0, 0, -14 ]) linear_extrude(2, center = true) profile([ 26, 26 ], r = 2);
                translate([ 0, 0, 12 ]) linear_extrude(2, center = true) profile([ 26, 26 ], r = 2);
            }
            rotate([ 90, 0, 0 ]) end(43);
            rotate([ 0, 90, 0 ]) end(43);
        }
    }
}
