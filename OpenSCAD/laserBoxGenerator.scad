mainThickness = 2.8;  // main material thickness
dividerThickness = 2.8; // divider material thickness
// smaller numbers -> tighter corners.
kerf = 0.14;
fontSize = 9;
tabCount = 6;

//labels = ["Top","Left","Front","Right","Back","Bottom"];
labels = ["","Laser Material","Donations","Laser Material","Donations","LAZOORS!!"];

// sizes, 100w,100d,160h
// sides - same order as labels above, set to false to not have that side at all
// box with all sides and labels
makeBox(size=[20,20,20],
        labels=labels);

// box with no top and cutouts on sides, no labels
// makeBox(size=[100,100,100],
//         sides=[false, true, true, true, true, true],
//         scallops=true);

// box with no top and single left/right divider
// NB: Divider code assumes that you remove the top, and add dividers verticallty
// makeBox(size=[100,100,100],
//         sides=[false, true, true, true, true, true],
//         dividers=[false, true, false]);


// calculate tabWidth base on size len:
function tabWidth(n) = n>0 && n<60 ? floor(n/tabCount) : 12;

// kind:
//  ""        -- no-op, produce no geometry
//  "m" / "f" -- tabs, will mate with each-other if same tabWidth.
//  "s" -- scalloped edge
//  "top_slot" / "btm_slot" -- half-there slots, so you can shove in toward the edge.
//     Mating pair.
// Assumes we are putting an edge on the top of a plate that is w * d, centered at (0, 0).
// Generates 2d geometry
module edge(w, d, kind, tabWidth, thickness) {
    if (kind == "m" || kind == "f") {
        tabPattern(w, d, kind, tabWidth, thickness);
    } else if (kind == "") {
        // do nothing
    } else if (kind == "s") {
        scallop(w, d, tabWidth, thickness);
    } else if (kind == "btm_slot") {
        translate([0, d/2 - thickness])
          square([w/2, thickness]);
    } else if (kind == "top_slot") {
        translate([-w/2, d/2 - thickness])
          square([w/2, thickness]);
    } else {
        assert("Unknown edge kind"+kind);
    }
}

module tabPattern(w, d, male, tabWidth, thickness) {
    n = floor(w / tabWidth);
    w2 = (n-1)*(tabWidth)/2 + (n%2 ==0 ? tabWidth/2 : 0);
    translate([-tabWidth/2, d/2 - thickness + kerf,0])
        for (j=[0:n])
        translate([tabWidth*j - w2 + kerf, 0, 0])
        if (j % 2 == (male == "m" ? 1 : 0))
        square([tabWidth - 2*kerf, thickness+kerf]);

    // make sure the corners fit
    for (i=[-1,1])
        translate([i*w/2 - thickness+ kerf, d/2 - thickness+ kerf,0])
        square([2*thickness- 2*kerf,thickness+1]);
}

module scallop(w, d, tabWidth, thickness) {
    // long shallow half-ellipse
    translate([0, d/2,0])
    resize(newsize=[w-2*tabWidth, d*2-thickness])
        circle(r=tabWidth);
}

// size = [width, height]
// pattern = [top, right, bottom, left, vdivs, hdivs], values documented for edge()
// name = label to add on the middle of this face
// divider_count = [bottom_top, left_right] = counts
module plate(size, pattern, text, vdivs, hdivs) {
    echo("plate:", size, pattern, text, vdivs, hdivs);
    w = size[0];
    d = size[1];
    tabWidths = [ for (x = [0 : len(size)-1]) tabWidth(size[x]) ];

    difference() {
        square(size, center=true);

        // top
        rotate([0,0,  0]) edge(w, d, pattern[0], tabWidths[0], mainThickness);

        // right
        rotate([0,0,-90]) edge(d, w, pattern[1], tabWidths[1], mainThickness);

        // bottom
        rotate([0,0,180]) edge(w, d, pattern[2], tabWidths[0], mainThickness);

        // left
        rotate([0,0,90]) edge(d, w, pattern[3], tabWidths[1], mainThickness);

        // Extra vertical dividers
        if (len(vdivs))
        for (i = [0:len(vdivs)-1]) {
            translate([vdivs[i],0])
              rotate([0, 0, 90])
                edge(d, w, pattern[4], tabWidths[1], mainThickness);
        }

        // Extra horizontal dividers
        if (len(hdivs))
        for (i = [0:len(hdivs)-1]) {
            translate([0, hdivs[i]])
              rotate([0, 0, 180])
                edge(w, d, pattern[5], tabWidths[0], mainThickness);
        }
        


        // name
        text(text, valign="center", halign="center", size=fontSize);
    }
}

