$fn = 32;  // [16:128]

use <src/cad/scanner/__subassembly__.scad>
use <src/cad/scanner/control-box/__subassembly__.scad>
use <src/cad/scanner/control-box/box/__subassembly__.scad>
use <src/cad/scanner/control-box/box/box-without-components.scad>
use <src/cad/scanner/control-box/box/fan.scad>
use <src/cad/scanner/control-box/box/gx12.scad>
use <src/cad/scanner/control-box/box/gx16.scad>
use <src/cad/scanner/control-box/lid/__subassembly__.scad>
use <src/cad/scanner/control-box/lid/led-indicator.scad>
use <src/cad/scanner/control-box/lid/lid-text.scad>
use <src/cad/scanner/control-box/lid/lid-without-components.scad>
use <src/cad/scanner/control-box/lid/start-button.scad>
use <src/cad/scanner/control-box/pcb/__subassembly__.scad>
use <src/cad/scanner/control-box/pcb/arduino.scad>
use <src/cad/scanner/control-box/pcb/dupont.scad>
use <src/cad/scanner/control-box/pcb/prototype-board.scad>
use <src/cad/scanner/control-box/pcb/stepper-controller.scad>
use <src/cad/scanner/control-box/stop-button.scad>
use <src/cad/scanner/frame/__subassembly__.scad>
use <src/cad/scanner/frame/apex-limit-with-switch/__subassembly__.scad>
use <src/cad/scanner/frame/apex-limit-with-switch/apex-limit.scad>
use <src/cad/scanner/frame/apex-limit-with-switch/limit-switch-mount.scad>
use <src/cad/scanner/frame/apex.scad>
use <src/cad/scanner/frame/arm/__subassembly__.scad>
use <src/cad/scanner/frame/arm/axle-screw.scad>
use <src/cad/scanner/frame/arm/axle.scad>
use <src/cad/scanner/frame/arm/bottom-limit-with-switch/__subassembly__.scad>
use <src/cad/scanner/frame/arm/bottom-limit-with-switch/bottom-limit.scad>
use <src/cad/scanner/frame/arm/cap.scad>
use <src/cad/scanner/frame/arm/corner.scad>
use <src/cad/scanner/frame/arm/gopro-mount.scad>
use <src/cad/scanner/frame/arm/gopro-nut-and-bolt/__subassembly__.scad>
use <src/cad/scanner/frame/arm/gopro-nut-and-bolt/gopro-bolt.scad>
use <src/cad/scanner/frame/arm/gopro-nut-and-bolt/gopro-knob.scad>
use <src/cad/scanner/frame/arm/gopro-nut-and-bolt/gopro-nut.scad>
use <src/cad/scanner/frame/arm/phone-clamp/__subassembly__.scad>
use <src/cad/scanner/frame/arm/phone-clamp/clamp-a.scad>
use <src/cad/scanner/frame/arm/phone-clamp/clamp-b.scad>
use <src/cad/scanner/frame/arm/phone-clamp/clamp-bolt.scad>
use <src/cad/scanner/frame/arm/phone-clamp/clamp-extender.scad>
use <src/cad/scanner/frame/arm/phone-clamp/clamp-knob.scad>
use <src/cad/scanner/frame/arm/phone-clamp/clamp-nut.scad>
use <src/cad/scanner/frame/arm/phone-clamp/clamp-screw.scad>
use <src/cad/scanner/frame/arm-motor/__subassembly__.scad>
use <src/cad/scanner/frame/arm-motor/arm-motor-mount.scad>
use <src/cad/scanner/frame/arm-motor/pulley.scad>
use <src/cad/scanner/frame/cable-clip.scad>
use <src/cad/scanner/frame/foot.scad>
use <src/cad/scanner/frame/limit-switch.scad>
use <src/cad/scanner/platform/__subassembly__.scad>
use <src/cad/scanner/platform/base-motor.scad>
use <src/cad/scanner/platform/bearing.scad>
use <src/cad/scanner/platform/motor-gear.scad>
use <src/cad/scanner/platform/platform-base/__subassembly__.scad>
use <src/cad/scanner/platform/platform-base/badge.scad>
use <src/cad/scanner/platform/platform-base/base-without-badge.scad>
use <src/cad/scanner/platform/platform-gear.scad>
use <src/cad/scanner/platform/platform-top.scad>

