
use <utils/gears.scad>

$fn = 64;

// which part to render
part="all"; // [bearing, inner-cog, all]

module bearing() {
    linear_extrude(1)
    difference() {
        circle(152);
        circle(114);
    }
    translate([0, 0, 7])
    linear_extrude(1)
    difference() {
        circle(152);
        circle(81);
    }
}

module inner_cog() {
    difference() {
        linear_extrude(7) difference() {
            circle(r=112);
            circle(r=78);
        }
        difference() {
            simple_gear(140, 5, 1024);
            translate([0, 0, -1]) cylinder(7, r=80);
        }
        for (i = [0:3]) rotate([0, 0, i * 90])
            translate([108, 0, 0]) cylinder(7, d=5);
    }
}

if ((part == "bearing") || (part == "all"))
    color([0.8, 0.8, 0.8]) bearing();

if ((part == "inner-cog") || (part == "all"))
    inner_cog();
