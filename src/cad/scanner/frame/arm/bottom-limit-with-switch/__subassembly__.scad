use <../../limit-switch.scad>
use <bottom-limit.scad>

module bottom_limit_with_switch()
{
    bottom_limit();
    translate([ -8.1, 18.5, 0 ]) rotate([ 0, -90, 0 ]) limit_switch(pressed = false);
}
