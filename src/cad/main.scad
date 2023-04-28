
use <utils/gears.scad>
use <utils/nema17.scad>
use <utils/2d.scad>

$fn = 64;

// which part to render
part="all"; // [bearing, plate-gear, base-gear, base-motor, base, foot, apex, axle, corner, cap, all]

module bearing() {
    linear_extrude(1) difference() {
        circle(152);
        circle(114);
    }
    translate([0, 0, 7]) linear_extrude(1) difference() {
        circle(152);
        circle(81);
    }
}

module plate_gear() {
    difference() {
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
    difference() {
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

module base_motor() nema17();

module base() {
    difference() {
        union() {
            difference() {
                hull() {
                    translate([0, 0, 59]) linear_extrude(1) circle(r=140);
                    linear_extrude(2) squircle(r=160);
                }
                hull() {
                    translate([0, 0, 57]) linear_extrude(1) circle(r=115);
                    translate([0, 0, -1]) linear_extrude(2) squircle(r=130);
                }
                translate([0, 0, 57]) linear_extrude(4) circle(r=115);
            }
            translate([91, 0, 0]) difference() {
                translate([15, 0, 0]) linear_extrude(45) rounded_square([77, 47], r=7, center=true);
                translate([50, 0, -2]) linear_extrude(45) rounded_square([143, 43], r=5, center=true);
                translate([0, 0, -1]) cylinder(100, r=12);
                for (i = [0, 1, 2, 3]) rotate([0, 0, i*90])
                    translate([31.04/2, 31.04/2, 0]) cylinder(100, d=4);
            }
        }
        translate([150, 0, -2]) hull() {
            linear_extrude(10) square([100, 20], center=true);
            translate([0, 0, 10])  linear_extrude(2) square([100, 16], center=true);
        }
        for (i = [0:3]) rotate([0, 0, i * 90]) {
            translate([85, 85, 0]) cylinder(100, d=5);
            translate([85, 85, 0]) cylinder(58, d=20);
        }
    }
    // translate([151, 0, 68-48]) rotate([0, 70, 0]) linear_extrude(4) rotate([0, 0, 90])
    // text("S  E  A  C  A  L", size=12, halign="center", valign="center");
}

module foot() {
    module wedge(height) hull() {
        linear_extrude(height - 11) square([23, 6], center=true);
        linear_extrude(height - 3) square([20, 6], center=true);
    }
    module end(height) {
        hull() {
            linear_extrude(height) square([18, 18], center=true);
            linear_extrude(height - 2) square([22, 22], center=true);
        }
        wedge(height);
        rotate(90) wedge(height);
    }
    module profile(size, r) difference() {
        square(size, center=true);
        translate([-size[0] / 2, size[1] / 2]) circle(r, $fn=4);
    }

    difference() {
        union() {
            hull() {
                translate([0, 0, -20]) linear_extrude(2, center=true) rounded_square([26, 26], r=2, center=true, $fn=4);
                translate([0, 0, -14]) linear_extrude(2, center=true) profile([26, 30], r=2);
                translate([0, 0, 12]) linear_extrude(2, center=true) profile([26, 30], r=2);
                translate([0, -15, 25.5 / 2]) rotate([30, 0, 0]) translate([0, 13, -1])
                    linear_extrude(2, center=true) rounded_square([26, 26], r=2, center=true, $fn=4);
            }
            rotate([90, 0, 0]) end(43);
            translate([0, 0, 12.5]) rotate([30, 0, 0]) end(33);
        }
        translate([-11, 0, 0]) rotate([0, 90, 0]) linear_extrude(100)
        minkowski() {
            square(24, center=true);
            circle(1, $fn=4);
        }
    }

    for (i = [0, 1, 2, 3]) rotate([90 * i])
    translate([-12, 0, 13]) rotate([0, 90, 0]) translate([-11, 0, 0]) intersection() {
        wedge(27);
        translate([10, -4, 0]) cube([2, 8, 27]);
    }
}

module aluminium() {
    module tube(height, center=false) {
        module profile() difference() {
            square([25.5, 25.5], center=true);
            square([23, 23], center=true);
        }
        linear_extrude(height, center=center) profile();
    }
    translate([-300, -315, 21]) rotate([0, 90, 0]) tube(600);
    translate([-300,  315, 21]) rotate([0, 90, 0]) tube(600);
    translate([-289, 300, 21]) rotate([0, 90, -90]) tube(600);
    translate([-289, 300, 21 + 25.5 / 2]) rotate([-60, 0, 0])
        translate([0, 0, 25.5 / 2]) rotate([0, 90, -90]) tube(600);
    translate([ 289, 300, 21]) rotate([0, 90, -90]) tube(600);
    translate([ 289, 300, 21 + 25.5 / 2]) rotate([-60, 0, 0])
        translate([0, 0, 25.5 / 2]) rotate([0, 90, -90]) tube(600);
    mirror([0, 1, 0]) translate([ 289, 300, 21 + 25.5 / 2]) rotate([-60, 0, 0])
        translate([0, 0, 25.5 / 2]) rotate([0, 90, -90]) tube(600);
    mirror([0, 1, 0]) translate([-289, 300, 21 + 25.5 / 2]) rotate([-60, 0, 0])
        translate([0, 0, 25.5 / 2]) rotate([0, 90, -90]) tube(600);
}

module apex() {
    module wedge(height) hull() {
        linear_extrude(height - 11) square([23, 6], center=true);
        linear_extrude(height - 3) square([20, 6], center=true);
    }
    module end(height) {
        hull() {
            linear_extrude(height) square([18, 18], center=true);
            linear_extrude(height - 2) square([22, 22], center=true);
        }
        wedge(height);
        rotate(90) wedge(height);
    }

    difference() {
        hull() {
            rotate([0, -30, 0]) linear_extrude(28) translate([ 13, 0])
                rounded_square([26, 26], r=2, center=true, $fn=4);
            rotate([0,  30, 0]) linear_extrude(28) translate([-13, 0])
                rounded_square([26, 26], r=2, center=true, $fn=4);
        }
        translate([0, 0, 20])  rotate([90, 0, 0]) cylinder(39, d=13, center=true);
    }
    rotate([0,  150, 0]) translate([-13, 0, -10]) end(43);
    rotate([0, -150, 0]) translate([ 13, 0, -10]) end(43);
}

module axle() {
    difference() {
        hull() {
            linear_extrude(60, center=true) rounded_square(28.6, r=1.8, center=true);
            linear_extrude(58, center=true) rounded_square(30.2, r=2.6, center=true);
        }
        linear_extrude(62, center=true) rounded_square(27, r=1, center=true);
    }
    for (n = [-1:1]) translate([0, 0, n * 12])
        for (i = [0:3]) rotate(90 * i)
            hull() {
                translate([-5, 14, -4]) sphere(0.5);
                translate([ 5, 14, -4]) sphere(0.5);
                translate([-5, 13.2, 0]) sphere(0.5);
                translate([ 5, 13.2, 0]) sphere(0.5);
                translate([-5, 14, +4]) sphere(0.5);
                translate([ 5, 14, +4]) sphere(0.5);
            }
    translate([14, 0, 0]) rotate([0, 90, 0]) {
        cylinder(2, d=22);
        difference() {
            intersection() {
                union() {
                    cylinder(29, d=12);
                    translate([0, 0, 28.5]) cylinder(5, d1=15, d2=10.5);
                }
                linear_extrude(100) square([9.5, 100], center=true);
            }
            hull() {
                translate([0, 0, 10]) rotate([0, 90, 0]) cylinder(100, d=4, center=true);
                translate([0, 0, 100]) rotate([0, 90, 0]) cylinder(100, d=4, center=true);
            }
        }
    }
}

module corner() {
    module wedge(height) hull() {
        linear_extrude(height - 11) square([23, 6], center=true);
        linear_extrude(height - 3) square([20, 6], center=true);
    }
    module end(height) {
        hull() {
            linear_extrude(height) square([18, 18], center=true);
            linear_extrude(height - 2) square([22, 22], center=true);
        }
        wedge(height);
        rotate(90) wedge(height);
    }
    module profile(size, r) difference() {
        square(size, center=true);
        translate([-size[0] / 2, size[1] / 2]) circle(r, $fn=4);
    }

    difference() {
        union() {
            hull() {
                translate([0, 0, -14]) linear_extrude(2, center=true) profile([26, 26], r=2);
                translate([0, 0, 12]) linear_extrude(2, center=true) profile([26, 26], r=2);
            }
            rotate([90, 0, 0]) end(43);
            rotate([0, 90, 0]) end(43);
        }
    }
}

module cap() {
    module wedge(height) hull() {
        linear_extrude(height - 11) square([23, 6], center=true);
        linear_extrude(height - 3) square([20, 6], center=true);
    }
    module end(height) {
        hull() {
            linear_extrude(height) square([18, 18], center=true);
            linear_extrude(height - 2) square([22, 22], center=true);
        }
        wedge(height);
        rotate(90) wedge(height);
    }
    module profile(size, r) difference() {
        square(size, center=true);
        translate([-size[0] / 2, size[1] / 2]) circle(r, $fn=4);
        translate([ size[0] / 2, size[1] / 2]) circle(r, $fn=4);
    }

    difference() {
        union() {
            hull() {
                translate([0, 0, -14]) linear_extrude(2, center=true) profile([26, 4], r=2);
                translate([0, 0, 12]) linear_extrude(2, center=true) profile([26, 4], r=2);
            }
            rotate([90, 0, 0]) end(32);
        }
    }
}

if (part == "all") {
    translate([0, 0, 60]) color([0.8, 0.8, 0.8]) bearing();
    // translate([0, 0, 54]) plate_gear();
    translate([91, 0, 43]) rotate([180, 0, 0]) base_motor();
    translate([91, 0, 64]) rotate([180, 0, 0]) base_gear();
    base();

    color([0.3, 0.3, 0.3]) aluminium();

    translate([-289,  315, 21]) foot();
    translate([ 289,  315, 21]) mirror([1, 0, 0]) foot();
    translate([ 289, -315, 21]) rotate([0, 0, 180]) foot();
    translate([-289, -315, 21]) rotate([0, 0, 180]) mirror([1, 0, 0]) foot();
}

if (part == "bearing") color([0.8, 0.8, 0.8]) bearing();
if (part == "plate-gear") plate_gear();
if (part == "base-motor") base_motor();
if (part == "base-gear") base_gear();
if (part == "base") base();
if (part == "foot") foot();
if (part == "apex") apex();
if (part == "axle") axle();
if (part == "corner") corner();
if (part == "cap") cap();
