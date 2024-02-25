use <box/__subassembly__.scad>
use <lid/__subassembly__.scad>
use <pcb/__subassembly__.scad>
use <stop-button.scad>

module control_box()
{
    box();
    translate([ 50, -5, 10 ]) rotate(90) pcb();
    translate([ -40, 0, 2 ]) stop_button();
    // translate([ 37.3, 0, 58.4 ]) lid();
}
