use <box-without-components.scad>
use <gx12.scad>
use <gx16.scad>
use <fan.scad>

module box()
{
    box_without_components();
    translate([ 0, 38.2, 40 ]) rotate([ -90, 0, 0 ]) gx16(num_pins = 4);
    translate([ 24, 38.2, 40 ]) rotate([ -90, 0, 0 ]) gx16(num_pins = 4);
    translate([ 47, 38.2, 38.5 ]) rotate([ -90, 0, 0 ]) gx12(num_pins = 4);
    translate([ 68, 38.2, 38.5 ]) rotate([ -90, 0, 0 ]) gx12(num_pins = 2);
    translate([ 77.5, 0, 30 ]) rotate([ 0, 90, 0 ]) fan();
}
