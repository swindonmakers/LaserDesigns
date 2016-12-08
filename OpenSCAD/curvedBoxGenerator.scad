include <moreShapes.scad>

// exterior dimensions
width = 80;
depth = 80;
height = 100;

tabWidth = 8;
t = 3.4;  // material thickness
kerf = 0.1;
fontSize = 8;
// text labels
labels = ["Top","Left","Front","Right","Back","Bottom"];

// hinge settings
cornerRadius = 25;
hingeSlotLength = 20;
hingeSlotXSpacing = 2;
hingeSlotYSpacing = 25;  // space between centres
hingeSlotWidth = 0.01;  // make sure this is small enough to be welded into a single line

// hinge calculatiomns
hingeWidth = 2*PI*cornerRadius / 4;
hw = hingeWidth;

iw = width - 2*cornerRadius;
id = depth - 2*cornerRadius;

echo("Width: ", ( 2*iw + 2*id + 4*hw ) ); // to check sheet size


module tabPattern(w, d, male) {
    n = floor(w / tabWidth);
    w2 = (n-1)*(tabWidth)/2 + (n%2 ==0 ? tabWidth/2 : 0);
    translate([-tabWidth/2, d/2 - t + kerf,0])
        for (j=[0:n+4])
        translate([tabWidth*j - w2 - 2*tabWidth + kerf, 0, 0])
        if (j % 2 == (male ? 1 : 0))
        square([tabWidth - 2*kerf, t+1]);

    // make sure the corners fit
    *for (i=[-1,1])
        translate([i*w/2 - t + kerf, d/2 - t + kerf,0])
        square([2*t - 2*kerf,t+1]);
}


// size = [width, height]
// pattern = 0 for no tabs, 1 for male, 2 for female [top, right, bottom, left]
module plate(size, pattern, name, tabOffsets=[0,0,0,0]) {
    w = size[0];
    d = size[1];
    difference() {
        square(size, center=true);

        // top
        if (pattern[0] > 0)
            translate([ tabOffsets[0], 0, 0])
            tabPattern(w, d, pattern[0] == 1);

        // bottom
        if (pattern[2] > 0)
            translate([ tabOffsets[2], 0, 0])
            rotate([0,0,180]) tabPattern(w, d, pattern[2] == 1);

        // left
        if (pattern[3] > 0) rotate([0,0,-90]) tabPattern(d, w, pattern[3] == 1);

        // right
        if (pattern[1] > 0) rotate([0,0,90]) tabPattern(d, w, pattern[1] == 1);

        // name
        text(name, valign="center", halign="center", size=fontSize);
    }
}

module roundedPlate(size, pattern, name) {
    intersection() {
        plate(size, pattern, name);
        union() {
            square([width, depth-2*cornerRadius], center=true);
            square([width - 2*cornerRadius, depth], center=true);
            roundedSquare([width - 2*t, depth - 2*t], cornerRadius, center=true);
        }
    }
}

module hinge(size) {
    w = size[0];
    d = size[1];
    //color("red")
    difference() {
        square(size, center=true);

        // hinge pattern
        nx = floor( w / hingeSlotXSpacing);
        ny = floor( d / hingeSlotYSpacing);

        lx = -hingeSlotXSpacing * nx/2;
        ty = -hingeSlotYSpacing * ny/2;

        for (x = [0 : nx], y = [0 : ny])
            translate([lx + x * hingeSlotXSpacing, ty + y * hingeSlotYSpacing + (x % 2== 0 ? hingeSlotYSpacing/2 : 0) ])
            square([hingeSlotWidth, hingeSlotLength], center=true);
    }
}


// plates
// in logical layout (for sense checking design)

// top
translate([0,0.5,0])
    roundedPlate([width, depth], [2, 2, 2, 2], labels[0]);


union() {
    // back - left
    translate([-iw/2 - id - iw/4 - 2*hw - t/4, -depth/2 - height/2])
        plate([iw/2 + t/2, height], [1,1,1,0], "", [-iw/4 + t/4, 0,-iw/4 + t/4,0]);

    translate([-iw/2 - id - 1.5*hw, -depth/2 - height/2, 0])
        hinge([hw + eta, height]);

    //left
    translate([-iw/2 - id/2 - hw, -depth/2 - height/2])
        plate([id, height], [1,0,1,0], labels[1]);

    translate([-iw/2 - hw/2, -depth/2 - height/2])
        hinge([hw + eta, height]);

    //front
    translate([0, -depth/2 - height/2])
        plate([iw, height], [1,0,1,0], labels[2]);

    translate([iw/2 + hw/2, -depth/2 - height/2])
        hinge([hw + eta, height]);

    //right
    translate([iw/2 + id/2 + hw, -depth/2 - height/2])
        plate([id, height], [1,0,1,0], labels[3]);

    translate([iw/2 + id + 1.5*hw, -depth/2 - height/2])
        hinge([hw + eta, height]);

    // back - right
    translate([iw/2 + id + iw/4 + 2*hw + t/4, -depth/2 - height/2])
        plate([iw/2 + t/2, height], [1,0,1,2], "", [-iw/4 - t/2,0,-iw/4 - t/2,0]);
}


// bottom
translate([0, -depth - height - 0.5])
    roundedPlate([width, depth], [2, 2, 2, 2], labels[5]);
