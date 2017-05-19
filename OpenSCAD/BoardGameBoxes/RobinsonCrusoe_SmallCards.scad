use <../laserBoxGenerator.scad>;
mainThickness = 2.8;
dividerThickness = 2.8;
kerf = 0.15;
tabCount=6;

makeBox(size=[50+0.25, 258+0.25, 24+0.25],
        sides=[false, true, true, true, true, true],
        labels=["", "Small Cards",],
        dividers=[false, true, false],
        divider_count=3
        );

