use <../laserBoxGenerator.scad>;

makeBox([64+0.25, 95+0.25, 27+0.25],
        [false, true, true, true, true, true], // sides
        ["", "", "Events"], // labels
        false, // scallops
        [] // dividers
        );

