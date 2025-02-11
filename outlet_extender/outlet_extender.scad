// European Electric Outlet Box (65mm Diameter) with Screw Terminals
$fn=100;

extension_height =30.0;

wall_thickness = 3.0;
inner_diameter = 65.0;
wall_connector_dia =95.0;
wall_connector_drilling= 4.0;

mount_hole_diameter = 2;
mount_hole_thickness = 4.0;
mount_hole_length=15;
mount_hole_distance =60;

module outlet_box() {
    
    
    difference() {
      union(){
        cylinder(h=extension_height, d=inner_diameter+2*wall_thickness, center=true);
            connector_pad(0);
           connector_pad(60);
          connector_pad(120);
          
      }
        
        cylinder(h=42, d=inner_diameter, center = true);
        
    }
    
     difference() {

    for (i = [ 0 : 3  ]) {
        rotate(i*90){
    translate([0,mount_hole_distance/2,-extension_height/2 +mount_hole_length/2 ]){
    mounting_pad();
    }
    }
    }
    
translate([0,0,-extension_height+mount_hole_length-1])    
    cylinder( h=inner_diameter/2,d1=0,d2=inner_diameter, center=true);
    
      

}
}

module mounting_pad(){
    difference() {
        //cube(size=[mount_hole_thickness*3, mount_hole_thickness, mount_hole_length], center=true);
        translate([0,2/2,0])
        roundedcube([mount_hole_thickness*3, mount_hole_thickness+2, mount_hole_length], true, mount_hole_thickness/4, "z");
        union(){
        cylinder(h=42, d=mount_hole_diameter,  center = true);
        translate([4,0,0]){
         cylinder(h=42, d=mount_hole_diameter,  center = true);
        }
       translate([-4,0,0]){ 
        cylinder(h=42, d=mount_hole_diameter,  center = true);
       }
   }
        }
    
    
}


module connector_pad( angle, translate_z){
    
    pad_width=wall_connector_dia/5;
    drilling_offset=6;
    pad_thickness =4;
    
     translate([0,0,extension_height/2 -pad_thickness/2]){
    rotate(angle){
    difference(){  
        //cube(size=[wall_connector_dia, pad_width, wall_thickness], center=true);
        roundedcube([wall_connector_dia, pad_width, pad_thickness], true, wall_thickness/2, "z");
            
             translate([(wall_connector_dia/2-drilling_offset),0,0]){
        cylinder(h=wall_thickness*2, d=wall_connector_drilling, center = true);
    
            }
             translate([-1*(wall_connector_dia/2-drilling_offset),0,0]){
        cylinder(h=wall_thickness*2, d=wall_connector_drilling,  center = true);
    
            }
        }
    
    }
}
}


$fs = 0.15;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}


// Render the outlet box
outlet_box();



