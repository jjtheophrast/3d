
$fn=120;

difference(){
    union(){
cube([30-8,50,6]);
    
   translate([30-6-8,15]){    
    cube([6,20,20]);  
  }
  translate([12,15,6]){
  rotate([0,45,0])    
    cube([6,20,6]);  
  }
  }
  
  
union(){
//  translate([30-8,0]){    
//    cube([8,30,30]);  
//  }
//  
//    translate([30-8,0]){    
//    #cube([30,30,6]);  
//  }
//  
  translate([15,10]){    
      cylinder(d=3.4, h=100);
   }
  
    translate([15,50-10]){    
      cylinder(d=3.4, h=100);
   }
  }
}