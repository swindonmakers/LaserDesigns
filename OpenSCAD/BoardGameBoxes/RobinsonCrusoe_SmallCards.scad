use <../laserBoxGenerator.scad>;
mainThickness = 3.4;
dividerThickness = 1.6;
kerf = 0.15;
tabCount=6;

makeBox([50+0.25, 258+0.25, 24+0.25],
        [false, true, true, true, true, true], // sides
        ["", "Small   Cards",], // labels
        false, // scallops
        [false, true, false, true, false, false, 3] // dividers
        );

