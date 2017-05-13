use <../laserBoxGenerator.scad>;

makeBox([64+0.25, 95+0.25, 18+0.25],
        [false, true, true, true, true, true], // sides
        ["", "", "Dice"], // labels
        false, // scallops
        [] // dividers
        );

