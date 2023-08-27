use <clamp-a.scad>
use <clamp-b.scad>
use <clamp-bolt.scad>
use <clamp-knob.scad>
use <clamp-nut.scad>
use <clamp-screw.scad>
use <clamp-extender.scad>

module phone_clamp()
{
    translate([ -20, 0, 0 ]) clamp_a();
    translate([ +20, 0, 0 ]) clamp_b();
    translate([ 45, 0, 0 ]) rotate([ 0, -90, 0 ]) clamp_bolt();
    translate([ 22, 0, 0 ]) rotate([ 0, -90, 0 ]) rotate([ 0, 0, 30 ]) clamp_nut();
    translate([ 34.5, 0, 0 ]) rotate([ 0, 90, 0 ]) rotate([ 0, 0, 30 ]) clamp_knob();
    translate([ 45.2, 0, 0 ]) rotate([ 0, 90, 0 ]) rotate([ 0, 0, 135 ]) clamp_screw();
    translate([ -47.5, -1, -8.5 ]) rotate([ 0, 90, 0 ]) clamp_extender();
}
