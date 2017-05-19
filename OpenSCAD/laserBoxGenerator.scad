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
makeBox([20,20,20], [false, true, true, true, true, true], [], []);

// box with no top and cutouts on sides, no labels
// makeBox([100,100,100], [false, true, true, true, true, true], [], true);

// box with no top and single left/right divider
// NB: Divider code assumes that you remove the top, and add dividers verticallty
// makeBox([100,100,100], [false, true, true, true, true, true], [], false, [false, true, false, true, false, false]);


// calculate tabWidth base on size len:
function tabWidth(n) = n>0 && n<30 ? floor(n/tabCount) : 12;

module tabPattern(w, d, male, tabWidth, thickness) {
    n = floor(w / tabWidth);
    w2 = (n-1)*(tabWidth)/2 + (n%2 ==0 ? tabWidth/2 : 0);
    translate([-tabWidth/2, d/2 - thickness + kerf,0])
        for (j=[0:n])
        translate([tabWidth*j - w2 + kerf, 0, 0])
        if (j % 2 == (male == "m" ? 1 : 0))
        square([tabWidth - 2*kerf, thickness+1]);

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
module plate(size, pattern, name, divider, divider_count) {
    w = size[0];
    d = size[1];
    tabWidths = [ for (x = [0 : len(size)-1]) tabWidth(size[x]) ];

    difference() {
        square(size, center=true);

        // top
        if(pattern[0]) {
            if(pattern[0] == "s") {
                scallop(w,d,tabWidths[1]*2);
            } else {
                tabPattern(w, d, pattern[0], tabWidths[0], mainThickness);
            }
        }

        // bottom
        if(pattern[2]) {
          rotate([0,0,180]) tabPattern(w, d, pattern[2], tabWidths[0], mainThickness);
        }

        // left
        if(pattern[3]) {
            rotate([0,0,90]) tabPattern(d, w, pattern[3], tabWidths[1], mainThickness);
        }

        // right
        if(pattern[1]) {
          rotate([0,0,-90]) tabPattern(d, w, pattern[1], tabWidths[1], mainThickness);
        }

        // Extra gubbins if this plate will connect to a divider
        // mid-plate front/back slots for divider end
        if(divider && (divider == "fb" || divider == "both")) {
            translate([0, d/2])
                rotate([0,0,180]) tabPattern(w, d, pattern[2], tabWidths[0], dividerThickness);

        }

        // mid-plate left/right slots for divider end
        if(divider == true || divider == "both" || divider == "lr") {
            translate([w/2,0])
               rotate([0,0,90]) tabPattern(d, w, pattern[3], tabWidths[1], dividerThickness);

        }

        // Extra gubbins if this plate is itself a divider
        // connecting slots between two divider pieces
        // NB This is 0, d/4 because the square is center=true
        if(divider && divider == "top_slot") {
            translate([0,d/4+kerf])
               square([dividerThickness+1,d/2], center=true);
        }
        if(divider && divider == "btm_slot") {
            translate([0,-d/4+kerf])
                square([dividerThickness+1,d/2], center=true);
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
module makeBox(size, sides, labels, scallops, dividers) {
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
                      labels[0], dividers[0], dividers[6]);

                // pill slot
                hull()
                    for (i=[-1,1])
                    translate([i*20,0,0])
                    circle(3, $fn=16);
            }
    }
    //left
    if(sides[1]) {
        translate([-width/2 - depth/2 - 0.5, -depth/2 - height/2])
            plate([depth, height],
                  [sides[0] ? "m" : "", // top
                   sides[2] ? "f" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[4] ? "f" : "" // left
                  ], labels[1], dividers[1], dividers[6]);
    }
    //front
    if(sides[2]) {
        translate([0, -depth/2 - height/2])
             plate([width, height],
                   [sides[0] ? "m" : scallops ? "s" : "", // top
                    sides[3] ? "m" : "", // right
                    sides[5] ? "m" : "", // bottom
                    sides[1] ? "m" : ""  // left
                   ], labels[2], dividers[2], dividers[6]);
    }
    //right
    if(sides[3]) {
        translate([width/2 + depth/2 + 0.5, -depth/2 - height/2])
            plate([depth, height],
                  [sides[0] ? "m" : "", // top
                   sides[4] ? "f" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[2] ? "f" : ""  // left
                  ], labels[3], dividers[3], dividers[6]);
    }
    // back
    if(sides[4]) {
        translate([2*width/2 + depth + 1, -depth/2 - height/2])
            plate([width, height],
                  [sides[0] ? "m" : scallops ? "s" : "", // top
                   sides[1] ? "m" : "", // right
                   sides[5] ? "m" : "", // bottom
                   sides[3] ? "m" : ""  // left
                  ], labels[4], dividers[4], dividers[6]);
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
                  dividers[2] && dividers[4] && dividers[1] && dividers[3]
                  ? "both"
                  : dividers[1] && dividers[3]
                    ? "fb"
                    : dividers[2] && dividers[4]
                      ? "lr"
                      : "", dividers[6]);
    }

    // dividers (holes front/back)
    // "slot" for these means make a slot in the dividers
    if(dividers[2] && dividers[4]) {
//        for(i=[1:dividers[6]])
        translate([-width/2 - depth/2 - 0.5, -depth])
            plate([depth, height],
                  ["",
                  "f",
                  "m",
                  "f"
                  ], "", dividers[2] && dividers[4] && dividers[1] && dividers[3] ? "top_slot" : "", dividers[6]);
    }

    // dividers (holes left/right)
    if(dividers[1] && dividers[3]) {
        translate([2*width/2 + depth + 1, -depth])
            plate([width, height],
                  ["",
                  "m",
                  "m",
                  "m"
                  ], "", dividers[2] && dividers[4] && dividers[1] && dividers[3] ? "btm_slot" : "", dividers[6]);
    }
}