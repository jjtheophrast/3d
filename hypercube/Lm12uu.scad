$fn=120;
bearing_d= 21.0;
bearing_d_tolerance=0.2;
bearing_holder_d=bearing_d+4;
bolt_diameter = 3.5;
total_width=bearing_holder_d+2*bolt_diameter+2*6;

thickness=4;
end_offset=5;

tolerance = 0.3;

difference(){
    

union(){

translate([0,-total_width/2,0])
cube([thickness,total_width, 20]);
translate([1,-bearing_holder_d/2,0])
cube([bearing_d/2,bearing_holder_d,20]);

translate([bearing_d/2+1,0,0])
cylinder(h=20, d=bearing_holder_d);
}   
union(){
    
translate([bearing_d/2+1,0,-0.001])
cylinder(h=20+0.01, d=bearing_d+bearing_d_tolerance);
    
cube([bearing_holder_d/2,bearing_d*0.75,500], center =true);

translate([-thickness,-total_width/2,-0.01])
cube([thickness,total_width, 22]);


translate([0,total_width/2-end_offset,10])
rotate([0,90,0])
cylinder(h=100, d=bolt_diameter, center=true);


translate([0,-total_width/2+end_offset,10])
rotate([0,90,0])
cylinder(h=100, d=bolt_diameter, center=true);
}


}
    