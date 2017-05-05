/* Choose one of these things to be displayed */
SHOW_DEMO = false;
LASER_HALFCLAMP = true;
$fs = 0.1;

laserable_depth = 3;

copper_color = [184/255, 115/255, 51/255];

/* size of PCB stock to fit in the frame */
pcb_x = 160;
pcb_y = 100;
pcb_z = 1.6;

/* how much space around the edge of the PCB will we loose by it being used as a clamp */
clamping_width = 3;

/* Our mill has three t-slot slots.  This is the spacing between them.  This is the bit most likely to need modifications for different mills & such. */
/* Surprisingly, our proxxon (de) mill appears to have come with a slide table that was designed in inches. */
t_slot_spacing = 25.04;
t_slot_bolt_d = 6;

x_margin_width = t_slot_bolt_d + 4;
y_margin_width = 10;

if (LASER_HALFCLAMP) {
    projection() {
    half_clamp();
    }
}

if (SHOW_DEMO) {

color(copper_color)
 cube([pcb_x, pcb_y, pcb_z]);

difference() {
union () {
 translate([0, 0, pcb_z + 0.01])
  half_clamp();

 translate([0, 0, -laserable_depth - 0.01])
  half_clamp();
}

}
}


/*translate([-t_slot_bolt_d/2, , -(laserable_depth + 1)])
cylinder(r=t_slot_bolt_d/2, h=laserable_depth*2 + pcb_z + 2);
*/




module half_clamp() {
 difference(){
  translate([-x_margin_width, 
             -y_margin_width, 0])
   cube([pcb_x + 2 * x_margin_width,
         pcb_y + 2 * y_margin_width,
         laserable_depth]);
  
  translate([clamping_width, 
             clamping_width, -1])
   cube([pcb_x - 2 * clamping_width,
         pcb_y - 2 * clamping_width,
         laserable_depth+2]);

    for (y_offset=[-1 * t_slot_spacing, 0, 1 * t_slot_spacing]) {
     echo("Bolt ", y_offset);
     translate([0,
                pcb_y / 2 + y_offset,
                -(laserable_depth + 1)]) {
    
      translate([-x_margin_width/2, 0, 0])
       cylinder(r=t_slot_bolt_d/2,
                h=laserable_depth * 2 + pcb_z + 2);
                 
      translate([pcb_x + x_margin_width/2, 0, 0])
       cylinder(r=t_slot_bolt_d/2,
                h=laserable_depth * 2 + pcb_z + 2);
    
     }
    }
 }
}
