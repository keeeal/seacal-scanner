
use <parts/apex.scad>
use <parts/arm-motor-mount.scad>
use <parts/axle.scad>
use <parts/badge.scad>
use <parts/base-motor-gear.scad>
use <parts/base.scad>
use <parts/bearing-gear.scad>
use <parts/cap.scad>
use <parts/corner.scad>
use <parts/foot.scad>
use <parts/gopro-mount.scad>

part="assembly"; // [apex, arm-motor-mount, axle, badge, base-motor-gear, base, bearing-gear, cap, corner, foot, gopro-mount]

if (part == "apex") apex();
if (part == "arm-motor-mount") arm_motor_mount();
if (part == "axle") axle();
if (part == "badge") badge();
if (part == "base-motor-gear") base_motor_gear();
if (part == "base") base();
if (part == "bearing-gear") bearing_gear();
if (part == "cap") cap();
if (part == "corner") corner();
if (part == "foot") foot();
if (part == "gopro-mount") gopro_mount();
