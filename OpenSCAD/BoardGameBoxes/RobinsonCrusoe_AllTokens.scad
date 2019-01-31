use <../laserBoxGenerator.scad>;
//mainThickness = 2.8;
//dividerThickness = 2.8;
//kerf = 0.15;
//function tabCount()=2;

makeBox(size=[208+0.25, 228+0.25, 45+0.25],
        sides=[false, true, true, true, true, true],
        divider_count=[3,4,0]
        );

