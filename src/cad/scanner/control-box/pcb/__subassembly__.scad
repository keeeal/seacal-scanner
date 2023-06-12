use <arduino.scad>
use <prototype-board.scad>

module pcb()
{
    arduino();
    translate([ 0, 0, 13 ]) prototype_board();
}
