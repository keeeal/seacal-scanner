use <../limit-switch.scad>

module limit_switch_mount() {
    limit_switch(pressed=true);

    translate([0, 0, -10]) linear_extrude(10) translate([10, 0]) difference() {
        translate([0, 0.7]) square([24.6, 12], center=true);
        square([21, 7], center=true);
    }

    translate([5, 3.5, -7]) sphere(1.2);
    translate([5, -3.5, -7]) sphere(1.2);
    translate([15, 3.5, -7]) sphere(1.2);
    translate([15, -3.5, -7]) sphere(1.2);

    translate([24.6/2-2.3, 6.6, -5.8]) cube([24.6/2, 3, 1.6]);
    translate([-2.3, 9, -10]) cube([24.6, 1.6, 10]);
}
