pipe_diameter = 64.0;
pipe_inner_diameter=50;
tolerance=0.5;


//**************
//****INSERT****
insert_wall_thickness =1;
insert_height=20;
insert_cutout_thickness=10;

insert_connector_ring_thickness=3;
insert_connector_ring_height=3;

insert_shell_connector_thickness =3;
insert_shell_connector_height =3;
insert_shell_connector_width =16;
insert_shell_connector_distance=10; // distance from the end of the shell connection
insert_shell_ring_thickness=1.5;     // outer ring just to make more rigid, and prevent go the inlet way too into shell

insert_connection_flat_width= 20;
insert_connection_flat_height= 6;

//**************
//****SHELL****

shell_wall_thickness =2;
shell_height =32;
shell_inner_ring_height =2;
shell_connector_tolerance_x=10;
shell_connector_tolerance_y=2.5;
 // original shell inner d=68
gasket_width= 2;


//**************
// SHELL 150 CONNECTOR

shell_150_connector_thickness = 3;


//pipe_connector_height = 40.0;
//main_pipe_diameter =150;
$fn=120;

//pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance

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
        
        insert_shell_connection_flat_cutout(inner_circle_diameter=pipe_diameter);
                    
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
    

             cube(size= [pipe_diameter*2,
            insert_connection_flat_width+2,
            insert_connection_flat_height], center=true);
        
    
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

module insert_shell_connection_flat_cutout(inner_circle_diameter =10 ){
   
    translate([0,0,insert_height/2+insert_connection_flat_height/2]){
     intersection(){  
    difference(){
        intersection(){  
             cube(size= [pipe_diameter*2,
            insert_connection_flat_width,
            insert_connection_flat_height], center=true);
         
                 cylinder(h=insert_height*4, 
                    d=inner_circle_diameter+2*insert_wall_thickness,  
                      center=true);
                
           }
        cylinder(h=insert_height+0.1, d=inner_circle_diameter, center=true);
       
           
     }
 }
 }
}


//**********************************************************************


