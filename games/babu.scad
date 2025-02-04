
$fn=120;
union(){
cylinder(h=14,d=15,center=true);
translate([0,0,7])
cylinder(h=3,d1=15,d2=0);
translate([0,0,14])
sphere(d=14);
}