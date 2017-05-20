use <../laserBoxGenerator.scad>;

makeBox([20+0.25, 255+0.25, 45+0.25],
        [false, true, true, true, true, true], // sides
        ["", "Tokens",], // labels
        false, // scallops
        [false, true, false, true, false, false, 5] // dividers
        );

