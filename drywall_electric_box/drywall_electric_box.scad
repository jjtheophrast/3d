
//CHAMFERING:
//
//https://github.com/SebiTimeWaster/Chamfers-for-OpenSCAD/blob/master/Chamfer.scad


inner_w=100;
inner_h=160;
bottom_part_height=50;
wall_thickness =2;


difference(){
chamferCube([inner_w+2*wall_thickness,inner_h+2*wall_thickness, bottom_part_height]
    );
translate([wall_thickness,wall_thickness,wall_thickness])
    chamferCube([inner_w,inner_h, bottom_part_height]);
}






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
