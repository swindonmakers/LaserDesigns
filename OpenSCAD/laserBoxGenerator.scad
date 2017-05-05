tabWidth = 12;
t = 3.4;  // material thickness
kerf = 0.1;
fontSize = 9;

//labels = ["Top","Left","Front","Right","Back","Bottom"];
labels = ["","Laser Material","Donations","Laser Material","Donations","LAZOORS!!"];

// sizes, 100w,100d,160h
// sides - same order as labels above, set to false to not have that side at all
makeBox([100,100,160], [true, true, true, true, true, true], labels);

module tabPattern(w, d, male) {
    n = floor(w / tabWidth);
    w2 = (n-1)*(tabWidth)/2 + (n%2 ==0 ? tabWidth/2 : 0);
    translate([-tabWidth/2, d/2 - t + kerf,0])
        for (j=[0:n])
        translate([tabWidth*j - w2 + kerf, 0, 0])
        if (j % 2 == (male == "m" ? 1 : 0))
        square([tabWidth - 2*kerf, t+1]);

    // make sure the corners fit
    for (i=[-1,1])
        translate([i*w/2 - t + kerf, d/2 - t + kerf,0])
        square([2*t - 2*kerf,t+1]);
}


// size = [width, height]
// pattern = true|false for male/female joints [top, right, bottom, left]
module plate(size, pattern, name) {
    w = size[0];
    d = size[1];
    difference() {
        square(size, center=true);

        // top
        if(pattern[0]) {
          tabPattern(w, d, pattern[0]);
        }

        // bottom
        if(pattern[2]) {
          rotate([0,0,180]) tabPattern(w, d, pattern[2]);
        }

        // left
        if(pattern[3]) {
          rotate([0,0,90]) tabPattern(d, w, pattern[3]);
        }

        // right
        if(pattern[1]) {
          rotate([0,0,-90]) tabPattern(d, w, pattern[1]);
        }

        // name
        text(name, valign="center", halign="center", size=fontSize);
    }
}

// size = [width, depth, height]
// sides = true/false list for each of top, left, front, right, back, bottom
module makeBox(size, sides, labels) {
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
                plate([width, depth], [sides[4] ? "f" : "", // top
                                       sides[3] ? "f" : "", // right
                                       sides[2] ? "f" : "", // bottom
                                       sides[1] ? "f" : "" // left
                                       ], labels[0]);

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
            plate([depth, height], [sides[0] ? "m" : "", // top
                                    sides[2] ? "f" : "", // right
                                    sides[5] ? "m" : "", // bottom
                                    sides[4] ? "f" : "" // left
                                    ], labels[1]);
    }
    //front
    if(sides[2]) {
        translate([0, -depth/2 - height/2])
             plate([width, height], [sides[0] ? "m" : "", // top
                                     sides[3] ? "m" : "", // right
                                     sides[5] ? "m" : "", // bottom
                                     sides[1] ? "m" : ""  // left
                                     ], labels[2]);
    }
    //right
    if(sides[3]) {
        translate([width/2 + depth/2 + 0.5, -depth/2 - height/2])
            plate([depth, height], [sides[0] ? "m" : "", // top
                                    sides[4] ? "f" : "", // right
                                    sides[5] ? "m" : "", // bottom
                                    sides[2] ? "f" : ""  // left
                                    ], labels[3]);
    }
    // back
    if(sides[4]) {
        translate([2*width/2 + depth + 1, -depth/2 - height/2])
            plate([width, height], [sides[0] ? "m" : "", // top
                                    sides[1] ? "m" : "", // right
                                    sides[5] ? "m" : "", // bottom
                                    sides[3] ? "m" : ""  // left
                                    ], labels[4]);
    }
    // bottom
    if(sides[5]) {
        translate([0, -depth - height - 0.5])
            plate([width, depth], [sides[2] ? "f" : "", // top
                                   sides[3] ? "f" : "", // right
                                   sides[4] ? "f" : "", // bottom
                                   sides[1] ? "f" : ""  // left
                                   ], labels[5]);
    }
}