part = "scanner";  // ["scanner", "├─ control-box", "│  ├─ box", "│  │  ├─ box-without-components", "│  │  ├─ fan", "│  │  ├─ gx12", "│  │  ├─ gx16", "│  ├─ lid", "│  │  ├─ led-indicator", "│  │  ├─ lid-text", "│  │  ├─ lid-without-components", "│  │  ├─ start-button", "│  ├─ pcb", "│  │  ├─ arduino", "│  │  ├─ dupont", "│  │  ├─ prototype-board", "│  │  ├─ stepper-controller", "│  ├─ stop-button", "├─ frame", "│  ├─ apex-limit-with-switch", "│  │  ├─ apex-limit", "│  │  ├─ limit-switch-mount", "│  ├─ apex", "│  ├─ arm", "│  │  ├─ axle-screw", "│  │  ├─ axle", "│  │  ├─ bottom-limit-with-switch", "│  │  │  ├─ bottom-limit", "│  │  ├─ cap", "│  │  ├─ corner", "│  │  ├─ gopro-mount", "│  │  ├─ gopro-nut-and-bolt", "│  │  │  ├─ gopro-bolt", "│  │  │  ├─ gopro-knob", "│  │  │  ├─ gopro-nut", "│  │  ├─ phone-clamp", "│  │  │  ├─ clamp-a", "│  │  │  ├─ clamp-b", "│  │  │  ├─ clamp-bolt", "│  │  │  ├─ clamp-extender", "│  │  │  ├─ clamp-knob", "│  │  │  ├─ clamp-nut", "│  │  │  ├─ clamp-screw", "│  ├─ arm-motor", "│  │  ├─ arm-motor-mount", "│  │  ├─ pulley", "│  ├─ cable-clip", "│  ├─ foot", "│  ├─ limit-switch", "├─ platform", "│  ├─ base-motor", "│  ├─ bearing", "│  ├─ motor-gear", "│  ├─ platform-base", "│  │  ├─ badge", "│  │  ├─ base-without-badge", "│  ├─ platform-gear", "│  ├─ platform-top"]

if (part == "scanner") scanner();
if (part == "├─ control-box") control_box();
if (part == "│  ├─ box") box();
if (part == "│  │  ├─ box-without-components") box_without_components();
if (part == "│  │  ├─ fan") fan();
if (part == "│  │  ├─ gx12") gx12();
if (part == "│  │  ├─ gx16") gx16();
if (part == "│  ├─ lid") lid();
if (part == "│  │  ├─ led-indicator") led_indicator();
if (part == "│  │  ├─ lid-text") lid_text();
if (part == "│  │  ├─ lid-without-components") lid_without_components();
if (part == "│  │  ├─ start-button") start_button();
if (part == "│  ├─ pcb") pcb();
if (part == "│  │  ├─ arduino") arduino();
if (part == "│  │  ├─ dupont") dupont();
if (part == "│  │  ├─ prototype-board") prototype_board();
if (part == "│  │  ├─ stepper-controller") stepper_controller();
if (part == "│  ├─ stop-button") stop_button();
if (part == "├─ frame") frame();
if (part == "│  ├─ apex-limit-with-switch") apex_limit_with_switch();
if (part == "│  │  ├─ apex-limit") apex_limit();
if (part == "│  │  ├─ limit-switch-mount") limit_switch_mount();
if (part == "│  ├─ apex") apex();
if (part == "│  ├─ arm") arm();
if (part == "│  │  ├─ axle-screw") axle_screw();
if (part == "│  │  ├─ axle") axle();
if (part == "│  │  ├─ bottom-limit-with-switch") bottom_limit_with_switch();
if (part == "│  │  │  ├─ bottom-limit") bottom_limit();
if (part == "│  │  ├─ cap") cap();
if (part == "│  │  ├─ corner") corner();
if (part == "│  │  ├─ gopro-mount") gopro_mount();
if (part == "│  │  ├─ gopro-nut-and-bolt") gopro_nut_and_bolt();
if (part == "│  │  │  ├─ gopro-bolt") gopro_bolt();
if (part == "│  │  │  ├─ gopro-knob") gopro_knob();
if (part == "│  │  │  ├─ gopro-nut") gopro_nut();
if (part == "│  │  ├─ phone-clamp") phone_clamp();
if (part == "│  │  │  ├─ clamp-a") clamp_a();
if (part == "│  │  │  ├─ clamp-b") clamp_b();
if (part == "│  │  │  ├─ clamp-bolt") clamp_bolt();
if (part == "│  │  │  ├─ clamp-extender") clamp_extender();
if (part == "│  │  │  ├─ clamp-knob") clamp_knob();
if (part == "│  │  │  ├─ clamp-nut") clamp_nut();
if (part == "│  │  │  ├─ clamp-screw") clamp_screw();
if (part == "│  ├─ arm-motor") arm_motor();
if (part == "│  │  ├─ arm-motor-mount") arm_motor_mount();
if (part == "│  │  ├─ pulley") pulley();
if (part == "│  ├─ cable-clip") cable_clip();
if (part == "│  ├─ foot") foot();
if (part == "│  ├─ limit-switch") limit_switch();
if (part == "├─ platform") platform();
if (part == "│  ├─ base-motor") base_motor();
if (part == "│  ├─ bearing") bearing();
if (part == "│  ├─ motor-gear") motor_gear();
if (part == "│  ├─ platform-base") platform_base();
if (part == "│  │  ├─ badge") badge();
if (part == "│  │  ├─ base-without-badge") base_without_badge();
if (part == "│  ├─ platform-gear") platform_gear();
if (part == "│  ├─ platform-top") platform_top();
