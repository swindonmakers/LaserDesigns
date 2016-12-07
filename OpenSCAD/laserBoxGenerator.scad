
// exterior dimensions
width = 100;
depth = 100;
height = 160;

tabWidth = 12;
t = 3.4;  // material thickness
kerf = 0.1;
fontSize = 9;

//labels = ["Top","Left","Front","Right","Back","Bottom"];
labels = ["","Laser Material","Donations","Laser Material","Donations","LAZOORS!!"];

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
// in logical layout (for sense checking design)

// top
translate([0,0.5,0])
    difference() {
        plate([width, depth], [false, false, false, false], labels[0]);
        
        // pill slot
        hull() 
            for (i=[-1,1])
            translate([i*20,0,0])
            circle(3);
    }

//left
translate([-width/2 - depth/2 - 0.5, -depth/2 - height/2])
    plate([depth, height], [true,false,true,false], labels[1]);

//front
translate([0, -depth/2 - height/2])
    plate([width, height], [true,true,true,true], labels[2]);

//right
translate([width/2 + depth/2 + 0.5, -depth/2 - height/2])
    plate([depth, height], [true,false,true,false], labels[3]);

// back
translate([2*width/2 + depth + 1, -depth/2 - height/2])
    plate([width, height], [true,true,true,true], labels[4]);

// bottom
translate([0, -depth - height - 0.5])
    plate([width, depth], [false, false, false, false], labels[5]);


