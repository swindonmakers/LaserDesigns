use <../laserBoxGenerator.scad>;
mainThickness = 3.4;
dividerThickness = 1.6;
kerf = 0.15;

// First dimension is stretched to fill space
makeBox([102+0.25, 80+0.25, 24+0.25],
        [false, true, true, true, true, true], // sides
        ["", "", "Pawns"], // labels
        false, // scallops
        [] // dividers
        );

