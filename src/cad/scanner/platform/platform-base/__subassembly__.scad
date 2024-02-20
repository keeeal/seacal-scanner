use <badge.scad>
use <base-without-badge.scad>

module platform_base()
{
    base_without_badge();
    // translate([ 156, 0, 31 ]) rotate([ 0, 80, 0 ]) rotate([ 0, 0, 90 ]) badge();
}
