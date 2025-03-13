pipe_diameter = 64.0;
pipe_inner_diameter=50;
tolerance=0.2;


//**************
//****INSERT****
insert_wall_thickness =1.2;
insert_height=26;
insert_cutout_thickness=2;

insert_connector_ring_thickness=3;
insert_connector_ring_height=3;

insert_shell_connector_thickness =4;
insert_shell_connector_height =3;
insert_shell_connector_width =15;
insert_shell_connector_distance=10; // distance from the end of the shell connection
insert_shell_ring_thickness=2;     // outer ring just to make more rigid, and prevent go the inlet way too into shell


//**************
//****SHELL****

shell_wall_thickness =2;
shell_height =40;
shell_inner_ring_height =2;
shell_connector_tolerance_x=3;
shell_connector_tolerance_y=2;

gasket_width= 2;

//pipe_connector_height = 40.0;
//main_pipe_diameter =150;
$fn=120;


//***************************************************************

module insert() {
    color("Turquoise"){
union(){
             union(){
                 translate([0,0,-insert_shell_connector_distance])
                    insert_shell_connections(inner_circle_diameter=pipe_diameter+2*insert_wall_thickness );
                 
                translate([0,0,-insert_height/2+insert_connector_ring_height/2]){
                    insert_pipe_connector_ring(outer_circle_diameter=pipe_diameter);
            }
                translate([0,0,+insert_height/2-insert_shell_ring_thickness/2]){    
                insert_shell_connector_ring(inner_circle_diameter=pipe_diameter+2*insert_wall_thickness);
                }
            }
    difference() {
            union(){
             translate([0,0,insert_shell_connector_thickness/2]){
                  cylinder(h=insert_height-insert_shell_connector_thickness, d=pipe_diameter+2*insert_wall_thickness, center=true);
             }
              translate([0,0,(-insert_height+insert_shell_connector_thickness)/2]){
                 cylinder(h=insert_shell_connector_thickness, d1=pipe_diameter, d2=pipe_diameter+2*insert_wall_thickness, center=true);
            }
         }
            cylinder(h=insert_height*3, d=pipe_diameter, center = true);
                translate([0,pipe_diameter/2,0])
                cube(size= [insert_cutout_thickness,10,insert_height+0.01], center=true);
        }
                    
    }
}
}


module insert_shell_connector_ring(inner_circle_diameter =10){
    
         difference(){
                cylinder(h=insert_shell_ring_thickness,
                        d=inner_circle_diameter+2*insert_shell_ring_thickness, center=true);  
    union(){         
                cylinder(h=insert_shell_ring_thickness+0.1, d=inner_circle_diameter, center=true);
             translate([0,pipe_diameter/2,0])
                    cube(size= [insert_cutout_thickness,10,insert_height], center=true);
    }
     }  
 }
    
module insert_pipe_connector_ring(outer_circle_diameter =10){
    
         difference(){
                cylinder(h=insert_connector_ring_height, d=outer_circle_diameter, center=true);           
            cylinder(h=insert_height, d=outer_circle_diameter-2*insert_connector_ring_thickness, center=true);
             translate([0,pipe_diameter/2,0])
                    cube(size= [insert_cutout_thickness,10,insert_height], center=true);
     }  
 }

    
module insert_shell_connections(inner_circle_diameter =10 ){
   
    translate([0,0,insert_height/2-insert_shell_connector_height/2-insert_shell_ring_thickness]){
     intersection(){  
    difference(){
        intersection(){  
             cube(size= [pipe_diameter*2,
            insert_shell_connector_width,
            insert_shell_connector_height], center=true);
             union(){  
                translate([0,0,+insert_shell_connector_height/4]){
                 cylinder(h=insert_shell_connector_height/2, 
                    d=inner_circle_diameter+insert_shell_connector_thickness,  
                      center=true);
                }
                 translate([0,0,-insert_shell_connector_height/4]){
                cylinder(h=insert_shell_connector_height/2, 
                    d2=inner_circle_diameter+insert_shell_connector_thickness,  
                    d1=inner_circle_diameter, 
                    center=true);
             }
         }
           }
        cylinder(h=insert_height+0.1, d=inner_circle_diameter, center=true);
       
           
     }
 }
 }
}


