use <../laserBoxGenerator.scad>;

makeBox([50+0.25, 255+0.25, 24+0.25],
        [false, true, true, true, true, true], // sides
        ["", "Small   Cards",], // labels
        false, // scallops
        [false, true, false, true, false, false, 3] // dividers
        );

