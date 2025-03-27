//use <threads-library-by-cuiso-v1.scad>
use <Chamfer.scad>

pipe_diameter = 64.0;
pipe_small_outer_diameter = 53;
pipe_inner_diameter = 50;
tolerance = 0.5;

//**************
//****SHELL****

shell_wall_thickness = 2;
shell_height = 26 + 2 + 2;
shell_inner_ring_height = 2;
gasket_width = 2;


$fn = 120;


module inner_ring_connector(height = 4) {
    d_outer = pipe_diameter + 2 * shell_wall_thickness;
    d_inner = pipe_diameter - 3.5;
    translate([0, 0, shell_height / 2 - height / 2]) {
        difference() {
            cylinder(h = height, d = d_outer, center = true);
            cylinder(h = 2 * height, d = d_inner, center = true);
            translate([0, 0, 3])
                cylinder(h = height, d1 = d_inner, d2 = d_outer, center = true);
            translate([0, 0, -1.5])
                cylinder(h = height, d1 = d_outer, d2 = d_inner, center = true);

        }
    }
}


module ring(thickness = 3, chamfer_top = true, chamfer_bottom = true) {
    diam_outer = pipe_diameter + 2 * shell_wall_thickness + tolerance +
        thickness;
    diam_inner = pipe_diameter + 2 * shell_wall_thickness + tolerance +
        thickness;

    translate([0, 0, shell_height / 2]) {
        difference() {
            chamferCylinder(h = thickness, r = diam_outer / 2, ch = thickness / 2, ch2 = 0);
            cylinder(h = shell_height + 0.01, d = pipe_diameter +
                tolerance, center = true);
        }
    }
}



module inner_ring(height = shell_inner_ring_height) {
    translate([0, 0, -(shell_height / 2) + height / 2])
        difference() {
            cylinder(h = height, d = pipe_diameter + 2 *
                shell_wall_thickness + tolerance, center = true);
            cylinder(h = shell_height + 0.01, d = pipe_inner_diameter + 4, center = true);
        }
}





module gasket() {
    inner_ring(height = gasket_width);
}


//**************************
//***** complex items
//
//the connector shell is extended on its botton
module extended_shell(extension = 20, filled = false) {

    cutout = filled?pipe_inner_diameter + 4:(pipe_diameter + 2 * insert_wall_thickness + tolerance);

    color("green") {
        union() {
            shell();
            translate([0, 0, -shell_height / 2 - extension / 2]) {
                difference() {
                    cylinder(h = extension, d = pipe_diameter + 2 * insert_wall_thickness + 2 *
                        shell_wall_thickness + tolerance, center = true);
                    cylinder(h = extension + 0.01, d = cutout, center = true);
                }
            }
        }
    }
}


module anemostate90degree(single = false, anemostate_height = 225, anemostate_inner_d = 100) {
    anemostate_wall_thickness = 1.8;
    leg_height = 7;
    shell_extension = shell_height / 2;
    xtranslation = -anemostate_inner_d / 2 - shell_height / 2;
    ytranslationForShell = (pipe_diameter + 2 * shell_wall_thickness + tolerance) / 2 + 6;
    drilling = 5.0;

