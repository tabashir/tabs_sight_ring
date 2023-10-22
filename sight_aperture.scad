include <BOSL2/std.scad>
include <BOSL2/threading.scad>

// width of the outer ring wall
ring_thickness=1.0;

// diameter of outer ring
ring_outer_diameter=14;

// height of outer ring
ring_sight_depth=8;

// inner pinhole internal diameter
pin_inner_hole_diameter=3.1;

// width of the stay for the pinhole
pin_stay_thickness=0.3;

// width of the ring for the pinhole
pin_ring_thickness=0.6;

// depth of the pin as percent of total ring height
pin_depth_percent=80;

// how long should the connector tube be
thread_tube_length=10;

// how much of tube should not be threaded
thread_tube_offset=3;

// Threaded Tube to screw onto sight bar.  M4=4.0, UNC8-32=4.16. (May need adjusting for printer accuracy)
thread_tube_hole_diameter=3.9;
// thread_tube_hole_diameter=4.16;

// Pitch of threaded Tube to screw onto sight bar. M4=0.7, UNC8-32=0.795
thread_tube_pitch=0.7;
// thread_tube_pitch=0.795;

// percent distance down the thread tube to put a ring like the aae pin. (-1 to disable). Greater than 60% will overhang bar
aae_percent_displacement=60;
// width of the aae bar
aae_width = 3;
// percentage of sight radius to make the aae bar
aae_height_percent = 130;

// how deep should label go. Zero should not show it
label_depth=0.3;

// calculated from the above
ring_outer_radius=ring_outer_diameter/2;
ring_horiz_trans=ring_outer_radius-ring_thickness;
thread_tube_vert_trans=ring_sight_depth/2;
thread_tube_horiz_trans=(thread_tube_length/2)+ring_outer_radius-ring_thickness;

pin_outer_diameter=pin_inner_hole_diameter+(pin_ring_thickness*2);
pin_tube_thickness=(pin_outer_diameter-pin_inner_hole_diameter)/2;
pin_height=ring_sight_depth*pin_depth_percent/100;

aae_mm_displacement = ring_horiz_trans+(thread_tube_length*aae_percent_displacement/100);
aae_bar_height = (ring_outer_diameter * aae_height_percent)/100;

label = str(pin_inner_hole_diameter);
label_size=ring_sight_depth/2;
label_horiz_trans = 0-ring_outer_radius-(thread_tube_length*0.8);
label_vert_trans = label_size/2;
label_z_trans = ring_sight_depth-label_depth;

$fn=$preview ? 25 : 200;
$fa=$preview ? 3 : 0.1;
$fs=$preview ? 1 : 0.1;
$slop=0.05;

difference() {
  union() {
    // outer tube
    tube(ring_outer_diameter, ring_thickness, ring_sight_depth);

    // sight_bar mount
      rotate([90,0,0]) {
      union() {
        translate([0,thread_tube_vert_trans,ring_horiz_trans]) {
          cylinder(d=ring_sight_depth*0.8,h=thread_tube_offset);
        }
        translate([0,thread_tube_vert_trans,thread_tube_horiz_trans]) {
          threaded_nut(od=ring_sight_depth, id=thread_tube_hole_diameter, h=thread_tube_length, pitch=thread_tube_pitch);
        }
      }
      translate([0,thread_tube_vert_trans,aae_mm_displacement]) {
        resize([aae_bar_height,ring_sight_depth,aae_width]) {
          tube(ring_sight_depth,(ring_sight_depth-thread_tube_hole_diameter)/2,1);
        }
      }
    }

    // inner aperture
    tube(pin_outer_diameter, pin_tube_thickness, pin_height);

    // horizontal pin stay
    translate([pin_stay_thickness/2, -ring_horiz_trans ,0]) {
      rotate([0,0,90]) {
        cube([ring_outer_diameter-ring_thickness, pin_stay_thickness, pin_height]);
      }
    }
    // vertical pin stay
    translate([0,0,pin_height/2]) {
      cube([ring_outer_diameter-ring_thickness, pin_stay_thickness, pin_height], center=true);
    }
  }

  // aperture hole
  translate([0,0,-1]) {
    cylinder(d=pin_inner_hole_diameter,h=ring_sight_depth+2);
  }

  translate([label_vert_trans, label_horiz_trans, label_z_trans]) {
    rotate([0,0,90]) {
      linear_extrude(2) text( label, size=label_size );
    }
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



