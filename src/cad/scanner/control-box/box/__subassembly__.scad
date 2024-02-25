use <box-without-components.scad>
use <gx12.scad>
use <gx16.scad>
use <fan.scad>

module box()
{
    box_without_components();
    translate([ 23, 38.2, 40 ]) rotate([ -90, 0, 0 ]) gx16(num_pins = 4);
    translate([ 47, 38.2, 40 ]) rotate([ -90, 0, 0 ]) gx16(num_pins = 4);
    translate([ 70, 38.2, 38.5 ]) rotate([ -90, 0, 0 ]) gx12(num_pins = 4);
    translate([ 84, 0, 30 ]) rotate([ 0, 90, 0 ]) fan();
}
