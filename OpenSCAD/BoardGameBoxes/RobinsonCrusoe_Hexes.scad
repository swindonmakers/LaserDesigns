use <../laserBoxGenerator.scad>;

makeBox([80+0.25, 80+0.25, 24+0.25],
        [false, true, true, true, true, true], // sides
        ["", "", "Hexes"], // labels
        false, // scallops
        [] // dividers
        );

