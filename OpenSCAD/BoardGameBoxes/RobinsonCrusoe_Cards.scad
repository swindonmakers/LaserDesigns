use <../laserBoxGenerator.scad>;

makeBox([64+0.25, 95+0.25, 21+0.25],
        [false, true, true, true, true, true], // sides
        ["", "", "Cards"], // labels
        false, // scallops
        [] // dividers
        );