// size = [width, depth, height]
// sides = true/false list for each of top, left, front, right, back, bottom
// labels = text string for the middle of each face, if required
// scallops = true/false, make finger cut outs (eg for extracting cards from box) instead of no-tabs
// divider_count = [top_btm_count, left_right_count, front_back_count] = regularly spaced dividers per side
//    NOTE: 3 dividers -> four pieces!
// NB: This code currently only makes finger cut outs on edges where the top is missing
module makeBox(size=[100,100,100],
               sides=[true,true,true,true,true,true],
               labels=[],
               scallops=false,
               divider_count=[0,2]) {


    // plates
    // in logical layout (for sense checking design)
    width = size[0];
    depth = size[1];
    height = size[2];
    // tb_divs -- locations of the dividers which are parallel to the top
    // and bottom of the box
    lr_divs = divider_count[0] ? [ for (i = [1:divider_count[0]]) i*size[0]/(divider_count[0]+1) ] : [];
    fb_divs = divider_count[1] ? [ for (i = [1:divider_count[1]]) i*size[1]/(divider_count[1]+1) ] : [];
    tb_divs = divider_count[2] ? [ for (i = [1:divider_count[2]]) i*size[2]/(divider_count[2]+1) ] : [];

    echo("tb_divs: ", tb_divs);
    echo("lr_divs: ", lr_divs);
    echo("fb_divs: ", fb_divs);
    
    // top
    if(sides[0]) {
        translate([0,0.5,0])
            difference() {
                //                     t, r, b, l
                plate([width, depth],
                      [sides[4] ? "f" : "", // top
                       sides[3] ? "f" : "", // right
                       sides[2] ? "f" : "", // bottom
                       sides[1] ? "f" : ""  // left
                      ],
                      labels[0], fb_divs, lr_divs);
            }
    }
    //left
    echo("left");
    if(sides[1]) {
        translate([-width/2 - depth/2 - 0.5, -depth/2 - height/2])
            plate([depth, height],
                  [sides[0] ? "m" : "", // top
                   sides[2] ? "f" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[4] ? "f" : "" , // left
                   "m", // vdiv pattern
                   "m"  // hdiv pattern
                  ], labels[1], fb_divs, tb_divs);
    }
    //front
    echo("front");
    if(sides[2]) {
        translate([0, -depth/2 - height/2])
             plate([width, height],
                   [sides[0] ? "m" : scallops ? "s" : "", // top
                    sides[3] ? "m" : "", // right
                    sides[5] ? "m" : "", // bottom
                    sides[1] ? "m" : "",  // left
                   "m", // vdiv pattern
                   "m"  // hdiv pattern
                   ], labels[2], lr_divs, tb_divs);
    }
    //right
    echo("right");
    if(sides[3]) {
        translate([width/2 + depth/2 + 0.5, -depth/2 - height/2])
            plate([depth, height],
                  [sides[0] ? "m" : "", // top
                   sides[4] ? "f" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[2] ? "f" : "",  // left
                   "m", // vdiv pattern
                   "m"  // hdiv pattern
                  ], labels[3], fb_divs, tb_divs);
    }
    // back
    echo("back");
    if(sides[4]) {
        translate([2*width/2 + depth + 1, -depth/2 - height/2])
            plate([width, height],
                  [sides[0] ? "m" : scallops ? "s" : "", // top
                   sides[1] ? "m" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[3] ? "m" : "",  // left
                   "m", // vdiv pattern
                   "m"  // hdiv pattern
                  ], labels[4], lr_divs, tb_divs);
    }
    // bottom
    if(sides[5]) {
        echo("bottom");
        translate([0, -depth - height - 0.5])
             #plate([width, depth],
                   [sides[2] ? "f" : "", // top
                    sides[3] ? "f" : "", // right
                    sides[4] ? "f" : "", // bottom
                    sides[1] ? "f" : "",  // left
                   "m", // vdiv pattern
                   "m"  // hdiv pattern
                        ], labels[5],
                   lr_divs, fb_divs);
    }


   // dividers (holes front/back)
   // "slot" for these means make a slot in the dividers
     for(i=[1:1:divider_count[1]]) {
       translate([-width/2 - depth/2 - 2, -i*depth+mainThickness])
           #plate([depth, height],
                 ["",
                 "f",
                 "f",
                 "f",
                 "top_slot",
                 ""
                 ], "", fb_divs, lr_divs);
     }

   // dividers (holes left/right)
     for(i=[1:1:divider_count[0]]) {
       translate([2*width/2 + depth + 1, -(i+1)*(depth/2)])
           #plate([width, height],
                 ["",
                 "f",
                 "f",
                 "f",
                 "btm_slot",
                 ""
                 ], "", lr_divs, lr_divs);
     }

}

