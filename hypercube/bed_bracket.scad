// on hypercube evo the drillind are <--->240mm apart
// the bed inner size is 273(measured) * 255(cutted length)

// so the offset should be offset_ x= (273-240)/2 and offset_y=(255-240)/2

$fn=120;

distance_x =33.0;
distance_y=8.5;
length=40;
thickness=8;

drillingD =4.4;
drilling_offset_r=8.5;

extraction_height=3;



// bolts needed for 2020 alu profile
//        --> 2*drilling_offset_r+6mm --> max 23 mm, min 19mm   => 5*20 bolt
//        --> thickness + 6mm   --> max 14mm, min 10mm     => 5*12 mm

//



module chamferCube(size, chamfers = [undef, undef, undef], ch = 1, ph1 = 1, ph2 = undef, ph3 = undef, ph4 = undef, sizeX = undef, sizeY = undef, sizeZ = undef, chamferHeight = undef, chamferX = undef, chamferY = undef, chamferZ = undef) {
    if(size[0]) {
        chamferCubeImpl(size[0], size[1], size[2], ch, chamfers[0], chamfers[1], chamfers[2]);
    } else {
        // keep backwards compatibility
        size     = (sizeX == undef) ? size : sizeX;
        chamfers = (sizeY == undef) ? chamfers : sizeY;
        ch       = (sizeZ == undef) ? ch : sizeZ;
        ph1      = (chamferHeight == undef) ? ph1 : chamferHeight;
        ph2      = (chamferX == undef) ? ph2 : chamferX;
        ph3      = (chamferY == undef) ? ph3 : chamferY;
        ph4      = (chamferZ == undef) ? ph4 : chamferZ;

        chamferCubeImpl(size, chamfers, ch, ph1, ph2, ph3, ph4);
    }
}

module chamferCubeImpl(sizeX, sizeY, sizeZ, chamferHeight, chamferX, chamferY, chamferZ) {
    chamferX = (chamferX == undef) ? [1, 1, 1, 1] : chamferX;
    chamferY = (chamferY == undef) ? [1, 1, 1, 1] : chamferY;
    chamferZ = (chamferZ == undef) ? [1, 1, 1, 1] : chamferZ;
    chamferCLength = sqrt(chamferHeight * chamferHeight * 2);

    difference() {
        cube([sizeX, sizeY, sizeZ]);
        for(x = [0 : 3]) {
            chamferSide1 = min(x, 1) - floor(x / 3); // 0 1 1 0
            chamferSide2 = floor(x / 2); // 0 0 1 1
            if(chamferX[x]) {
                translate([-0.1, chamferSide1 * sizeY, -chamferHeight + chamferSide2 * sizeZ])
                rotate([45, 0, 0])
                cube([sizeX + 0.2, chamferCLength, chamferCLength]);
            }
            if(chamferY[x]) {
                translate([-chamferHeight + chamferSide2 * sizeX, -0.1, chamferSide1 * sizeZ])
                rotate([0, 45, 0])
                cube([chamferCLength, sizeY + 0.2, chamferCLength]);
            }
            if(chamferZ[x]) {
                translate([chamferSide1 * sizeX, -chamferHeight + chamferSide2 * sizeY, -0.1])
                rotate([0, 0, 45])
                cube([chamferCLength, chamferCLength, sizeZ + 0.2]);
            }
        }
    }
}






module bracket(mirrored=false){
scale([mirrored?-1:1,1,1]){    
difference(){
union(){
cube([length-7.5,thickness,20]);
chamferCube([thickness,length,20], ch=3, chamfers =[[0, 1,1, 0], [0,0,0,0], [0, 0, 0, 0]]);

//cube([distance_x+drilling_offset_r,distance_y,20]);
cube([distance_x,distance_y+drilling_offset_r,20]);

translate([7,11,0])
rotate([0,0,45])
cube([7,8,20]);

//cylinder(h=20,d=drillingD);

translate([distance_x,distance_y,0]){
  cylinder(h=20+extraction_height,r=drilling_offset_r, centered = true);
}
}


union(){
translate([distance_x,distance_y,0-0.001]){
  cylinder(h=20+extraction_height*2,d=drillingD, centered = true);
}
rotate([0,0,45])
cube([10,10,80], center=true);


translate([-0.1,length-10,10])
    rotate([0,90,0])
        cylinder(h=1000,d=5.3, centered = true);
    
    
    translate([23,500,10])
    rotate([90, 0,0])
        cylinder(h=1000,d=5.3, centered = true);
    
}
}
}
}



bracket(mirrored=false);
translate([-10,0,0])
bracket(mirrored=true);