use <../laserBoxGenerator.scad>;

makeBox([64-1.5, 95-1.5, 27-1.5],
        [false, true, true, true, true, true], // sides
        ["", "", "Events"], // labels
        false, // scallops
        [] // dividers
        );

