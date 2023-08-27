module bearing()
{
    linear_extrude(1) difference()
    {
        circle(152);
        circle(114);
    }
    translate([ 0, 0, 7 ]) linear_extrude(1) difference()
    {
        circle(152);
        circle(81);
    }
}
