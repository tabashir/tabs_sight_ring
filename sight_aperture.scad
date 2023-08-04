include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// width of the outer ring wall
ring_thickness=1.0;

// diameter of outer ring
ring_outer_diameter=14;

// height of outer ring
ring_sight_depth=8;

// inner pinhole internal diameter
pin_inner_hole_diameter=2.5;

// width of the stay and ring for the pinhole
pin_stay_thickness=0.6;

// depth of the pin as percent of total ring height
pin_depth_percent=60;

// how long should the connector tube be
thread_tube_length=10;

// how much of tube should not be threaded
thread_tube_offset=3;

// Threaded Tube to screw onto sight bar - defaults 8-32 UNC
thread_tube_hole_diameter=4.7;
thread_tube_pitch=0.795;

// calculated from the above
ring_horiz_trans=ring_thickness-(ring_outer_diameter/2);
thread_tube_vert_trans=ring_sight_depth/2;
thread_tube_horiz_trans=((thread_tube_length+ring_outer_diameter)/2)-ring_thickness;
pin_outer_diameter=pin_inner_hole_diameter+(pin_stay_thickness*2);
pin_tube_thickness=(pin_outer_diameter-pin_inner_hole_diameter)/2;

pin_height=ring_sight_depth*pin_depth_percent/100;

$fn=$preview ? 25 : 200;
$fa=$preview ? 3 : 0.1;
$fs=$preview ? 1 : 0.1;

difference() {
  union() {
    // outer tube
    tube(ring_outer_diameter, ring_thickness, ring_sight_depth);
    
    // sight_bar mount
      rotate([90,0,0]) {
      union() {
        translate([0,thread_tube_vert_trans,-ring_horiz_trans]) {
          cylinder(d=ring_sight_depth*0.8,h=thread_tube_offset);
        }
        translate([0,thread_tube_vert_trans,thread_tube_horiz_trans]) {
          threaded_nut(od=ring_sight_depth, id=thread_tube_hole_diameter, h=thread_tube_length, pitch=thread_tube_pitch, $slop=0.05);
        }
      }
    }

    // inner aperture
    tube(pin_outer_diameter, pin_tube_thickness, pin_height);

    translate([pin_stay_thickness/2, ring_horiz_trans ,0]) {
      rotate([0,0,90]) {
        cube([ring_outer_diameter-ring_thickness, pin_stay_thickness, pin_height]);
      }
    }
  }

  // aperture hole
  translate([0,0,-1]) {
    cylinder(d=pin_inner_hole_diameter,h=ring_sight_depth+2);
  }

}

module tube(outer_diameter, wall_thickness, height) {
  linear_extrude(height) {
    difference() {
      circle(d=outer_diameter);
      circle(d=outer_diameter-(wall_thickness*2));
    }
  }
}



