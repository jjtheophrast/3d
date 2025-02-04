// Parameters for the pipe plug
//plug_diameter = 16;          // Inner diameter of the pipe
          // Length of the plug
$fn=80;
tolerance = 0.2;             
wall_thickness = 2;         


// Main module for the pipe plug
module pipe_plug(pipe_inner_diam, pipe_outer_diameter) {
    
    plug_length = 20;  
    
    flange_thickness = 3;  
    
    difference() {
        group(){
        cylinder(h = plug_length, d1 = pipe_inner_diam-0.5, d2 = pipe_inner_diam+tolerance, center = true);
        translate([0,0,plug_length/2+flange_thickness/2]){
        cylinder(h = flange_thickness, d = pipe_outer_diameter, center = true);
        }
        
         for (i = [3, 5, 7, 9, 11]) {
        translate([0, 0, plug_length / 2 + flange_thickness / 2 - i]) {
            cylinder(h = flange_thickness / 3, d = pipe_inner_diam + 0.5, center = true);
        }
    }
        
    }
        translate([0, 0, 0.1]) 
            cylinder(h = plug_length+ flange_thickness -wall_thickness+ 0.2, d = pipe_inner_diam - wall_thickness + tolerance, center = true);
    }


        
}

// MU_III_16
pipe_plug(16,17.2);

