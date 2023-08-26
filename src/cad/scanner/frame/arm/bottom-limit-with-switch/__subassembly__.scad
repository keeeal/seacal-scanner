use <../../limit-switch.scad>
use <bottom-limit.scad>

module bottom_limit_with_switch()
{
    bottom_limit();
    translate([ -15.1, 18.5, -10 ])
        rotate([ 0, -90, 0 ]) limit_switch(pressed = false);
}
