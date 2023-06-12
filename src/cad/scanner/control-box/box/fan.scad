use <../../../utils/shapes/2d/rounded-square.scad>

module fan(num_blades = 7, num_supports = 3)
{
    color([ 0.2, 0.2, 0.2 ])
    {
        difference()
        {
            union()
            {
                linear_extrude(2.5) difference()
                {
                    rounded_square(50, r = 4, center = true);
                    difference()
                    {
                        circle(d = 48);
                        for (n = [0:num_supports - 1])
                            rotate(360 * n / num_supports)
                                translate([ 0, 50 ]) square([ 3, 100 ], center = true);
                        circle(d = 25);
                    }
                }
                linear_extrude(12)
                {
                    difference()
                    {
                        union()
                        {
                            intersection()
                            {
                                rounded_square(50, r = 4, center = true);
                                rotate(45) square([ 7, 100 ], center = true);
                            }
                            intersection()
                            {
                                rounded_square(50, r = 4, center = true);
                                rotate(-45) square([ 7, 100 ], center = true);
                            }
                            circle(d = 50);
                        }
                        circle(d = 48);
                    }
                }
            }
            for (n = [0:3])
                rotate(90 * n) translate([ 20, 20, 0 ])
                {
                    translate([ 0, 0, -1 ]) cylinder(h = 14, d = 3.5);
                    translate([ 0, 0, 5 ]) cylinder(h = 14, d = 5.5);
                }
        }
        hull()
        {
            linear_extrude(10) circle(d = 25);
            linear_extrude(11) circle(d = 23);
        }
        for (n = [0:num_blades - 1])
            rotate(360 * n / num_blades)
                translate([ 0, 12, 7 ]) rotate([ 0, 30, 0 ]) hull()
            {
                cube([ 8, 1, 1 ], center = true);
                translate([ 0, 10, 0 ]) cube([ 10, 1, 1 ], center = true);
            }
    }
}
