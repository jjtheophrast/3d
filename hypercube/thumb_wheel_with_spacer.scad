// ******************************
// *   Parametric thumb wheel   *
// *   by Chris Garrett         *
// *   20-nov-2011			   *
// *	   Spacer added             *
// *	   by Bas Spaans            *
// *	   10-jan-2013              *
// ******************************


// *** Configuration variables ***
wheel_d = 20;    // Outer Diameter of the thumb wheel
wheel_h = 4;     // Height of the thumb wheel
hole_d = 4.5;    // Diameter of center hole
hex_sz = 7;      // Size of the hex (nut trap)
                 // An M4 nut fits perfectly in a 7mm hex opening made on my Prusa
hex_d = 3;       // Depth of the hex (set this < or = to wheel_h)
knurl_cnt = 12;  // Number of cutouts around the wheel
knurl_d = 3;     // Diameter of the cutouts

spacer_h = 4;	// Height of the spacer
spacer_d = 10;	// Diameter of the spacer


// *** Code area ***

module box(w,h,d) {
 translate([0,0,d/2]) scale ([w,h,d]) cube(1, true);
}

module hexagon(height, depth) {
 boxWidth=height/1.75;
 union() {
  box(boxWidth, height, depth);
  rotate([0,0,60]) box(boxWidth, height, depth);
  rotate([0,0,-60]) box(boxWidth, height, depth);
 }
}


// The thumb wheel 

difference() {
 union() {
	cylinder(h=wheel_h, r=wheel_d/2, $fn=50);
	translate([0,0,-spacer_h]) cylinder(h=spacer_h, r=spacer_d/2, $fn=50); 
	}
 translate([0,0,-(spacer_h+1)]) cylinder(h=wheel_h+spacer_h+2, r=hole_d/2, $fn=50);
 if (hex_d >= wheel_h) {
   translate([0,0,-1]) hexagon(height=hex_sz, depth=wheel_d+2);
 } else {
  translate([0,0,wheel_h-hex_d]) hexagon(height=hex_sz, depth=hex_d+1);
 }
 for(i = [0:knurl_cnt-1]) {
  rotate(v=[0,0,1], a=i*360/knurl_cnt) translate([0,wheel_d/2,-1]) cylinder(h=wheel_h+2, r=knurl_d/2, $fn=50);
 }
}