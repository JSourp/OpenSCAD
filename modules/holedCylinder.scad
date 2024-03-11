/**
 * OpenSCAD Parametric Holed Cylinder
 * 
 * This OpenSCAD design provides modules for creating a parametric holed cylinder
 * with customizable main body and holes.
 */

// Facet Number
$fn = 100;

// Parameters
height = 50;
edgeDepth = 4;
base = 20;
holeDiameter = 4;
wallThickness = 1;
spacing = 5;

// Adjustments
edgeSpacer = ((base / 2) + edgeDepth);
numLayers = ceil(height / 6);
numHoles = ceil(base / 2);

// Main Body Module
module mainBody(height, base, wallThickness) {
    difference() {
        cylinder(d = base, h = height); // Outer cylinder
        translate([0, 0, -1]) // Shift for wall thickness
            cylinder(d = base - 2 * wallThickness, h = height + 2); // Inner cylinder for wall thickness
    }
}

// Holes Module
module holes(height, holeDiameter, numHoles, numLayers, spacing) {
    for (j = [1:numLayers-1]) {
        for (i = [0:numHoles - 1]) {
            angle = i * (360 / numHoles);
            z = j * (height / numLayers);
            translate([(10 - 0.5 * spacing) * cos(angle), (10 - 0.5 * spacing) * sin(angle), z])
                rotate([90, 0, angle + 90])
                    cylinder(d = holeDiameter, h = height / numLayers + 2);
        }
    }
}

// Body Main Module
module bodyMain() {
    difference() {
        mainBody(height, base, wallThickness);
        holes(height, holeDiameter, numHoles, numLayers, spacing);
    }
}

// Render the main body with holes
bodyMain();