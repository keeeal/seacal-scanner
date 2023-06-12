use <badge.scad>
use <base-motor.scad>
use <base.scad>
use <bearing.scad>
use <motor-gear.scad>
use <platform-gear.scad>

module platform()
{
    translate([ 0, 0, 60 ]) color([ 0.8, 0.8, 0.8 ]) bearing();
    // translate([0, 0, 54]) platform_gear();
    translate([ 91, 0, 43 ]) rotate([ 180, 0, 0 ]) base_motor();
    // translate([91, 0, 64]) rotate([180, 0, 0]) motor_gear();
    base();
    translate([ 156, 0, 31 ]) rotate([ 0, 80, 0 ]) rotate([ 0, 0, 90 ]) badge();
}
