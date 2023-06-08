
use <../utils/motors/nema17.scad>

use <parts/apex.scad>
use <parts/arm-motor-mount.scad>
use <parts/axle.scad>
use <parts/badge.scad>
use <parts/base-motor-gear.scad>
use <parts/base.scad>
use <parts/bearing-gear.scad>
use <parts/cap.scad>
use <parts/corner.scad>
use <parts/foot.scad>
use <parts/gopro-mount.scad>

$fn = 32;

module aluminium()
{
    module tube(height, center = false)
    {
        module profile() difference()
        {
            square([ 25.5, 25.5 ], center = true);
            square([ 23, 23 ], center = true);
        }
        linear_extrude(height, center = center) profile();
    }
    translate([ -300, -315, 21 ]) rotate([ 0, 90, 0 ]) tube(600);
    translate([ -300, 315, 21 ]) rotate([ 0, 90, 0 ]) tube(600);
    translate([ -289, 300, 21 ]) rotate([ 0, 90, -90 ]) tube(600);
    translate([ -289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ]) translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ])
        tube(600);
    translate([ 289, 300, 21 ]) rotate([ 0, 90, -90 ]) tube(600);
    translate([ 289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ]) translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ])
        tube(600);
    mirror([ 0, 1, 0 ]) translate([ 289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ]) translate([ 0, 0, 25.5 / 2 ])
        rotate([ 0, 90, -90 ]) tube(600);
    mirror([ 0, 1, 0 ]) translate([ -289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ]) translate([ 0, 0, 25.5 / 2 ])
        rotate([ 0, 90, -90 ]) tube(600);

    translate([ 318.5, 450, 573.5 ]) rotate([ 90, 0, 0 ]) tube(900);
    translate([ -318.5, 450, 573.5 ]) rotate([ 90, 0, 0 ]) tube(900);
    translate([ -300, 463.5, 573.5 ]) rotate([ 0, 90, 0 ]) tube(600);
}

module base_motor() nema17_short();

module arm_motor() nema17_short();

module bearing()
{
    linear_extrude(1) difference()
    {
        circle(152);
        circle(114);
    }
    translate([ 0, 0, 7 ]) linear_extrude(1) difference()
    {
        circle(152);
        circle(81);
    }
}

module assembly()
{
    translate([ 0, 0, 60 ]) color([ 0.8, 0.8, 0.8 ]) bearing();
    // translate([0, 0, 54]) bearing_gear();
    translate([ 91, 0, 43 ]) rotate([ 180, 0, 0 ]) base_motor();
    // translate([91, 0, 64]) rotate([180, 0, 0]) base_motor_gear();
    base();
    translate([ 156, 0, 31 ]) rotate([ 0, 80, 0 ]) rotate([ 0, 0, 90 ]) badge();

    color([ 0.3, 0.3, 0.3 ]) aluminium();

    translate([ -289, 315, 21 ]) foot();
    translate([ 289, 315, 21 ]) mirror([ 1, 0, 0 ]) foot();
    translate([ 289, -315, 21 ]) rotate([ 0, 0, 180 ]) foot();
    translate([ -289, -315, 21 ]) rotate([ 0, 0, 180 ]) mirror([ 1, 0, 0 ]) foot();
    translate([ -289, 0, 553.5 ]) rotate([ 0, 0, 90 ]) apex();
    translate([ 289, 0, 553.5 ]) rotate([ 0, 0, 90 ]) apex();
    translate([ -318.5, 0, 573.5 ]) rotate([ 90, 0, 0 ]) axle();
    translate([ 318.5, 0, 573.5 ]) rotate([ 90, 0, 0 ]) mirror([ 1, 0, 0 ]) axle();

    translate([ -318.5, 463.5, 573.5 ]) corner();
    translate([ 318.5, 463.5, 573.5 ]) mirror([ 1, 0, 0 ]) corner();
    translate([ 318.5, -452.5, 573.5 ]) mirror([ 0, 1, 0 ]) cap();
    translate([ -318.5, -452.5, 573.5 ]) mirror([ 0, 1, 0 ]) cap();

    translate([ 289, 0, 21 ]) rotate([ 0, 0, 90 ]) arm_motor_mount();
    translate([ 303, 0, 59.5 ]) rotate([ 0, -90, 0 ]) arm_motor();

    translate([ 0, 463.5, 573.5 ]) rotate([ 90, 0, 90 ]) gopro_mount();
}