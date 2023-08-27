use <gopro-bolt.scad>
use <gopro-knob.scad>
use <gopro-nut.scad>

module gopro_nut_and_bolt()
{
    translate([ 0, 0, 14.5 ]) rotate([ 180, 0, 0 ]) gopro_bolt();
    translate([ 0, 0, 8 ]) gopro_knob();
    translate([ 0, 0, -10.5 ]) gopro_nut();
}
