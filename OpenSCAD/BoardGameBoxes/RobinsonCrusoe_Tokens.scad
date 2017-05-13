use <../laserBoxGenerator.scad>;

makeBox([20-1.5, 255-1.5, 45-1.5],
        [false, true, true, true, true, true], // sides
        ["", "Tokens",], // labels
        false, // scallops
        [false, true, false, true, false, false, 5] // dividers
        );

