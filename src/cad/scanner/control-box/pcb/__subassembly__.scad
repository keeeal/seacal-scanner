use <arduino.scad>
use <prototype-board.scad>
use <stepper-controller.scad>

module pcb()
{
    arduino();
    translate([ 0, 0, 13 ]) prototype_board();
    translate([ 21.5, 0, 17 ]) stepper_controller();
    translate([ 0.5, 0, 17 ]) stepper_controller();
}
