
include <moreShapes.scad>

plyThickness = 3.4;
cellWidth = 25;
border = 5;
innerWidth = cellWidth * 8;
outerWidth = innerWidth + 2*border;
slotWidth=16.5;
slotDepth = plyThickness;
tol = 0.2;
pieceWidth = cellWidth * 0.9;

module board() {
    w = innerWidth;
    ow = outerWidth;

    difference() {
        translate([-tol, -tol, 0])
            roundedSquare([ow + 2*tol, ow + 2*tol], 5);

        // slots for pieces
        for (x=[0:7],y=[0:3])
            translate([x*cellWidth + border + cellWidth/2, y*cellWidth + border  + cellWidth/2])
            square([slotWidth + 1, slotDepth], center=true);

        // cut in half
        translate([-1, ow/2 + tol])
            square([ow+2, ow]);
    }

}

module boardEngraving() {
    w = innerWidth;

    // draw outline of main board
    translate([border,border,0 ])
        square([w,w/2]);
}

module sprayMask() {
    w = innerWidth + 10;
    ow = outerWidth + 10;

    difference() {
        translate([-tol -5, -tol -5, 0])
            roundedSquare([ow + 2*tol, ow + 2*tol], 5);

        // square masks
        for (x=[0:7],y=[0:3])
            if ((x+y) % 2 == 0)
            translate([x*cellWidth + border - tol, y*cellWidth + border - tol])
            roundedSquare([cellWidth+2*tol,cellWidth+2*tol],3, $fn=16);

        // cut in half
        translate([-10, ow/2 + tol])
            square([ow+20, ow]);
    }
}


module pawn() {
    tw = slotWidth + 2*tol;
    h = 30;
    w = pieceWidth * 0.9;
    union() {
        // bottom tab
        translate([-tw/2, -3-tol]) square([tw, 4 + tol]);

        // base
        translate([-pieceWidth/2, 0, 0]) roundedSquare([pieceWidth, 4],1, $fn=12);

        // triangle
        hull() {
            translate([-w/2, 0, 2]) square([w, 2]);

            translate([-3/2, h-6, 0]) square([3,1]);
        }

        // cross bar
        translate([-10/2, h-5-4, 0]) square([10, 3]);

        // circle on top
        translate([0,h-5/2,0])
            circle(5);
    }
}


module rook() {
    tw = slotWidth + 2*tol;
    h = 35;
    w = pieceWidth * 0.9;
    union() {
        // bottom tab
        translate([-tw/2, -3-tol]) square([tw, 4 + tol]);

        // base
        translate([-pieceWidth/2, 0, 0]) roundedSquare([pieceWidth, 4],1, $fn=12);

        // triangle
        hull() {
            translate([-w/2, 0, 2]) square([w, 2]);

            translate([-6/2, h-6, 0]) square([6,1]);
        }

        // cross bar
        translate([-15/2, h-10, 0]) square([15, 6]);

        // crennellations
        for (i=[0:2])
            translate([-15/2 + i*5.5, h-4, 0])
            square([4, 4]);
    }
}

module knight() {
    tw = slotWidth + 2*tol;
    h = 38;
    w = pieceWidth * 0.9;
    difference() {
        union() {
            // bottom tab
            translate([-tw/2, -3-tol]) square([tw, 4 + tol]);

            // base
            translate([-pieceWidth/2, 0, 0]) roundedSquare([pieceWidth, 4],1, $fn=12);

            // join
            translate([-w/2+3, 2, 0]) square([w-6, 4]);

            // body
            hull() {
                translate([-w/2, 6, 2]) square([w-5, 2]);

                // belly
                translate([w/2-8, 12, 0]) scale([1,1,1]) circle(8);

                translate([-w/2, h-6, 0]) square([6,1]);
            }

            hull() {
                // head
                translate([-w/2+5, h-5, 0]) circle(5);

                // nose
                translate([pieceWidth/2-4, h-13, 0]) rotate([0,0,-20]) square([2, 6]);
            }

            // forehead
            translate([-10,h-4.5,0])
                rotate([0,0,10])
                square([10,3]);


        }

        // scallop back
        translate([-w/2-6, 20, 0]) scale([0.8,1.5,1]) circle(10);
    }

}

module bishop() {
    tw = slotWidth + 2*tol;
    h = 40;
    w = pieceWidth * 0.9;
    union() {
        // bottom tab
        translate([-tw/2, -3-tol]) square([tw, 4 + tol]);

        // base
        translate([-pieceWidth/2, 0, 0]) roundedSquare([pieceWidth, 4],1, $fn=12);

        // triangle
        hull() {
            translate([-w/2, 0, 2]) square([w, 2]);

            translate([-4/2, h-16, 0]) square([4,1]);
        }

        // cross bar
        translate([-15/2, h-18, 0]) square([15, 3]);

        // hat
        difference() {
            translate([0,h-10,0])
                scale([0.5,1,1])
                circle(10);

            // slot
            translate([1,h-10,0])
                rotate([0,0,60])
                square([10,1]);
        }

        // bobble
        translate([0,h+0.5,0])
            circle(2);
    }
}

module queen() {
    tw = slotWidth + 2*tol;
    h = 45;
    w = pieceWidth * 0.9;
    union() {
        // bottom tab
        translate([-tw/2, -3-tol]) square([tw, 4 + tol]);

        // base
        translate([-pieceWidth/2, 0, 0]) roundedSquare([pieceWidth, 4],1, $fn=12);

        // triangle
        hull() {
            translate([-w/2, 0, 2]) square([w, 2]);

            translate([-6/2, h-6, 0]) square([6,1]);
        }

