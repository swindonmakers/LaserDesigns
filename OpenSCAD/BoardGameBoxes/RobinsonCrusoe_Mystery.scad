use <../laserBoxGenerator.scad>;

makeBox([64, 95, 21],
        [false, true, true, true, true, true], // sides
        ["", "", "Cards"], // labels
        false, // scallops
        [] // dividers
        );

