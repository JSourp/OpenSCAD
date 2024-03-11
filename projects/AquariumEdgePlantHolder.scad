/** Aquarium Edge Plant Holder **/

// Facet Number
$fn = 100;

// Parameters
height = 100;
edgeDepth = 4;
base = 20;
holeDiameter = 4;
wallThickness = 1;
edgeHeight = 20;
edgeThickness = 3;
spacing = 5;

// Adjustments
edgeSpacer = ((base / 2) + edgeDepth);
numLayers = ceil(height / 6);
numHoles = ceil(base / 2);

// Object Definitions

// Custom Sphere Module
module customSphere(diameter = base, height = 10, isHollow = true, wallWidth = wallThickness, smoothness = $fn, isFull = false) {
    // Calculate the radius of the sphere
    radius = diameter / 2;

    // Create the sphere or dome based on the 'isFull' parameter
    if (isFull) {
        // Create a full sphere
        if (isHollow) {
            difference() {
                sphere(r = radius, $fn = smoothness);
                translate([0, 0, wallWidth])
                    sphere(r = radius - wallWidth, $fn = smoothness);
            }
        } else {
            // Solid sphere
            sphere(r = radius, $fn = smoothness);
        }
    } else {
        translate([0, 0, (radius - height)])
        difference() {
            sphere(radius);
            translate([0, 0, -height])
            cube([2*radius, 2*radius, 2*radius], center=true);
            if (isHollow)
                translate([0, 0, wallWidth])
                    sphere(radius - wallWidth);
        }
    }
}

// Main Body Module
module mainBody(height, base, wallThickness) {
    difference() {
        cylinder(d = base, h = height); // Outer cylinder
        translate([0, 0, -1]) // Shift for wall thickness
            cylinder(d = base - 2 * wallThickness, h = height + 2); // Inner cylinder for wall thickness
    }
}

// Strainer Holes Module
module strainerHoles(height, holeDiameter, numHoles, numLayers, spacing) {
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

// Ledge Hanger Module
module ledgeHanger() {
    translate([edgeSpacer, -base / 2, 0]) cube([edgeThickness, base, edgeHeight], center = false);
}

// Rim Spacer Module
module rimSpacer() {
    difference() {
        translate([0, -base / 2, 0]) cube([edgeSpacer, base, edgeThickness], center = false);
        translate([0, 0, -1]) // Shift for wall thickness
            cylinder(d = base - 2 * wallThickness, h = edgeThickness + 2); // Inner cylinder for wall thickness
    }
}

// Body Main Module
module bodyMain() {
    difference() {
        mainBody(height, base, wallThickness);
        strainerHoles(height, holeDiameter, numHoles, numLayers, spacing);
    }
}

// Body Bottom Module
module bodyBottom() {
    translate([0, 0, height-.1]) difference() {
        customSphere();
        cylinder(d=holeDiameter*3, h = 12);
    }
}

// Combine Modules
ledgeHanger();
rimSpacer();
bodyMain();
bodyBottom();
