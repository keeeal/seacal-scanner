use <arm/__subassembly__.scad>
use <control-box/__subassembly__.scad>
use <platform/__subassembly__.scad>

module scanner()
{
    arm();
    translate([500, 0, 0]) control_box();
    platform();
}
