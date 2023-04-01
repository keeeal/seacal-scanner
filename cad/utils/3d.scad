
use <2d.scad>

module chamfered_cylinder(h, r1, r2, c=1) {
    hull() {
        cylinder(h, r1-c, r2-c);
        translate([0, 0, c]) cylinder(h-2*c, r1, r2);
    }
}

module squylinder(h, r) {
    linear_extrude(h) squircle(r);
}

module chamfered_squylinder(h, r, c=1) {
    hull() {
        squylinder(h, r-c);
        translate([0, 0, c]) squylinder(h-2*c, r);
    }
}
