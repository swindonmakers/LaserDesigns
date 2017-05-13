use <../laserBoxGenerator.scad>;

makeBox([110-1.5, 80-1.5, 24-1.5],
        [false, true, true, true, true, true], // sides
        ["", "", "Hexes"], // labels
        false, // scallops
        [] // dividers
        );

