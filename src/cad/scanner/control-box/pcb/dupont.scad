
module dupont(num_pins = 1, height = 8.5, center = false) {
    dx = center ? 0 : 2.54 * num_pins / 2;
    dy = center ? 0 : 2.54 / 2;
    color([ 0.2, 0.2, 0.2 ]) translate([dx, dy, 0])  linear_extrude(height) difference() {
        square([2.54 * num_pins, 2.54], center = true);
        for (n = [-(num_pins - 1) / 2 : (num_pins - 1) / 2]) {
            translate([2.54 * n, 0]) square(1.5, center=true);
        }
    }
}
