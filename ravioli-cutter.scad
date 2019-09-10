include <BOSL/constants.scad>
use <BOSL/shapes.scad>
//Configs
dough_thickness=2;



//This is the overall size of the entire press for single ravioli
ravioli_size=35;

press_height=ravioli_size*.3;
//size of the cutting ridge around the outside of each ravioli
ravioli_cut_size=1.2;
//size of the seem which closes the ravioli and holds them together
revioli_seem_size=3;
ravioli_seem_ridge_width=4;
ravioli_seem_ridge_depth=2;
tab_size=1.5;
rows = 3;
columns = 3;
revioli_stuffing_size=ravioli_size-(2*revioli_seem_size)-(2*ravioli_cut_size);
module single_press(x_shift=-1, y_shift=-1){
    difference(){
        union(){
            color("green")
            cube([ravioli_size,ravioli_size,press_height-dough_thickness/2]);
            color("white")
            translate([ravioli_cut_size*.25,ravioli_cut_size*.25,press_height-(dough_thickness/2)]){
            difference(){
                cube([ravioli_size-(ravioli_cut_size*.6),ravioli_size-(ravioli_cut_size*.6),dough_thickness/2]);
                translate([ravioli_cut_size*.4,ravioli_cut_size*.4,-1])
                    color("red")
                    cube([ravioli_size-(ravioli_cut_size*1.4),ravioli_size-(ravioli_cut_size*1.4),3]);
                }
            }
        }
        
        if (tab_size > 0 ){
            translate([ravioli_cut_size*.25,ravioli_cut_size*.25,press_height-(dough_thickness/2)]){
                    translate([ravioli_size*.25-(tab_size*.5),y_shift,-tab_size*.33])
                    cube([tab_size*2,ravioli_size+2,tab_size]);
                    
                    translate([ravioli_size*.75-(tab_size*.5),y_shift,-tab_size*.33])
                    cube([tab_size*2,ravioli_size+2,tab_size]);
                    
                    translate([x_shift, ravioli_size*.25-(tab_size*.5),-(tab_size*.33)])
                    cube([ravioli_size+2,tab_size*2,tab_size]);
                    
                    translate([x_shift, ravioli_size*.75-(tab_size*.5),-(tab_size*.33)])
                    cube([ravioli_size+2,tab_size*2,tab_size]);
            }
        }
        translate([ravioli_cut_size,ravioli_cut_size,press_height-dough_thickness])
        color("red")
        cube([ravioli_size-(2*ravioli_cut_size),ravioli_size-(2*ravioli_cut_size),dough_thickness+1]);
        
        color("blue")
        translate([revioli_stuffing_size/2 +(ravioli_size-revioli_stuffing_size)/2,
        revioli_stuffing_size/2 +(ravioli_size-revioli_stuffing_size)/2,
        press_height*.5])
        cuboid([revioli_stuffing_size, revioli_stuffing_size, press_height*2], fillet=3, $fn=32);

        //origin ridges
        translate([ravioli_cut_size,ravioli_cut_size+.4,0])
        seem_row([-90,0,-90]);
        
        //x-right ridges
        translate([ravioli_size-ravioli_seem_ridge_width-(2*ravioli_cut_size)-1.2,
        ravioli_cut_size+.4,0])
        seem_row([-90,0,-90]);
        
        translate([ravioli_size,ravioli_cut_size,0])
        rotate([0,0,90])
        seem_row([-90,0,-90]);
        
        translate([ravioli_size,ravioli_size-(ravioli_seem_ridge_width*1.4)-ravioli_cut_size,0])
        rotate([0,0,90])
        seem_row([-90,0,-90]);
        

        
        rotate([0,90,0])
        translate([0,ravioli_size/2,0])
        difference(){
            color("red")
            scale([1, 1.75, 1])
			cylinder(r=press_height*.50, h=ravioli_size, $fn=12); 
        }
        
        rotate([0,90,90])
        translate([0,-ravioli_size/2,0])
        difference(){
            color("red")
            scale([1, 1.75, 1])
			cylinder(r=press_height*.50, h=ravioli_size, $fn=12);

        }
    }
}


module seem_row(rotation, length=ravioli_size){
count =  (length-1)/ravioli_seem_ridge_width;
    for (i = [1:count]) {
        color("purple")
        seem_ridge(width=ravioli_seem_ridge_width,
                depth=ravioli_seem_ridge_depth,
                length = (ravioli_seem_ridge_width * 1.4),
                position= [0,
                           (ravioli_seem_ridge_width*i),
                           press_height-dough_thickness+.1],
                rotation=rotation
        );
    }
}

module seem_ridge(width, depth, length, position, rotation){
//    translate([position[0], position[1]+1, position[2]]){
//        triangle_points =[[0,0],[width/2,depth],[width,0]];
//        rotate(rotation){
//            linear_extrude(height = length)
//            polygon(triangle_points,[],10);
//        }
//    }
	translate([position[0]+(length/2), position[1]-1, position[2]])
		rotate([0, 180, 90])
		prismoid(size1=[width, length], size2=[0,length], h=depth);
}

module ravioli() {
	union(){
        for (i = [0:rows-1]) {
            translate([0,(ravioli_size-ravioli_cut_size)*i, 0]){
				for (r = [0:columns-1]) {
					translate([(ravioli_size-ravioli_cut_size)*r,0,0])
					single_press(-10, 10);
					
				}
				
            }
        }
    }
}
//seem_row([-90,0,-90]);
ravioli();