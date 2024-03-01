use <../../../utils/motors/nema17.scad>
use <arm-motor-mount.scad>
use <pulley.scad>

module arm_motor()
{
    arm_motor_mount();
    translate([ 0, -14.5, 38.5 ]) rotate([ -90, -90, 0 ]) nema17_short();
    translate([ 0, -28, 38.5 ]) rotate([ 90, 0, 0 ]) pulley();
}
