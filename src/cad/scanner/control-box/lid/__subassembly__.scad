use <lid-without-components.scad>
use <led-indicator.scad>
use <start-button.scad>

module lid()
{
    lid_without_components();
    translate([ -5, 10, 1.6 ]) led_indicator(led_color = [ 0.8, 0.1, 0.1 ]);
    translate([ -25, 10, 1.6 ]) led_indicator(led_color = [ 0.1, 0.8, 0.1 ]);
    translate([ 20, 10, 1.6 ]) start_button();
}
