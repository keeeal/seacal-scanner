use <aluminium-tube.scad>
use <apex.scad>
use <arm-motor-mount.scad>
use <arm-motor.scad>
use <axle.scad>
use <cap.scad>
use <corner.scad>
use <foot.scad>
use <gopro-mount.scad>

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
    translate([ 318.5, 450, 573.5 ]) rotate([ 90, 0, 0 ]) aluminium_tube(900);
    translate([ -318.5, 450, 573.5 ]) rotate([ 90, 0, 0 ]) aluminium_tube(900);
    translate([ -300, 463.5, 573.5 ]) rotate([ 0, 90, 0 ]) aluminium_tube(600);
}

module arm()
{
    color([ 0.3, 0.3, 0.3 ]) all_aluminium_tubes();

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
