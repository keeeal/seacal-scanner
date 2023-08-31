use <../../utils/motors/nema17.scad>

module pulley()
{
    module half()
    {
        cylinder(1, r = 15);
        translate([ 0, 0, 1 ]) cylinder(8, 15, 30);
        translate([ 0, 0, 9 ]) cylinder(1, r = 30);
    }

    difference()
    {
        union()
        {
            half();
            mirror([ 0, 0, 1 ]) half();
        }
        translate([ 0, 18, 0 ]) cylinder(h = 100, r = 1.5);
        linear_extrude(21, center = true) difference()
        {
            circle(d = 5.5);
            translate([ -5, 2, 0 ]) square(10);
        }
        difference()
        {
            cylinder(21, r = 13.4, center = true);
            cylinder(22, d = 8.7, center = true);
            for (n = [0:4])
                rotate([ 0, 0, n * 360 / 5 ])
                    translate([ 0, 25, 0 ]) cube([ 1.6, 50, 22 ], center = true);
        }
    }
}
