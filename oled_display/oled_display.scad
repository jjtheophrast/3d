// Parameters for the OLED display (adjust as needed)
display_width = 36;      // width of the OLED display
display_height = 34;     // height of the OLED display board
display_thickness = 12;  // thickness of the display board
screen_width = 31;       // visible width of the OLED screen
screen_height = 15;      // visible height of the OLED screen
border_thickness = 1.5;    // thickness of case borders
case_depth = 9;          // depth of the front case part
screw_hole_diameter = 5; // diameter of screw holes
offsetX = 4.5;             // distance of screw holes from the left and right edges
offsetY = 4.5;             // distance of screw holes from the top and 

// Parameters for the OLED inner part with corner extrusions
inner_depth = case_depth - display_thickness; // Depth of the inner part to fit inside the front case
inner_border_thickness = 1; // Thickness of the inner border for stability

extrusion_height = 3;
extrusion_side_length=8;
inner_plate_thickness=2;
inner_plate_snapping_tolerance=1;


  // Outer case dimensions
    outer_width = display_width + 2 * border_thickness;
    outer_height = display_height + 2 * border_thickness;
    
module oled_inner_part() {
    // Inner part dimensions, slightly smaller than outer case inner cavity
    inner_width = display_width -inner_plate_snapping_tolerance;
    inner_height = display_height -inner_plate_snapping_tolerance;
translate([0,0,-6]){
    difference(){
    translate([0,0,-extrusion_height/2])
        cube([inner_width, inner_height, inner_plate_thickness+extrusion_height], center = true);
    
   
    cube([inner_width-2*extrusion_side_length, inner_height, extrusion_height], center = true);
    cube([inner_width, inner_height-2*extrusion_side_length, extrusion_height], center = true);

// Round screw holes in each corner with separate offsetX and offsetY
        for (x = [-outer_width / 2 + offsetX, outer_width / 2 - offsetX])
        for (y = [-outer_height / 2 + offsetY, outer_height / 2 - offsetY])
            translate([x, y, 0])
                cylinder(h = case_depth, d = screw_hole_diameter, center = true, $fn = 50);
    }
    }
}
    







// Main case front
module oled_case_front() {
  
    
    // Create outer shell with holes
    difference() {
        // Base outer shell
        cube([outer_width, outer_height, case_depth], center = true);
        
        // Hollow out space for the display board
        translate([0, 0, -1])  // slight offset to avoid flush faces
            cube([display_width, display_height, case_depth], center = true);
        
        // Cutout for the visible screen area
        translate([0, 0, case_depth/2 - 1])
            cube([screen_width, screen_height, case_depth], center = true);

        // Round screw holes in each corner with separate offsetX and offsetY
        for (x = [-outer_width / 2 + offsetX, outer_width / 2 - offsetX])
        for (y = [-outer_height / 2 + offsetY, outer_height / 2 - offsetY])
            translate([x, y, 0])
                cylinder(h = case_depth, d = screw_hole_diameter, center = true, $fn = 50);
    }
}

// Call the module to create the case front with screw holes
#oled_case_front();
// Call the module to create the inner part for the OLED display
oled_inner_part();