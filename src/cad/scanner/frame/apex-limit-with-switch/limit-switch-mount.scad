module limit_switch_mount()
{
    linear_extrude(10, center = true) difference()
    {
        translate([ 0, 0.7 ]) square([ 24.2, 12 ], center = true);
        square([ 21, 7 ], center = true);
    }
    translate([ 6.05, 8, 0 ]) cube([ 12.1, 3, 1.6 ], center = true);
    translate([ 0, 9.8, 0 ]) cube([ 24.2, 1.6, 10 ], center = true);

    translate([ -5, +4, -2 ]) sphere(1.5);
    translate([ -5, -4, -2 ]) sphere(1.5);
    translate([ +5, +4, -2 ]) sphere(1.5);
    translate([ +5, -4, -2 ]) sphere(1.5);
}
