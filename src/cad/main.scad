
use <utils/gears.scad>
use <utils/nema17.scad>
use <utils/2d.scad>

$fn = 64;

// which part to render
part="all"; // [bearing, plate-gear, base-gear, base-motor, base, all]

module bearing() {
    translate([0, 0, -8])
    linear_extrude(1) difference() {
        circle(152);
        circle(114);
    }
    translate([0, 0, -1]) linear_extrude(1) difference() {
        circle(152);
        circle(81);
    }
}

module plate_gear() {
    translate([0, 0, -13]) difference() {
        linear_extrude(12) difference() {
            circle(d=225);
            circle(d=156);
        }
        translate([0, 0, 5]) {
            difference() {
                simple_gear(140, 5, 1024);
                translate([0, 0, -1]) cylinder(7, r=80);
            }
            mirror([0, 0, 1]) difference() {
                simple_gear(140, 5, 1024);
                translate([0, 0, -1]) cylinder(7, r=80);
            }
        }
        for (i = [0:3]) rotate([0, 0, i * 90]) {
            translate([108, 0, -1]) cylinder(100, d=5);
            translate([108, 0, -1]) rotate([0, 0, 30]) cylinder(11, d=8, $fn=6);
        }

    }
}

module base_gear(tol_x = .2, tol_z = .4) {
    translate([91, 0, -3]) rotate([180, 0, 0]) difference() {
        translate([0, 0, 5]) union() {
            simple_gear(12, 5 - tol_z, -1024);
            mirror([0, 0, 1]) simple_gear(12, 5 - tol_z, -1024);
            cylinder(15, r=5);
        }
        translate([0, 0, -1]) linear_extrude(100) difference() {
            circle(2.5 + tol_x);
            translate([7 + tol_x, 0]) square([10, 10], true);
        }
    }
}

module base_motor() {
    translate([91, 0, -24]) rotate([180, 0, 0]) nema17();
}

module base() {
    translate([0, 0, -8]) difference() {
        union() {
            difference() {
                hull() {
                    translate([0, 0, -1]) linear_extrude(1) circle(r=140);
                    translate([0, 0, -60]) linear_extrude(2) squircle(r=160);
                }
                hull() {
                    translate([0, 0, -3]) linear_extrude(1) circle(r=115);
                    translate([0, 0, -61]) linear_extrude(2) squircle(r=130);
                }
                translate([0, 0, -3]) linear_extrude(4) circle(r=115);
            }
            translate([91, 0, -60]) difference() {
                translate([15, 0, 0]) linear_extrude(45) rounded_square([77, 47], r=7, center=true);
                translate([50, 0, -2]) linear_extrude(45) rounded_square([143, 43], r=5, center=true);
                translate([0, 0, -1]) cylinder(100, r=12);
                for (i = [0, 1, 2, 3]) rotate([0, 0, i*90])
                    translate([31.04/2, 31.04/2, 0]) cylinder(100, d=4);
            }
        }
        translate([150, 0, -62]) hull() {
            linear_extrude(10) square([100, 20], center=true);
            translate([0, 0, 10])  linear_extrude(2) square([100, 16], center=true);
        }
        for (i = [0:3]) rotate([0, 0, i * 90]) {
            translate([85, 85, -60]) cylinder(100, d=5);
            translate([85, 85, -60]) cylinder(58, d=20);
        }
    }
    translate([151, 0, -48]) rotate([0, 70, 0]) linear_extrude(4) rotate([0, 0, 90])
    text("S  E  A  C  A  L", size=12, halign="center", valign="center");
}

if ((part == "bearing") || (part == "all")) color([0.8, 0.8, 0.8]) bearing();
if ((part == "plate-gear") || (part == "all")) plate_gear();
if ((part == "base-motor") || (part == "all")) base_motor();
if ((part == "base-gear") || (part == "all")) base_gear();
if ((part == "base") || (part == "all")) base();
