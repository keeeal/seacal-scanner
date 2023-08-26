use <../limit-switch.scad>
use <apex-limit.scad>
use <limit-switch-mount.scad>

module apex_limit_with_switch() {
    apex_limit();
    translate([18, -19.8, 100]) rotate([0, -90, 0]) limit_switch_mount();
}
