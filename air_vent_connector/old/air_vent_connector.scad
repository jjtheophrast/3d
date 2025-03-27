wall_thickness =1.50;
pipe_diameter = 64.0;
pipe_connector_height = 30.0;

main_pipe_diameter =150;
$fn=120;

cutout_height =15;

module pipe_connector() {
    
//    rotate_extrude( angle=45)
//translate([75,0,0])
//square([wall_thickness,70], center=true);
    
union(){
   
difference() {
     
      union(){
    
       cylinder(h=pipe_connector_height, d=pipe_diameter+2*wall_thickness, center=true);
      }
        translate([0,0,2])
      cylinder(h=pipe_connector_height, d=pipe_diameter, center = true);
       cylinder(h=pipe_connector_height*3, d=50, center = true);
      
//        translate([0,0,pipe_connector_height/2-cutout_height/2+0.01])
//            cutouts(height= cutout_height,pitch_circle_diameter=pipe_diameter);
      
    }
     


//translate([0,0,main_pipe_diameter/2])    
//    
//rotate([90,0,0]){
//    difference() {
//      union(){
//        cylinder(h=pipe_connector_height*3, d=main_pipe_diameter+2*wall_thickness, center=true);
//      }
//        
//        cylinder(h=pipe_connector_height*4, d=main_pipe_diameter, center = true);
//        
//    }
//}

}
difference(){
 translate([0,0,pipe_connector_height/2-2])
            connections(pitch_circle_diameter=pipe_diameter);
translate([0,0,1])
      cylinder(h=pipe_connector_height, d1=0, d2=pipe_diameter, center = true);
}
}



module connections(thickness=4,width=10, nr=3,pitch_circle_diameter =10, start_angle=0 ){
    angle= 360/nr;
    for (i = [ 0 : (nr-1)  ]) {
        rotate(start_angle+i*angle){            
    translate([pitch_circle_diameter/2-thickness/2+1,0,0]){
        cube([thickness,width,thickness], center=true);
    }
}
}
}
module cutouts(thickness=1,height=20, nr=4,pitch_circle_diameter =10, start_angle=0 ){
    angle= 360/nr;
    for (i = [ 0 : (nr-1)  ]) {
        rotate(start_angle+i*angle){
 translate([5,0,0]){            
        cube([thickness,1000,height], center=true);
 }
 translate([-5,0,0]){            
        cube([thickness,1000,height], center=true);
 }
            
            
    
}
}
}

pipe_connector();

    