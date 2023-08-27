module lever()
{
    module tab() linear_extrude(0.2) hull()
    {
        translate([ 3.25, 0, 0 ]) circle(d = 3.5);
        translate([ 0.5, 0, 0 ]) square([ 1, 3.5 ], center = true);
    }

    color([ 0.8, 0.8, 0.8 ])
    {
        translate([ 0, -2, 0 ]) cube([ 19, 4, 0.2 ]);
        translate([ 19 - 1.75, 2.2, 0 ]) rotate([ 0, -90, 90 ]) tab();
        translate([ 19 - 1.75, -2, 0 ]) rotate([ 0, -90, 90 ]) tab();
        translate([ 19 - 1.75, 0, 3.25 ]) rotate([ 90, 0, 0 ]) cylinder(5, d = 2, center = true);
    }

    color([ 0.7, 0.2, 0.2 ]) translate([ 19 - 1.75, 0, 3.25 ]) rotate([ 90, 0, 0 ]) cylinder(4, d = 4.5, center = true);
}

module limit_switch(pressed = false)
{
    module bump() hull()
    {
        rotate([ 90, 0, 0 ]) cylinder(6.5, d = 4.5, center = true);
        translate([ 0, 0, -2.25 ]) cube([ 4.5, 6.5, 1 ], center = true);
    }

    module leg() translate([ 0, -1.5, -6.5 ]) cube([ 0.5, 3, 4 ]);

    color([ 0.2, 0.2, 0.2 ]) difference()
    {
        union()
        {
            translate([ -10, -3, -2.5 ]) cube([ 20, 6, 9.5 ]);
            translate([ -5, 0, 0 ]) bump();
            translate([ +5, 0, 0 ]) bump();
        }
        translate([ -5, 0, 0 ]) rotate([ 90, 0, 0 ]) cylinder(7, d = 2.5, center = true);
        translate([ +5, 0, 0 ]) rotate([ 90, 0, 0 ]) cylinder(7, d = 2.5, center = true);
    }

    color([ 0.8, 0.8, 0.8 ])
    {
        translate([ 8.5, 0, 0 ]) leg();
        translate([ 1, 0, 0 ]) leg();
        translate([ -8, 0, 0 ]) leg();
    }

    translate([ -7, 0, 7 ]) rotate([ 0, pressed ? 0 : -15, 0 ]) lever();
}
