use <../laserBoxGenerator.scad>;

makeBox([50-1.5, 255-1.5, 24-1.5],
        [false, true, true, true, true, true], // sides
        ["", "Small   Cards",], // labels
        false, // scallops
        [false, true, false, true, false, false, 3] // dividers
        );

