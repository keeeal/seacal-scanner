module _aluminium_tube(height, center = false)
{
    module profile() difference()
    {
        square([ 25.5, 25.5 ], center = true);
        square([ 23, 23 ], center = true);
    }
    color([ 0.3, 0.3, 0.3 ]) linear_extrude(height, center = center) profile();
}
