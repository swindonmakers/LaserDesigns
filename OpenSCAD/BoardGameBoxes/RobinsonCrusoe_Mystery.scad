use <../laserBoxGenerator.scad>;
mainThickness = 3.4;
dividerThickness = 1.6;
kerf = 0.15;

makeBox([64+0.25, 95+0.25, 21+0.25],
        [false, true, true, true, true, true], // sides
        ["", "", "Mystery"], // labels
        false, // scallops
        [] // dividers
        );