//**********************************************************************


module shell() {
    color("green"){
        ring();
        translate([0,0,-3])
         ring();
        translate([0,0,-insert_shell_connector_distance-insert_shell_ring_thickness+4])
        ring();
          translate([0,0,-insert_shell_connector_distance-insert_shell_ring_thickness-3])
        ring();
        inner_ring();
          difference(){  
            cylinder(h=shell_height, d=pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance, center=true);
            cylinder(h=shell_height+0.01, d=pipe_diameter+2*insert_wall_thickness+tolerance, center=true);
           shell_connections_cutout(inner_circle_diameter=pipe_diameter+2*insert_wall_thickness);
          }         
    }
}



module shell_connections_cutout(inner_circle_diameter =10 ){
   translate([0,0,-insert_shell_connector_distance]){
    translate([0,0,shell_height/2-insert_shell_connector_height/2]){
     intersection(){  
             cube(  size= [pipe_diameter*2,insert_shell_connector_width+shell_connector_tolerance_x,
                insert_shell_connector_height+shell_connector_tolerance_y],  center=true); 
    }}
 }
}

module ring(thickness=1){
    translate([0,0,shell_height/2])
    difference(){
        cylinder(h=thickness, d=pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance+thickness, center=true);
        cylinder(h=shell_height+0.01, d=pipe_diameter+2*insert_wall_thickness+tolerance, center=true);
    }       
}

module inner_ring(height=shell_inner_ring_height){
    translate([0,0,-shell_height/2])
    difference(){
        cylinder(h=height, d=pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance, center=true);
        cylinder(h=shell_height+0.01, d=pipe_inner_diameter+4, center=true);
    }       
}


module gasket(){
    inner_ring(height=gasket_width);
}


//**************************
//***** complex items

//the connector shell is extended on its botton
module extended_shell(extension = 20, filledExtension = false){
    _cutoutD= filledExtension? ( pipe_inner_diameter+4) :(pipe_diameter+2*insert_wall_thickness+tolerance);
    color("green"){
    union(){
        shell();
        translate([0,0,-shell_height/2-extension/2]){
        difference(){    
            cylinder(h=extension, d=pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance, center=true);
            cylinder(h=extension+0.01, d=_cutoutD, center=true);
        }
      }
    }
    }
}


module pipe_connector_50_50(){
    shell();
    rotate([180,0,0])
    translate([0,0,shell_height+shell_inner_ring_height])
    shell();
}


module anemostate90degree(single=false){
    anemostate_inner_d=125;
    anemostate_height=100;
    anemostate_wall_thickness=2;

color("orange"){    
difference(){    
    union(){
    xtranslation= anemostate_inner_d-38;
    ytranslationForShell =( pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance+1)/2;
     translate([0,-xtranslation,ytranslationForShell])
    rotate([90,0,0])
    extended_shell(filledExtension=true,extension=anemostate_inner_d/3);
    
    difference(){
         translate([0,0,anemostate_height/2])
        cylinder(h=anemostate_height, d=anemostate_inner_d+ anemostate_wall_thickness*2, center=true);
         translate([0,0,anemostate_height/2+anemostate_wall_thickness])
        cylinder(h=anemostate_height, d=anemostate_inner_d, center=true);
          translate([0,0,ytranslationForShell])
        rotate([90,0,0])
        cylinder(h=300, d=pipe_diameter+2*insert_wall_thickness+tolerance, center=true);
    }
    if(!single){
    translate([0,xtranslation,ytranslationForShell])
    rotate([-90,0,0])
    extended_shell(filledExtension=true,extension=anemostate_inner_d/3);
    }
    }
     translate([0,0,anemostate_height/2+shell_wall_thickness])
        cylinder(h=anemostate_height, d=anemostate_inner_d, center=true);
    
}

    
}    
}

module anemostate90degreesingle(){
}



//animate from 50 to 12
//translate([0,0,50])
//insert();
//shell();

//extended_shell();
//pipe_connector_50_50();
//gasket();

anemostate90degree(single=false);