module shell() {
    union(){
    color("green"){
        translate([0,0,-3])
         ring(chamfer_bottom=true);
        inner_ring();
          difference(){  
            cylinder(h=shell_height, d=pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance, center=true);
            cylinder(h=shell_height+0.01, d=pipe_diameter+2*insert_wall_thickness+tolerance, center=true);
           shell_connections_cutout(inner_circle_diameter=pipe_diameter+2*insert_wall_thickness);
          }         
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

module ring(thickness=3, chamfer_top=false,chamfer_bottom=false , square_based=false){
  
    diam_outer= pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance+thickness;
    diam_inner= pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance+thickness;
    

    
    
    
    
    
   intersection(){
       union(){
    translate([0,0,shell_height/2]){
         difference(){
            chamferCylinder(h=thickness, r=diam_outer/2, ch=chamfer_bottom?thickness/2:0,ch2=chamfer_top?thickness/2:0);
            cylinder(h=shell_height+0.01, d=pipe_diameter+2*insert_wall_thickness+tolerance, center=true);
         }
    }
}
    rotate([0,0,45]){
      cylinder(h=square_based?100:1000, r=square_based?(diam_outer/2+10):1000, center=true, $fn=4);
    }
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
module extended_shell(extension = 20, filled=false){
    
    cutout= filled?pipe_inner_diameter+4:(pipe_diameter+2*insert_wall_thickness+tolerance);
    
    color("green"){
    union(){
        shell();
        translate([0,0,-shell_height/2-extension/2]){
        difference(){    
            cylinder(h=extension, d=pipe_diameter+2*insert_wall_thickness+2*shell_wall_thickness+tolerance, center=true);
            cylinder(h=extension+0.01, d=cutout, center=true);
        }
      }
    
    }
}
}




//****************************************
//***  CONNECT TO D 150
//*********************


module connectable_shell(){
    
    
    cutout= (pipe_diameter+2*insert_wall_thickness+tolerance);
    color("white")
    union(){
    difference(){
    union(){
        shell();
        translate([0,0,-shell_height-1])
        
        ring(chamfer_top=true, thickness=11, square_based=true);
        shell_screw_mounting();
    }
    shell_screw_mounting(drillingsOnly=true);
    }
}
}

module shell_screw_mounting( drillingsOnly =false, offsetD=0.0){
    
 angle = 360/4;
    
 for ( i = [1:angle:360])
  rotate([0,0,i+45]){
     translate([pipe_diameter/2+5,0,-8])
      rotate([0,0,45/2])
      difference(){
        if(!drillingsOnly)cylinder(h=10, d=8, center=true, $fn=8);
        cylinder(h=20, d=2.5+offsetD, center=true, $fn=60);
      }
 }
}

module shell_screwhead_cutout(){
    angle = 360/4;
    
 for ( i = [1:angle:360])
  rotate([0,0,i+45]){
     translate([pipe_diameter/2+5,0,-12])
      rotate([0,0,45/2])
      difference(){
        cylinder(h=10, d=14, center=true, $fn=60);
      }
 }
}



module opel_screw_cutout(){

//    union(){
//   translate([0,0,10])     
//        cylinder(h=5, d=14, center=true, $fn=60);
   cylinder(h=30, d=3.5, center=true, $fn=60); 
//    }
    
}




module connectable_150_shell(){
    
    translate(([0,0,-50]))
    shell_150();
    
    
    
//    shell_150_cutout();
    
    
}







module pipe_connector_50_50(){
    union(){
    shell();
    rotate([180,0,0])
    translate([0,0,shell_height+shell_inner_ring_height-0.5])
    shell();
    }
}


//module shell_150(){
//
//    x_lenght= pipe_diameter*1.2;
//    y_lenght= pipe_diameter*1.2;
//    
//    
//    difference(){
//    translate([0,0,-75-2*shell_150_connector_thickness])
//    intersection(){
//        rotate([90,0,0]){   
//            difference(){
//            cylinder(h=x_lenght, d=150+2*shell_150_connector_thickness, center=true);
//            cylinder(h=x_lenght+0.2, d=150, center=true);
//            }
//        }
//        translate([0,0,75]){
//            #cube([x_lenght,y_lenght, 150], center=true);
//        }
//    }
//     cylinder(h=150, d=pipe_diameter+2*insert_wall_thickness+2*tolerance, center=true);
//    }
//}


module shell_150(){
union(){
    x_lenght= pipe_diameter*1.5;
   
    angle=25;
    d=3;
    outer_dimension= d+6;
    height=150;
    height_insert=1;
    _height_insert_calculated=150/2-2*insert_wall_thickness-2*tolerance+height_insert;
    
  difference(){  
  union(){  
    
    difference(){
    translate([0,0,-75-2*shell_150_connector_thickness])
    intersection(){
        rotate([90,0,0]){   
            difference(){
                
            //#cylinder(h=x_lenght*1000, d=150+2*shell_150_connector_thickness, center=true);
            //     
              cube([150,150+2*shell_150_connector_thickness, x_lenght*1000], center=true);   
            cylinder(h=x_lenght*10000+0.2, d=150, center=true);
            }
        }
        translate([0,0,6])
          rotate([90,45,0]){   
              cube([150,150+2*shell_150_connector_thickness, x_lenght*1000], center=true);   
            
        }
        
         
//        translate([0,0,65]){
//        rotate([0,0,60])
//            #cylinder(h=55, d1=x_lenght, d2=0 ,$fn=8);
//        }
    
       translate([0,0,75]){
           intersection(){
            cube([100,100, 150], center=true);
               rotate([0,0,45]){
                cube([120,120, 150], center=true);
               }
           }
        }
    }
     cylinder(h=150, d=pipe_inner_diameter+2*tolerance, center=true);
       
    shell_screw_mounting(drillingsOnly=true, offsetD=1);
    shell_screwhead_cutout();
  
   
}
}

    translate([0,0,-75-2*shell_150_connector_thickness])
     rotate([90,0,0]){   
//            cylinder(h=x_lenght*1000, d=150+2*shell_150_connector_thickness, center=true);
            cylinder(h=x_lenght*10000+0.2, d=150, center=true);
         
        }
        
        translate([37,0,-16]){
        rotate([0,45,0]){
        opel_screw_cutout();
            }  
        }
        
        
        
          translate([-37,0,-16]){
        rotate([0,-45,0]){
        opel_screw_cutout();
            }  
        }
       
        
        
         opel_screw_cutout();
   }
   }
}


module shell_150_cutout(){
    translate([0,0,-75-2*shell_150_connector_thickness])
        rotate([90,0,0]){   
            cylinder(h=150, d=150, center=true);
        }
    
}





module pipe_connector_50_150(){
union(){
//    color("red"){
   shell_transl = [0,0,32];
        
//    translate(shell_transl){
//        shell_150(); 
//    }
        
//    difference(){
    
    
    
        //connectable_shell();  
    
    
    
//         translate(shell_transl){
        connectable_150_shell();
//         }
    
    
    
//         translate(shell_transl){
//                        shell_150_cutout();
//         }
//    }    
//    rotate([180,0,0])
//    translate([0,0,shell_height+shell_inner_ring_height])
//    shell();
//    }
    
    
}
}









//--------------------------
/**
  * chamferCylinder returns an cylinder or cone with 45° chamfers on
  * the edges of the cylinder. The chamfers are diectly printable on
  * Fused deposition modelling (FDM) printers without support structures.
  *
  * @param  h    Height of the cylinder
  * @param  r    Radius of the cylinder (At the bottom)
  * @param  r2   Radius of the cylinder (At the top)
  * @param  ch   The "height" of the chamfer at radius 1 as
  *                seen from one of the dimensional planes (The
  *                real length is side c in a right angled triangle)
  * @param  ch2  The "height" of the chamfer at radius 2 as
  *                seen from one of the dimensional planes (The
  *                real length is side c in a right angled triangle)
  * @param  a    The angle of the visible part of a wedge
  *                starting from the x axis counter-clockwise
  * @param  q    A circle quality factor where 1.0 is a fairly
  *                good quality, range from 0.0 to 2.0
  */
module chamferCylinder(h, r, r2 = undef, ch = 1, ch2 = undef, a = 0, q = -1.0, height = undef, radius = undef, radius2 = undef, chamferHeight = undef, chamferHeight2 = undef, angle = undef, quality = undef) {
    // keep backwards compatibility
    h   = (height == undef) ? h : height;
    r   = (radius == undef) ? r : radius;
    r2  = (radius2 == undef) ? r2 : radius2;
    ch  = (chamferHeight == undef) ? ch : chamferHeight;
    ch2 = (chamferHeight2 == undef) ? ch2 : chamferHeight2;
    a   = (angle == undef) ? a : angle;
    q   = (quality == undef) ? q : quality;

    height         = h;
    radius         = r;
    radius2        = (r2 == undef) ? r : r2;
    chamferHeight  = ch;
    chamferHeight2 = (ch2 == undef) ? ch : ch2;
    angle          = a;
    quality        = q;

    module cc() {
        upperOverLength = (chamferHeight2 >= 0) ? 0 : 0.01;
        lowerOverLength = (chamferHeight >= 0) ? 0 : 0.01;
        cSegs = circleSegments(max(radius, radius2), quality);

        if(chamferHeight >= 0 || chamferHeight2 >= 0) {
            hull() {
                if(chamferHeight2 > 0) {
                    translate([0, 0, height - abs(chamferHeight2)]) cylinder(abs(chamferHeight2), r1 = radius2, r2 = radius2 - chamferHeight2, $fn = cSegs);
                }
                translate([0, 0, abs(chamferHeight)]) cylinder(height - abs(chamferHeight2) - abs(chamferHeight), r1 = radius, r2 = radius2, $fn = cSegs);
                if(chamferHeight > 0) {
                    cylinder(abs(chamferHeight), r1 = radius - chamferHeight, r2 = radius, $fn = cSegs);
                }
            }
        }

        if(chamferHeight < 0 || chamferHeight2 < 0) {
            if(chamferHeight2 < 0) {
                translate([0, 0, height - abs(chamferHeight2)]) cylinder(abs(chamferHeight2), r1 = radius2, r2 = radius2 - chamferHeight2, $fn = cSegs);
            }
            translate([0, 0, abs(chamferHeight) - lowerOverLength]) cylinder(height - abs(chamferHeight2) - abs(chamferHeight) + lowerOverLength + upperOverLength, r1 = radius, r2 = radius2, $fn = cSegs);
            if(chamferHeight < 0) {
                cylinder(abs(chamferHeight), r1 = radius - chamferHeight, r2 = radius, $fn = cSegs);
            }
        }
    }
    module box(brim = abs(min(chamferHeight2, 0)) + 1) {
        translate([-radius - brim, 0, -brim]) cube([radius * 2 + brim * 2, radius + brim, height + brim * 2]);
    }
    module hcc() {
        intersection() {
            cc();
            box();
        }
    }
    if(angle <= 0 || angle >= 360) cc();
    else {
        if(angle > 180) hcc();
        difference() {
            if(angle <= 180) hcc();
            else rotate([0, 0, 180]) hcc();
            rotate([0, 0, angle]) box(abs(min(chamferHeight2, 0)) + radius);
        }
    }
}

/**
  * circleSegments calculates the number of segments needed to maintain
  * a constant circle quality.
  * If a globalSegementsQuality variable exist it will overwrite the
  * standard quality setting (1.0). Order of usage is:
  * Standard (1.0) <- globalCircleQuality <- Quality parameter
  *
  * @param  r  Radius of the circle
  * @param  q  A quality factor, where 1.0 is a fairly good
  *              quality, range from 0.0 to 2.0
  *
  * @return  The number of segments for the circle
  */
function circleSegments(r, q = -1.0) = (q >= 3 ? q : ((r * PI * 4 + 40) * ((q >= 0.0) ? q : globalCircleQuality)));

// set global quality to 1.0, can be overridden by user
globalCircleQuality = 1.0;
//----------------



//animate from 50 to 8
translate([0,0,8])
//insert();
//shell();

//extended_shell();
//pipe_connector_50_50();
//gasket();


pipe_connector_50_150();
    