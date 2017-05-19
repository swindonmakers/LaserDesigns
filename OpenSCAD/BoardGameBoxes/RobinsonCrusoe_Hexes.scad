use <../laserBoxGenerator.scad>;
mainThickness = 3.4;
dividerThickness = 1.6;
kerf = 0.15;

makeBox([91+0.2, 80+0.25, 24+0.25],
        [false, true, true, true, true, true], // sides
        ["", "", "Hexes"], // labels
        false, // scallops
        [] // dividers
        );

