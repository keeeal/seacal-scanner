use <aluminium-tube.scad>
use <apex.scad>
use <apex-limit-with-switch/__subassembly__.scad>
use <arm-motor/arm-motor-mount.scad>
use <arm-motor/pulley.scad>
use <foot.scad>
use <arm/__subassembly__.scad>
use <arm-motor/__subassembly__.scad>

module aluminium_tubes()
{
    translate([ -300, -315, 21 ]) rotate([ 0, 90, 0 ]) _aluminium_tube(600);
    translate([ -300, 315, 21 ]) rotate([ 0, 90, 0 ]) _aluminium_tube(600);
    translate([ -284.25, 300, 21 ]) rotate([ 0, 90, -90 ]) _aluminium_tube(600);
    translate([ -284.25, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) _aluminium_tube(600);
    translate([ 284.25, 300, 21 ]) rotate([ 0, 90, -90 ]) _aluminium_tube(600);
    translate([ 284.25, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) _aluminium_tube(600);
    mirror([ 0, 1, 0 ]) translate([ 284.25, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) _aluminium_tube(600);
    mirror([ 0, 1, 0 ]) translate([ -284.25, 300, 21 + 25.5 / 2 ]) rotate([ -60, 0, 0 ])
        translate([ 0, 0, 25.5 / 2 ]) rotate([ 0, 90, -90 ]) _aluminium_tube(600);
}

module frame()
{
    aluminium_tubes();

    translate([ -284.25, 315, 21 ]) foot();
    translate([ 284.25, 315, 21 ]) mirror([ 1, 0, 0 ]) foot();
    translate([ 284.25, -315, 21 ]) rotate([ 0, 0, 180 ]) foot();
    translate([ -284.25, -315, 21 ]) rotate([ 0, 0, 180 ]) mirror([ 1, 0, 0 ]) foot();
    translate([ -284.25, 0, 553.5 ]) rotate([ 0, 0, 90 ]) apex();
    translate([ 284.25, 0, 553.5 ]) rotate([ 0, 0, 90 ]) mirror([ 1, 0, 0 ]) apex_limit_with_switch();

    translate([ 284.25, 100, 21 ]) rotate([ 0, 0, 90 ]) arm_motor();
    translate([ 0, 0, 573.5 ]) rotate([ -55, 0, 0 ]) arm();
}
