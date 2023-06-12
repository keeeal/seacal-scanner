use <../../utils/shapes/2d/rounded-square.scad>

$fn = 32;

module tube_mount()
{
    difference()
    {
        union()
        {
            linear_extrude(47, center = true) rounded_square(30.2, r = 1.8, center = true);
            translate([ -30.2 / 4, 0, 0 ]) linear_extrude(47, center = true) square([ 30.2 / 2, 30.2 ], center = true);
        }

        linear_extrude(62, center = true) rounded_square(27, r = 1, center = true);
    }
    for (n = [-1:1])
        translate([ 0, 0, n * 12 ]) for (i = [0:3]) rotate(90 * i) hull()
        {
            translate([ -5, 14, -4 ]) sphere(0.5);
            translate([ 5, 14, -4 ]) sphere(0.5);
            translate([ -5, 13.2, 0 ]) sphere(0.5);
            translate([ 5, 13.2, 0 ]) sphere(0.5);
            translate([ -5, 14, +4 ]) sphere(0.5);
            translate([ 5, 14, +4 ]) sphere(0.5);
        }
}

module nema_mount()
{
    difference()
    {
        translate([ 0, 0, 0 ]) linear_extrude(30.2) union()
        {
            rounded_square([ 47, 47 ], r = 4, center = true, $fn = 4);
            translate([ 0, -47 / 4 ]) square([ 47, 47 / 2 ], center = true);
        }
        translate([ 0, 0, -2 ]) linear_extrude(30.2) rounded_square([ 43, 43 ], r = 5, center = true);
        translate([ 0, 0, -1 ]) cylinder(100, r = 12);
        for (i = [ 0, 1, 2, 3 ])
            rotate([ 0, 0, i * 90 ]) translate([ 31.04 / 2, 31.04 / 2, 0 ]) cylinder(100, d = 4);
    }
}

module arm_motor_mount()
{
    rotate([ 0, 90, 0 ]) tube_mount();
    difference()
    {
        translate([ 0, 15.1, 38.5 ]) rotate([ 90, 0, 0 ]) nema_mount();
        translate([ 0, 15, 38.5 ]) cube([ 100, 16, 18 ], center = true);
    }
}
