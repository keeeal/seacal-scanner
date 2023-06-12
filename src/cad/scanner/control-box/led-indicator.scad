$fn = 32;
EPS = 1e-3;

module led_indicator(led_color = [ 0.8, 0.1, 0.1 ])
{
    color([ 0.8, 0.8, 0.8 ])
    {
        difference()
        {
            hull()
            {
                cylinder(h = 1, d = 10);
                cylinder(h = 1.5, d = 9);
            }
            translate([ 0, 0, EPS ]) cylinder(h = 1.5, d1 = 5, d2 = 8);
        }
        mirror([ 0, 0, 1 ]) hull()
        {
            cylinder(h = 9, d = 8);
            cylinder(h = 10, d = 7);
        }
        mirror([ 0, 0, 1 ]) cylinder(h = 13.5, d = 7);
        translate([ 0, 0, -6 ]) cylinder(h = 4, d = 10.5);
    }
    color(led_color) intersection()
    {
        translate([ 0, 0, -6 ]) sphere(r = 8);
        cylinder(h = 3, d1 = 5, d2 = 10);
    }
}
