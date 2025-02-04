//	General settings
	filename = "skawa_logo_circle.dxf";
	cutter_height = 10;
	cutter_thickness = 3;
	cutter_lip = 5 + cutter_thickness;

	render() slim_cookie_cutter();
//render() blocky_cookie_cutter();

module slim_cookie_cutter()
	{
	difference()
		{
		union()
			{
			//	Cookie Cutter Lip
			minkowski()
				{
				linear_extrude(height=0.001, center=false) render_exterior();
				translate([0,0,cutter_thickness/2]) 
					cube([cutter_lip,cutter_lip,cutter_thickness], center=true);
				}
			//	Cookie Cutter Height
			minkowski()
				{
				linear_extrude(height=0.001, center=false) render_cutout();
				translate([0,0,cutter_height/2]) 
					cube([cutter_thickness,cutter_thickness,cutter_height], center=true);
				}
			}
		//	Cut out the shape
		translate([0,0,1]) linear_extrude(height=cutter_height*2, center=false) render_cutout();
		}
	}

module blocky_cookie_cutter()
	{
	difference()
		{
		union()
			{
			//	Cookie Cutter Lip
			minkowski()
				{
				linear_extrude(height=0.001, center=false) render_exterior();
				translate([0,0,cutter_thickness/2]) 
					cube([cutter_lip,cutter_lip,cutter_thickness], center=true);
				}
			//	Cookie Cutter Height
			minkowski()
				{
				linear_extrude(height=0.001, center=false) render_exterior();
				translate([0,0,cutter_height/2]) 
					cube([cutter_thickness,cutter_thickness,cutter_height], center=true);
				}
			}
		//	Cut out the shape
		translate([0,0,-1]) linear_extrude(height=cutter_height*2, center=false) render_cutout();
		}
	}


//	Module for rendering DXF
module render_exterior(name = filename)
	{ render() hull() import(file = name); }

//	Module for rendering DXF
module render_cutout(name = filename)
	{ render() import(file = name); }