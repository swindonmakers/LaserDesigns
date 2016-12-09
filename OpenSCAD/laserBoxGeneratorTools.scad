
// constants to keep tool drawers consistantly sized.
width = 210-10;
depth = 297-10;
box_margin = 15;

tabWidth = depth/20.5;
t = 3.4;  // material thickness
kerf = 0.1;
fontSize = 9;

// Things that can vary per-box
height = 25;

labels = [];
front_label = "Hacksaws";
text_margin = 10;

module tabPattern(w, d, male) {
    n = floor(w / tabWidth);
    w2 = (n-1)*(tabWidth)/2 + (n%2 ==0 ? tabWidth/2 : 0);
    translate([-tabWidth/2, d/2 - t + kerf,0])
        for (j=[0:n])
        translate([tabWidth*j - w2 + kerf, 0, 0])
        if (j % 2 == (male ? 1 : 0))
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
        tabPattern(w, d, pattern[0]);

        // bottom
        rotate([0,0,180]) tabPattern(w, d, pattern[2]);

        // left
        rotate([0,0,-90]) tabPattern(d, w, pattern[3]);

        // right
        rotate([0,0,90]) tabPattern(d, w, pattern[1]);

        // name
        text(name, valign="center", halign="center", size=fontSize);
    }
}


// plates
// in nicely packed layout

// top (in top-left corner)
translate([0,0.5,0]) {
    difference () {
        plate([width, depth], [false, false, false, false], labels[0]);
        square([width-box_margin*2, depth-box_margin*2], center=true);
    }
}

//left
translate([-width/2 - depth/2 - 0.5, -depth/2 - height/2])
    plate([depth, height], [true,false,true,false], labels[1]);

//front
translate([0, -depth/2 - height/2]) {
    difference() {
        plate([width, height], [true,true,true,true]);

        // name
        translate([-width/2 + text_margin, 0])
        text(front_label, valign="center", halign="left", size=fontSize);
        translate([+width/2 - text_margin, 0])
        text(front_label, valign="center", halign="right", size=fontSize);
    }
}

//right
translate([width/2 + depth/2 + 0.5, -depth/2 - height/2])
    plate([depth, height], [true,false,true,false], labels[3]);

// back
translate([2*width/2 + depth + 1, -depth/2 - height/2])
    plate([width, height], [true,true,true,true], labels[4]);

// bottom
translate([0, -depth - height - 0.5])
    plate([width, depth], [false, false, false, false], labels[5]);
