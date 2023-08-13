use <arm/__subassembly__.scad>
use <control-box/__subassembly__.scad>
use <platform/__subassembly__.scad>

module scanner()
{
    arm();
    translate([ 450, 0, 0 ]) rotate([ 0, 0, 90 ]) control_box();
    platform();
}
