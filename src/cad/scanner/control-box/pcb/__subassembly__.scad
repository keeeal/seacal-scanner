use <arduino.scad>
use <prototype-board.scad>
use <stepper-controller.scad>

module pcb()
{
    arduino();
    translate([ 0, 0, 13 ]) prototype_board();
    translate([ 18, 8, 17 ]) stepper_controller();
    translate([ -4, 8, 17 ]) stepper_controller();
}
