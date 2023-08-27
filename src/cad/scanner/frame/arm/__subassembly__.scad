use <../aluminium-tube.scad>
use <axle-screw.scad>
use <axle.scad>
use <bottom-limit-with-switch/__subassembly__.scad>
use <cap.scad>
use <corner.scad>
use <gopro-mount.scad>
use <bottom-limit-with-switch/__subassembly__.scad>
use <phone-clamp/__subassembly__.scad>
use <gopro-nut-and-bolt/__subassembly__.scad>

module aluminium_tubes()
{
    translate([ 313.5, 450, 0 ]) rotate([ 90, 0, 0 ]) _aluminium_tube(900);
    translate([ -313.5, 450, 0 ]) rotate([ 90, 0, 0 ]) _aluminium_tube(900);
    translate([ -300, 463.5, 0 ]) rotate([ 0, 90, 0 ]) _aluminium_tube(600);
}

module arm()
{
    translate([ 0, 0, 0 ]) aluminium_tubes();

    translate([ -313.5, 0, 0 ]) rotate([ 90, 0, 0 ]) axle();
    translate([ -345, 0, 0 ]) rotate([ 0, 90, 0 ]) axle_screw();
    translate([ 313.5, 0, 0 ]) rotate([ 90, 0, 0 ]) rotate([ 0, 180, 0 ]) axle();
    translate([ 345, 0, 0 ]) rotate([ 0, 90, 0 ]) rotate([ 0, 180, 0 ]) axle_screw();

    translate([ -313.5, 463.5, 0 ]) corner();
    translate([ 313.5, 463.5, 0 ]) mirror([ 1, 0, 0 ]) corner();
    translate([ 313.5, -452.5, 0 ]) mirror([ 0, 1, 0 ]) cap();
    translate([ -313.5, -452.5, 0 ]) mirror([ 0, 1, 0 ]) cap();

    translate([ 280, 463.5, 0 ]) rotate([ 90, -90, 90 ]) bottom_limit_with_switch();
    translate([ -25, 463.5, 0 ]) rotate([ 90, 0, 90 ]) gopro_mount();
    translate([ 0, 415.5, 0 ]) rotate([ 90, 0, 0 ]) phone_clamp();
    translate([ -47.5, 409, 0 ]) gopro_nut_and_bolt();
    translate([ -47.5, 439, 0 ]) gopro_nut_and_bolt();
}
