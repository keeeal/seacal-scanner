$fn = 32;

module gx12(num_pins = 4)
{
    color([ 0.8, 0.8, 0.8 ])
    {
        difference()
        {
            union()
            {
                cylinder(h = 2, d = 15);
                cylinder(h = 6, d = 12);
                mirror([ 0, 0, 1 ]) cylinder(h = 9, d = 11.5);
                translate([ 0, 0, -5 ]) cylinder(h = 2.5, d = 17, $fn = 6);
            }
            translate([ 0, 0, -4 ]) linear_extrude(11) difference()
            {
                circle(d = 9.5);
                translate([ 0, 4.5 ]) circle(d = 2);
            }
        }
        for (n = [0:num_pins - 1])
            rotate(360 * (n + .5) / num_pins)
                translate([ 0, 2.5, -14 ]) cylinder(h = 18, d = 1.5);
    }
}
