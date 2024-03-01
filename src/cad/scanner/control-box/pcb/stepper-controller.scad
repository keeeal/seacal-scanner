
module heat_sink(height = 15)
{
    module profile()
    {
        difference()
        {
            translate([ -15 / 2, 0 ]) square([ 15, 13 ]);
            translate([ -15 / 2, 0 ]) circle(r = 2.5);
            translate([ 15 / 2, 0 ]) circle(r = 2.5);
            translate([ -5.8, 10 ]) square([ 1.5, 13 ], center = true);
            translate([ -3.5, 8 ]) square([ 1.5, 13 ], center = true);
            translate([ -1.2, 8 ]) square([ 1.5, 13 ], center = true);
            translate([ 1.2, 8 ]) square([ 1.5, 13 ], center = true);
            translate([ 3.5, 8 ]) square([ 1.5, 13 ], center = true);
            translate([ 5.8, 10 ]) square([ 1.5, 13 ], center = true);
        }
    }
    linear_extrude(height) profile();
}

module stepper_controller(heat_sink = true)
{
    color([ 0.7, 0.7, 0.7 ]) linear_extrude(height = 1.5) square([ 20.5, 15.5 ], center = true);
    color([ 0.2, 0.2, 0.2 ]) linear_extrude(height = 2) square([ 7, 7 ], center = true);
    translate([ 8, 3, 0 ])
    {
        color([ 0.7, 0.7, 0.7 ]) linear_extrude(height = 2) square([ 3, 3 ], center = true);
        color([ 0.6, 0.6, 0.6 ]) linear_extrude(height = 2.5) circle(d = 3);
    }
    if (heat_sink)
        color([ 0.2, 0.2, 0.8 ]) translate([ 0, 7.5, 2.5 ]) rotate([ 90, 0, 0 ]) heat_sink();
}
