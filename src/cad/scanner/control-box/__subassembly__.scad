use <box/__subassembly__.scad>
use <lid/__subassembly__.scad>
use <pcb/__subassembly__.scad>
use <stop-button.scad>

module control_box()
{
    box();
    translate([ 35, -6, 10 ]) pcb();
    translate([ -53.5, 0, 2 ]) stop_button();
    translate([ 37.3, 0, 58.4 ]) lid();
}
