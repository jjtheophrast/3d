
radius=78;
hole_distance=60;
drilling_diameter=3;
wall_height=1.5;


difference(){
cylinder(h=wall_height, d=radius, center=true,$fn=8);
 
  drilling_holes(d=drilling_diameter, pitch_circle_diameter=hole_distance, start_angle=45/2);  

}


module drilling_holes(d=2, nr=4,pitch_circle_diameter =10, start_angle=0 ){
    
    angle= 360/nr;
    for (i = [ 0 : (nr-1)  ]) {
        rotate(start_angle+i*angle){
    translate([0,pitch_circle_diameter/2,0]){
     cylinder(h=1000, d=d, center=true,$fn=100);
    }
}
}
}