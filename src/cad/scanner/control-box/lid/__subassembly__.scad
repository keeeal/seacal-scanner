use <lid-without-components.scad>
use <led-indicator.scad>
use <start-button.scad>

module lid()
{
    lid_without_components();
    translate([ -18, 12, 3 ]) led_indicator(led_color = [ 0.8, 0.1, 0.1 ]);
    translate([ -32, 12, 3 ]) led_indicator(led_color = [ 0.1, 0.8, 0.1 ]);
    translate([ -25, -12, 3 ]) start_button();
}