    color("orange") {
        difference() {
            union() {
                translate([0, xtranslation, ytranslationForShell])
                    rotate([90, 0, 0])
                        shell(filled = true, extension = shell_extension);

                difference() {
                    union() {
                        translate([0, 0, anemostate_height / 2]) {
                            cylinder(h = anemostate_height, d = anemostate_inner_d +
                                    anemostate_wall_thickness * 2, center = true);
                        }
                        rotate([0, 0, 90]) {
                            translate([0, 0, leg_height / 2]) {
                                difference() {
                                    translate([-3 * leg_height / 2, -(anemostate_inner_d + 45) / 2,
                                            -leg_height / 2])
                                        chamferCube([3 * leg_height, anemostate_inner_d + 45,
                                            leg_height], [[0, 0, 0, 0], [0, 0, 0, 0], [1, 1, 1, 1]],
                                            leg_height / 1.5);
                                    translate([0, (anemostate_inner_d + 25) / 2, -3 * leg_height]) {
                                        cylinder(h = 100, d = drilling);
                                    }
                                    translate([0, -(anemostate_inner_d + 25) / 2, -3 * leg_height])
                                        {
                                            cylinder(h = 100, d = drilling);
                                        }
                                }
                            }
                        }


                        //                           rotate([0,0,-60]){
                        //                    translate([0,0,leg_height/2]){
                        //                    difference(){
                        //                    cube([3*leg_height, anemostate_inner_d+50,leg_height], center=true);
                        //                    translate([0,(anemostate_inner_d+25)/2,-3*leg_height]){
                        //                        cylinder(h=100,r=4.5 );
                        //                    }
                        //                    translate([0,-(anemostate_inner_d+25)/2,-3*leg_height]){
                        //                        cylinder(h=100,r=4.5 );
                        //                    }
                        //                        }
                        //                }
                        //                }


                    }

                    translate([0, 0, anemostate_height / 2 + anemostate_wall_thickness])
                        cylinder(h = anemostate_height, d = anemostate_inner_d, center = true);
                    translate([0, -shell_height - 10, ytranslationForShell])
                        rotate([90, 0, 0])
                            cylinder(h = 50, d = pipe_diameter + tolerance, center = true);
                    if (!single) {
                        translate([0, +shell_height + 10, ytranslationForShell])
                            rotate([90, 0, 0])
                                cylinder(h = 50, d = pipe_diameter + tolerance, center = true);
                    }
                }
                if (!single) {
                    translate([0, -xtranslation, ytranslationForShell])
                        rotate([-90, 0, 0])
                            shell(filled = true, extension = shell_extension);
                }

            }
            translate([0, 0, anemostate_height / 2 + shell_wall_thickness])
                cylinder(h = anemostate_height, d = anemostate_inner_d, center = true);

        }


    }
}







module shell(extension = 0, filled_extension = false) {
    //  ORIGINAL
    color("green")
        difference() {
            union() {
                difference() {
                    union() {
                        cylinder(h = shell_height, d = pipe_diameter + 2 *
                            shell_wall_thickness + tolerance, center = true);
                        translate([0, 0, -shell_height / 2 - extension / 2])
                            cylinder(h = extension, d = pipe_diameter + 2 *
                                shell_wall_thickness + tolerance, center = true);

                    }

                    cylinder(h = shell_height + 0.01, d = pipe_diameter +
                        tolerance, center = true);
                    translate([0, 0, -shell_height / 2 - extension / 2])
                        cylinder(h = shell_height + extension + 0.01,
                        d = filled_extension?(pipe_inner_diameter + 4):(pipe_diameter +
                            tolerance), center = true);
                }
                inner_ring_connector();
                inner_ring();
            }
            translate([0, 0, shell_height / 3]) {
                for (i = [0 : 8]) {
                    rotate([0, 0, i * 22.5])
                        cube([pipe_diameter * 2, 1.5, shell_height], center = true);
                }
            }

        }

}

module cap(diam = 100, withSpike = true) {
    delta = 0.5;
    height = 10;
    overSize = 2;
    thickness = 2;
    rotate([0, 180, 0])
        union() {

            difference() {
                union() {

                    cylinder(h = 1.5, d1 = diam + overSize, d2 = diam, center = true);
                    translate([0, 0, height / 2])
                        cylinder(h = height, d1 = diam + delta / 2, d2 = diam - delta / 2, center =
                        true);
                }
                union() {
                    translate([0, 0, height / 2 - thickness - 2])
                        cylinder(h = height, d = diam - thickness, center = true);

                    translate([0, 0, height / 2 - thickness + height / 2 + 1 - 2])
                        cylinder(h = 2, d1 = diam - thickness, d2 = diam - thickness - 3, center =
                        true);

                }

            }

            translate([0, 0, height / 2])
                for (i = [0 : 3]) {
                    rotate([0, 0, i * 60])
                        cube([diam - delta, 1, height], center = true);
                }

            if (withSpike) {
                translate([0, 0, height / 2 - 5])
                    cylinder(h = height + 5, d1 = 0, d2 = 10, center = true);
                translate([0, 0, height / 2 + 2])
                    cylinder(h = 5, d1 = 0, d2 = 25, center = true);
            }
        }

    label = str("Ø", diam);
    translate([10, 3, -height + 0.01])
        linear_extrude(thickness + 1)
            text(label, size = 10, font = "Nimbus Mono PS:style=Bold");


}

module pipe_connector() {
    shell();
    translate([0, 0, -shell_height])
        rotate([180, 0, 0])
            shell();
}
//anemostate90degree(single=true,anemostate_inner_d=100 );

cap(diam = 100);
//pipe_connector();
//extended_shell();
// shell();





