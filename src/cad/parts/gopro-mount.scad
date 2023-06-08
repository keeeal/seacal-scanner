use <../utils/gopro/female.scad>
use <../utils/shapes/2d/rounded-square.scad>

$fn = 32;

module gopro_mount()
{
    difference()
    {
        hull()
        {
            linear_extrude(60, center = true) rounded_square(28.6, r = 1.8, center = true);
            translate([ 0, 0, -0.5 ]) linear_extrude(59, center = true) rounded_square(30.2, r = 2.6, center = true);
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
    translate([ -24.5, 0, -22.5 ]) rotate([ 90, 0, 0 ]) gopro_mount_female(length = 1.9, base = true);
}