        // cross bar
        translate([-15/2, h-16, 0]) square([15, 3]);

        // head
        hull() {
            translate([-8/2, h-16, 0]) square([8, 1]);

            translate([-14/2, h-6, 0]) square([14, 1]);
        }


        // crown
        for (i=[-2:2])
            translate([i*2.5, h-6, 0])
            rotate([0,0,-i*10])
            polygon([[-2,0], [0,8 - 2*abs(i)], [2,0]]);

        // bobble
        *translate([0,h+2,0])
            circle(2);

    }
}

module king() {
    tw = slotWidth + 2*tol;
    h = 50;
    w = pieceWidth * 0.9;
    union() {
        // bottom tab
        translate([-tw/2, -3-tol]) square([tw, 4 + tol]);

        // base
        translate([-pieceWidth/2, 0, 0]) roundedSquare([pieceWidth, 4],1, $fn=12);

        // triangle
        hull() {
            translate([-w/2, 0, 2]) square([w, 2]);

            translate([-6/2, h-16, 0]) square([6,1]);
        }

        // cross bar
        translate([-15/2, h-20, 0]) square([15, 3]);

        // head
        translate([0,-4,0])
            hull() {
                translate([-8/2, h-16, 0]) square([8, 1]);

                translate([-14/2, h-6, 0]) square([14, 1]);
            }


        // crown
        translate([-10/2, h-6, 0]) square([10, 4]);

        translate([-4/2, h-10, 0]) square([4, 10]);

    }
}


module pieceBoard() {
    w = innerWidth;
    ow = outerWidth;

    difference() {
        translate([-tol, -tol, 0])
            roundedSquare([ow + 2*tol, ow/2 + 2*tol], 5);

        // pawns
        translate([18,10,0])
            for (x=[0:7])
            translate([x*cellWidth, x % 2 * 30, 0])
            rotate([0,0,x % 2 * 180])
            pawn();

        // rooks
        translate([18,52,0])
            for (x=[0:1])
            translate([x*cellWidth, x % 2 * 32, 0])
            rotate([0,0,x % 2 * 180])
            rook();

        // knights
        translate([18,52,0])
            for (x=[2:3])
            translate([x*cellWidth, x % 2 * 35, 0])
            rotate([0,0,x % 2 * 180])
            knight();

        // bishops
        translate([18,52,0])
            for (x=[4:5])
            translate([x*cellWidth, x % 2 * 40, 0])
            rotate([0,0,x % 2 * 180])
            bishop();

        // queen
        translate([18,52,0])
            for (x=[6])
            translate([x*cellWidth, x % 2 * 40, 0])
            rotate([0,0,x % 2 * 180])
            queen();

        // king
        translate([18,57,0])
            for (x=[7])
            translate([x*cellWidth, x % 2 * 40, 0])
            rotate([0,0,x % 2 * 180])
            king();

    }
}



module layout() {
    for (i=[0,1])
        translate([i*outerWidth, i*outerWidth, 0])
        rotate([0,0,i*180]) {
        linear_extrude(plyThickness)
            board();

        translate([0,0,plyThickness])
            color([0,0,0,0.1])
            linear_extrude(0.1)
            boardEngraving();

        // squares
        translate([0,0,plyThickness+0.1])
            color([0,0,0,0.5])
            linear_extrude(0.1)
            for (x=[0:7],y=[0:3])
            if ((x+y) % 2 == 0)
            translate([x*cellWidth + border, y*cellWidth + border])
            square([cellWidth,cellWidth]);

        // pieces
        color([0.3 + 0.5*i, 0.3 + 0.5*i, 0.3 + 0.5*i]) {

            // pawns
            for (x=[0:7])
                translate([x*cellWidth + border + cellWidth/2, 1*cellWidth + border  + cellWidth/2, plyThickness])
                rotate([90,0,0])
                translate([0,0,-plyThickness/2])
                linear_extrude(plyThickness)
                pawn();

            // rooks
            for (x=[0,7])
                translate([x*cellWidth + border + cellWidth/2, border  + cellWidth/2, 3.1])
                rotate([90,0,0])
                translate([0,0,-plyThickness/2])
                linear_extrude(plyThickness)
                rook();

            // knights
            for (x=[1,6])
                translate([x*cellWidth + border + cellWidth/2, border  + cellWidth/2, 3.1])
                rotate([0,0,x > 1 ? 180 : 0])
                rotate([90,0,0])
                translate([0,0,-plyThickness/2])
                linear_extrude(plyThickness)
                knight();

            // bishops
            for (x=[2,5])
                translate([x*cellWidth + border + cellWidth/2, border  + cellWidth/2, 3.1])
                rotate([90,0,0])
                translate([0,0,-plyThickness/2])
                linear_extrude(plyThickness)
                bishop();

            // queen
            translate([3*cellWidth + border + cellWidth/2, border  + cellWidth/2, 3.1])
                rotate([90,0,0])
                translate([0,0,-plyThickness/2])
                linear_extrude(plyThickness)
                queen();

            // king
            translate([4*cellWidth + border + cellWidth/2, border  + cellWidth/2, 3.1])
                rotate([90,0,0])
                translate([0,0,-plyThickness/2])
                linear_extrude(plyThickness)
                king();

        }

        translate([0, -outerWidth/2 - 20 ])
            linear_extrude(plyThickness)
            pieceBoard();
    }
}

// this is the visual layout of the complete chess board
layout();

// piece shapes - for use during development
translate([0,-50,0]) {
    *pawn();
    *rook();
    *knight();
    *bishop();
    *queen();
    *king();
}


// uncomment these lines to generate the DXFs for cutting
*board();
*boardEngraving();
*sprayMask();
*pieceBoard();
