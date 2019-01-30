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

module edge(w, d, kind, tabWidth, thickness) {
    if (kind == "m" || kind == "f") {
        tabPattern(w, d, kind, tabWidth, thickness);
    } else if (kind == "") {
        // do nothing
    } else if (kind == "s") {
        scallop(w, d, tabWidth);
    } else if (kind == "btm_slot") {
        translate([0, 0])
          square([dividerThickness+1, d/2]);
    } else if (kind == "top_slot") {
        translate([0, -d/4+kerf])
          square([dividerThickness+1, d/2]);
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

module scallop(w, d, tabWidth) {
    // long shallow half-ellipse
    translate([0,d/2,0])
    resize(newsize=[w-2*tabWidth,tabWidth*2])
        circle(r=tabWidth);
}

// size = [width, height]
// pattern = "m", "f", "" for male/female/no joint [top, right, bottom, left]
// name = label to add on the middle of this face
// divider_count = [bottom_top, left_right] = counts
module plate(size, pattern, name, divider_count) {
    echo("plate:", size, pattern, name, divider_count);
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

        // Extra gubbins if this plate will connect to a divider
           for (i = [1:1:divider_count[1]]) {
             echo("p5", pattern[5]);
             translate([0, i*d/(divider_count[1]+1)])
                if(pattern[5] == "btm_slot") {
                  translate([0,-d/4+kerf])
                    square([dividerThickness+1,d/2]);
                } else if(pattern[5] == "btm_slot") {
                  translate([0,-d/4+kerf])
                    square([dividerThickness+1,d/2]);
                } else {
                  rotate([0,0,180]) tabPattern(w, d, pattern[2], tabWidths[0], dividerThickness);
                }
           }

        // mid-plate front/back slots for divider end
        // count = 3, 1/3,2/3
           for (i = [1:1:divider_count[0]]) {
            translate([i*w/(divider_count[0]+1),0])
                if(pattern[4] == "top_slot") {
                  echo("top_slot");
                  translate([-w/2,0])
                    square([dividerThickness+1,d/2]);
                } else if(pattern[4] == "btm_slot") {
                  echo("btm_slot");
                  translate([-w/2,-d/2])
                    square([dividerThickness+1,d/2]);
                } else {
                  rotate([0,0,90]) tabPattern(d, w, pattern[3], tabWidths[1], dividerThickness);
                }
           }

        // name
        text(name, valign="center", halign="center", size=fontSize);
    }
}

// size = [width, depth, height]
// sides = true/false list for each of top, left, front, right, back, bottom
// labels = text string for the middle of each face, if required
// scallops = true/false, make finger cut outs (eg for extracting cards from box) instead of no-tabs
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

    // top
    if(sides[0]) {
        translate([0,0.5,0])
            difference() {
                //                     t, r, b, l
                plate([width, depth],
                      [sides[4] ? "f" : "", // top
                       sides[3] ? "f" : "", // right
                       sides[2] ? "f" : "", // bottom
                       sides[1] ? "f" : "" // left
                      ],
                      labels[0], [divider_count[2], divider_count[1]]);

                // pill slot
                hull()
                    for (i=[-1,1])
                    translate([i*20,0,0])
                    circle(3, $fn=16);
            }
    }
    //left
    echo("left");
    if(sides[1]) {
        translate([-width/2 - depth/2 - 0.5, -depth/2 - height/2])
            #plate([depth, height],
                  [sides[0] ? "m" : "", // top
                   sides[2] ? "f" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[4] ? "f" : "" // left
                  ], labels[1], [ divider_count[1], divider_count[0] ]);
    }
    //front
    if(sides[2]) {
        translate([0, -depth/2 - height/2])
             plate([width, height],
                   [sides[0] ? "m" : scallops ? "s" : "", // top
                    sides[3] ? "m" : "", // right
                    sides[5] ? "m" : "", // bottom
                    sides[1] ? "m" : ""  // left
                   ], labels[2], [ divider_count[2], divider_count[0]]);
    }
    //right
    if(sides[3]) {
        translate([width/2 + depth/2 + 0.5, -depth/2 - height/2])
            plate([depth, height],
                  [sides[0] ? "m" : "", // top
                   sides[4] ? "f" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[2] ? "f" : ""  // left
                  ], labels[3], [ divider_count[1], divider_count[0] ]);
    }
    // back
    if(sides[4]) {
        translate([2*width/2 + depth + 1, -depth/2 - height/2])
            plate([width, height],
                  [sides[0] ? "m" : scallops ? "s" : "", // top
                   sides[1] ? "m" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[3] ? "m" : ""  // left
                  ], labels[4], [ divider_count[2], divider_count[0]]);
    }
    // bottom
    if(sides[5]) {
        echo("bottom");
        translate([0, -depth - height - 0.5])
            plate([width, depth],
                  [sides[2] ? "f" : "", // top
                   sides[3] ? "f" : "", // right
                   sides[4] ? "f" : "", // bottom
                   sides[1] ? "f" : ""  // left
                  ], labels[5],
                  [divider_count[2], divider_count[1]]);
             }

    // dividers (holes front/back)
    // "slot" for these means make a slot in the dividers
      for(i=[1:1:divider_count[2]]) {
        translate([-width/2 - depth/2 - 2, -i*depth+mainThickness])
            plate([depth, height],
                  ["",
                  "f",
                  "m",
                  "f",
                  "top_slot",
                  ""
                  ], "", [ divider_count[1], divider_count[0] ]);
      }

    // dividers (holes left/right)
      for(i=[1:1:divider_count[1]]) {
        translate([2*width/2 + depth + 1, -(i+1)*(depth/2)])
            plate([width, height],
                  ["",
                  "m",
                  "m",
                  "m",
                  "btm_slot",
                  ""
                  ], "", [ divider_count[2], divider_count[0]]);
      }
}