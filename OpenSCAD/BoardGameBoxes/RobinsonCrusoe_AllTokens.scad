use <../laserBoxGenerator.scad>;
mainThickness = 2.8;
dividerThickness = 2.8;
kerf = 0.15;
tabCount=6;

makeBox(size=[208+0.25, 228+0.25, 45+0.25],
        sides=[false, true, true, true, true, true],
        dividers=[false, true, true],
        divider_count=[0,3,4]
        );

