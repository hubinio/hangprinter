include <design_numbers.scad>
include <measured_numbers.scad>
use <util.scad>

module Nema17_screw_translate(corners){
  for (i=[0:90:90*corners - 1]){
    rotate([0,0,i+45]) translate([Nema17_screw_hole_width/2,0,0]) children(0);
  }
}

module Nema17_screw_holes(d, h, corners=4){
  Nema17_screw_translate(corners) cylinder(r=d/2,h=h);
}
//Nema17_screw_holes(M3_diameter, 15);

module Nema17_schwung_screw_holes(d, h, schwung_length, corners=3){
  // Tight/still screw
  rotate([0,0,-45])
    translate([Nema17_screw_hole_width/2,0,0]) cylinder(r=d/2, h=h);
  // Nearest screw in y-direction
    rotate([0,0,-45])
    translate([Nema17_screw_hole_width/2,0,0])
    rotate([0,0,90+45])
    cyl_wall_2(d,Nema17_screw_hole_dist+d/2, h,30);
  // diametral opposite screw
    rotate([0,0,-45])
    translate([Nema17_screw_hole_width/2,0,0])
    rotate([0,0,2*90])
    cyl_wall_2(d,Nema17_screw_hole_width+d/2, h,schwung_length);
}
//Nema17_schwung_screw_holes(M3_diameter, Big);

module Nema17(){
  cw = Nema17_cube_width;
  ch = Nema17_cube_height;
  sh = Nema17_shaft_height;
  union(){
    color("black")
    difference(){
      translate([-(cw-0.1)/2,-(cw-0.1)/2,1]) cube([cw-0.1,cw-0.1,ch-2]);
      for (i=[0:90:359]){ // Corner cuts black cube
        rotate([0,0,i+45]) translate([50.36/2,-cw/2,-1]) cube([cw,cw,ch+2]);
      }
    }
    color("silver")
    difference(){
      translate([-cw/2,-cw/2,0]) cube([cw,cw,ch]);
      for (i=[0:90:359]){ // Corner cuts silver cube
        rotate([0,0,i+45]) translate([53.36/2,-cw/2,-1]) cube([cw,cw,ch+2]);
      }
      translate([0,0,ch-5]) Nema17_screw_holes(M3_diameter, h=10);
      translate([0,0,-5]) Nema17_screw_holes(M3_diameter, h=10);
      translate([-cw,-cw,9]) cube([2*cw,2*cw,ch-18]);
    }
    color("silver")
    difference(){
      cylinder(r=Nema17_ring_diameter/2, h=ch+Nema17_ring_height);
      translate([0,0,1]) cylinder(r=8.76/2, h=ch+Nema17_ring_height);
    }
    color("silver")
      cylinder(r=5/2, h=sh); // Shaft...
  }
}
//Nema17();

module Ramps(){
  color("tomato")
    cube([Ramps_length, Ramps_width, Ramps_depth]);
}
//Ramps();

module Bearing_623(){
  color("blue")
  difference(){
    cylinder(r=Bearing_623_outer_diameter/2, h=Bearing_623_width);
    translate([0,0,-1])
      cylinder(r=Bearing_623_bore_diameter/2, h=Bearing_623_width+2);
  }
}
//Bearing_623();

module Bearing_608(){
  color("blue")
  difference(){
    cylinder(r=Bearing_608_outer_diameter/2, h=Bearing_608_width);
    translate([0,0,-1])
      cylinder(r=Bearing_608_bore_diameter/2, h=Bearing_608_width+2);
  }
}
//Bearing_608();

module M3_screw(h, updown=false){
  color("grey"){
    cylinder(r=M3_diameter/2, h=h);
    if(updown){
      translate([0,0,h-M3_head_height])
        cylinder(r=M3_head_diameter/2, h=M3_head_height, $fn=6);
    }else{
      cylinder(r=M3_head_diameter/2, h=M3_head_height, $fn=6);
    }
  }
}
//M3_screw(10);

// E3d v6 with Volcano
module fan(width=30, height=10){
  linear_extrude(height=height, twist=-40)
  for(i=[0:6]){
    rotate([0,0,(360/7)*i])
      translate([0,-0.5])
        square([width/2 - 2, 1]);
  }
  cylinder(h=height, r=width/4.5);

  difference(){
    translate([-width/2, -width/2,0])
      cube([width,width,height]);
    translate([0,0,-1]) cylinder(r=width/2 - 1, h=height+2);
    for(i=[1,-1]){
      for(k=[1,-1]){
        translate([i*width/2-i*2.5,k*width/2-k*2.5,-1])
          cylinder(r=1, h=height+2);
      }
    }
  }
}

module Volcano_block(){
  small_height = 18.5;
  large_height = 20;
  color("silver"){
  translate([-15.0,-11/2,0])
    difference(){
      cube([20,11,large_height]);
      translate([7,0,small_height+3])
        rotate([90,0,0])
        cylinder(h=23, r=3, center=true,$fn=20);
      translate([-(20-7+1.5),-1,small_height]) cube([22,13,2]);
    }
    }
  color("gold"){
    translate([0,0,-3]) cylinder(h=3.1,r=8/2,$fn=6);
    translate([0,0,-3-2]) cylinder(h=2.01, r2=6/2, r1=2.8/2);
  }
}
//Volcano_block();

// Contains a lot of unnamed measured numbers...
module e3d_v6_volcano_hotend(fan=1){
  lpl = 2.1;
  if(fan){
  color("blue") rotate([90,0,0]) import("stl/V6_Duct.stl");
  color("black")
    translate([-15,0,15])
      rotate([0,-90,0])
        fan(width=30, height=10);
  }
  color("LightSteelBlue"){
    cylinder(h=26, r1=13/2, r2=8/2);
    for(i = [0:10]){
      translate([0,0,i*2.5]) cylinder(h=1, r=22.3/2);
    }
    translate([0,0,E3d_heatsink_height-3.7])     cylinder(h=3.7, r=E3d_mount_big_r);
    translate([0,0,E3d_heatsink_height-3.7-6.1]) cylinder(h=6.2, r=E3d_mount_small_r);
    translate([0,0,E3d_heatsink_height-3.7-6-3]) cylinder(h=3, r=E3d_mount_big_r);
    translate([0,0,26-0.1]) cylinder(h=E3d_heatsink_height-(12.7+26)+0.2, r=8/2);
    translate([0,0,26+1.5]) cylinder(h=1, r=E3d_mount_big_r);
    // echo(42.7-(12.7+26));
    translate([0,0,-lpl-0.1]) cylinder(h=lpl+0.2,r=2.8/2);
  }
  translate([0,0,-20-lpl]) Volcano_block();
}
//e3d_v6_volcano_hotend();

module filament(){
  color("white") translate([0,0,-50]) cylinder(r=1.75/2, h = 300);
}
//filament();
