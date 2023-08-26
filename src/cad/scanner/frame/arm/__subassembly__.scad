use <../aluminium-tube.scad>
use <cap.scad>
use <corner.scad>
use <gopro-mount.scad>
use <axle.scad>
use <bottom-limit-with-switch/__subassembly__.scad>

module aluminium_tubes()
{
    translate([ 318.5, 450, 0 ]) rotate([ 90, 0, 0 ]) _aluminium_tube(900);
    translate([ -318.5, 450, 0 ]) rotate([ 90, 0, 0 ]) _aluminium_tube(900);
    translate([ -300, 463.5, 0 ]) rotate([ 0, 90, 0 ]) _aluminium_tube(600);
}

module arm()
{
    translate([ 0, 0, 0 ]) aluminium_tubes();

    translate([ -318.5, 0, 0 ]) rotate([ 90, 0, 0 ]) axle();
    translate([ 318.5, 0, 0 ]) rotate([ 90, 0, 0 ]) mirror([ 1, 0, 0 ]) axle();

    translate([ -318.5, 463.5, 0 ]) corner();
    translate([ 318.5, 463.5, 0 ]) mirror([ 1, 0, 0 ]) corner();
    translate([ 318.5, -452.5, 0 ]) mirror([ 0, 1, 0 ]) cap();
    translate([ -318.5, -452.5, 0 ]) mirror([ 0, 1, 0 ]) cap();

    translate([ 0, 463.5, 0 ]) rotate([ 90, 0, 90 ]) gopro_mount();
    translate([ 260, 463.5, 0 ]) rotate([ 90, -90, 90 ]) bottom_limit_with_switch();
}
