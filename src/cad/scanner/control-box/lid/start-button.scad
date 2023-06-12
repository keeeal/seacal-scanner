module start_button(pressed = false)
{
    color([ 0.8, 0.8, 0.8 ])
    {
        difference()
        {
            hull()
            {
                cylinder(1, d = 14);
                cylinder(2, d = 11);
            }
            translate([ 0, 0, -1 ]) cylinder(4, d = 10);
        }
        translate([ 0, 0, pressed ? -1.5 : 0 ]) cylinder(2, d = 9.5);
        mirror([ 0, 0, 1 ]) cylinder(h = 10, d = 12);
        mirror([ 0, 0, 1 ]) cylinder(h = 15, d = 11);
        translate([ +4, 0, -17 ]) cube([ 0.5, 2, 4 ], center = true);
        translate([ -4, 0, -17 ]) cube([ 0.5, 2, 4 ], center = true);
        translate([ 0, 0, -5 ]) cylinder(h = 2, d = 16, $fn = 6);
    }
}
