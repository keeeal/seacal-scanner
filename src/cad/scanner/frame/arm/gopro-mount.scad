use <../../../utils/gopro/female.scad>
use <../../../utils/shapes/2d/rounded-square.scad>

module gopro_mount()
{
    difference()
    {
        union()
        {
            hull()
            {
                linear_extrude(60, center = true) rounded_square(28.6, r = 1.8, center = true);
                translate([ 0, 0, -0.5 ]) linear_extrude(59, center = true) rounded_square(30.2, r = 2.6, center = true);
            }
            translate([ 15, 0, 0 ]) rotate([ 0, 90, 0 ]) cylinder(5, 12, 10);
        }
        linear_extrude(62, center = true) rounded_square(27, r = 1, center = true);
        translate([ 35, 0, 0 ]) rotate([ 0, -90, 0 ]) scale(0.52) import("../../../assets/axle-screw.stl");
    }
    for (n = [ -1, 1 ])
        translate([ 0, 0, n * 12 ]) for (i = [0:3]) rotate(90 * i) hull()
        {
            translate([ -5, 14, -4 ]) sphere(0.5);
            translate([ 5, 14, -4 ]) sphere(0.5);
            translate([ -5, 13.2, 0 ]) sphere(0.5);
            translate([ 5, 13.2, 0 ]) sphere(0.5);
            translate([ -5, 14, +4 ]) sphere(0.5);
            translate([ 5, 14, +4 ]) sphere(0.5);
        }
    translate([ -24.5, 0, -22.5 ]) rotate([ 90, 0, 0 ]) gopro_mount_female(length = 1.9, base = true);
}
