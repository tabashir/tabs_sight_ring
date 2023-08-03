include <BOSL2/std.scad>
include <BOSL2/threading.scad>
// preview = true;
ring_thickness=1.5;
ring_outer_diameter=12;
ring_sight_depth=6;

pin_outer_diameter=4.5;
pin_inner_hole_diameter=3.0;
pin_stay_thickness=1;

thread_hole=3.5;
thread_tube_length=15;
// how much of tube should not be threaded
thread_tube_offset=5;

// calculated from the above
thread_tube_diameter=ring_sight_depth;
thread_tube_thickness=(thread_tube_diameter-thread_hole)/2;
thread_tube_horiz_trans=ring_thickness-(ring_outer_diameter/2);
thread_tube_vert_trans=ring_sight_depth/2;

pin_tube_thickness=(pin_outer_diameter-pin_inner_hole_diameter)/2;

$fn=$preview ? 25 : 200;
$fa=$preview ? 3 : 0.1;
$fs=$preview ? 1 : 0.1;

difference() {
  union() {
    // outer tube
    tube(ring_outer_diameter, ring_thickness, ring_sight_depth);
    
    // sight_bar mount
  translate([0,thread_tube_horiz_trans,thread_tube_vert_trans]) {
    rotate([90,0,0]) {
      difference() {
        tube(ring_sight_depth, thread_tube_thickness, thread_tube_length);
        translate([0,0,(thread_tube_length/2)+thread_tube_offset]) {
          threaded_rod(d=4.166, l=thread_tube_length, pitch=0.795, left_handed=false, internal=true);
        }
      }
    }
  }

    // inner aperture
    tube(pin_outer_diameter, pin_tube_thickness, ring_sight_depth);

    translate([pin_stay_thickness/2,thread_tube_horiz_trans,0]) {
      rotate([0,0,90]) {
        cube([ring_outer_diameter-ring_thickness, pin_stay_thickness, ring_sight_depth]);
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



