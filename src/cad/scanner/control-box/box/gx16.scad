module gx16(num_pins = 4)
{
    color([ 0.8, 0.8, 0.8 ])
    {
        difference()
        {
            union()
            {
                cylinder(h = 2, d = 18);
                cylinder(h = 6, d = 16);
                mirror([ 0, 0, 1 ]) cylinder(h = 9, d = 15.5);
                translate([ 0, 0, -5 ]) cylinder(h = 3, d = 21, $fn = 6);
            }
            translate([ 0, 0, -4 ]) linear_extrude(11) difference()
            {
                circle(d = 13);
                translate([ 0, 6.5 ]) circle(d = 2.5);
            }
        }
        for (n = [0:num_pins - 1])
            rotate(360 * (n + .5) / num_pins)
                translate([ 0, 3.5, -14 ]) cylinder(h = 18, d = 2);
    }
}
