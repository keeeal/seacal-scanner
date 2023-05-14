// clang-format off
use <utils/gears/herringbone.scad>
use <utils/gears/simple.scad>

$fn = 32;
// clang-format on

module base_motor_gear(tol_x = .2, tol_z = .4)
{
    difference()
    {
        union()
        {
            herringbone_gear(10, 12, -32);
            cylinder(20, r = 5);
        }
        translate([ 0, 0, -1 ]) linear_extrude(100) difference()
        {
            circle(2.5 + tol_x);
            translate([ 7 + tol_x, 0 ]) square([ 10, 10 ], true);
        }
    }
}
