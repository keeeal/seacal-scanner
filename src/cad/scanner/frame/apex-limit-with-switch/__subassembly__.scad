use <../limit-switch.scad>
use <apex-limit.scad>
use <limit-switch-mount.scad>

module apex_limit_with_switch()
{
    apex_limit();
    translate([ 23, -19.8, 110 ]) rotate([ 0, -90, 0 ])
    {
        limit_switch_mount();
        translate([ 0, 0, -2 ]) limit_switch(pressed = true);
    }
}
