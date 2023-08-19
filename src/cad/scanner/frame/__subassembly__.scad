use <aluminium-tube.scad>
use <apex.scad>
use <arm-motor-mount.scad>
use <arm-motor.scad>
use <foot.scad>
use <arm/__subassembly__.scad>

module all_aluminium_tubes()
{
    translate([ -300, -315, 21 ]) rotate([ 0, 90, 0 ]) aluminium_tube(600);
    translate([ -300, 315, 21 ]) rotate([ 0, 90, 0 ]) aluminium_tube(600);
    translate([ -289, 300, 21 ]) rotate([ 0, 90, -90 ]) aluminium_tube(600);
    translate([ -289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) aluminium_tube(600);
    translate([ 289, 300, 21 ]) rotate([ 0, 90, -90 ]) aluminium_tube(600);
    translate([ 289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) aluminium_tube(600);
    mirror([ 0, 1, 0 ]) translate([ 289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) aluminium_tube(600);
    mirror([ 0, 1, 0 ]) translate([ -289, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) aluminium_tube(600);
}

module frame()
{
    all_aluminium_tubes();

    translate([ -289, 315, 21 ]) foot();
    translate([ 289, 315, 21 ]) mirror([ 1, 0, 0 ]) foot();
    translate([ 289, -315, 21 ]) rotate([ 0, 0, 180 ]) foot();
    translate([ -289, -315, 21 ]) rotate([ 0, 0, 180 ]) mirror([ 1, 0, 0 ]) foot();
    translate([ -289, 0, 553.5 ]) rotate([ 0, 0, 90 ]) apex();
    translate([ 289, 0, 553.5 ]) rotate([ 0, 0, 90 ]) apex();

    translate([ 289, 0, 21 ]) rotate([ 0, 0, 90 ]) arm_motor_mount();
    translate([ 303, 0, 59.5 ]) rotate([ 0, -90, 0 ]) arm_motor();

    translate([ 0, 0, 573.5 ]) rotate([90, 0, 0])  arm();
}
