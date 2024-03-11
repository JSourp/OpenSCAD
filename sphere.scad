/*
	Customizable Sphere Module

	This module creates a customizable sphere or dome in OpenSCAD, allowing for easy parameterization.
	The parameters include diameter, height (for dome), whether it should be hollow or not, wall width if hollow,
	smoothness of rounding, and the option to create a full or half-sphere.

	Parameters:
	- diameter: Diameter of the sphere.
	- height: Height of the dome (from flat base to the highest point).
	- isHollow: Boolean parameter to determine if the sphere/dome should be hollow.
	- wallWidth: Thickness of the wall if isHollow is set to true.
	- smoothness: Number of facets used to approximate the sphere's surface. Higher values result in smoother surfaces.
	- isFull: Boolean parameter to determine if a full sphere should be created.

	Example Usage:
	// Uncomment and modify the parameters as needed for your specific case.
	// customSphere();  // Uses default values
	// customSphere(diameter = 30, isFull = true);  // Overrides specific parameters
	// translate([10, 5, 0]) customSphere(diameter = 30, height = 15, isFull = true); // Example with translation
*/

// Function to create a customizable half-sphere
module customSphere(diameter = 20, height = 10, isHollow = true, wallWidth = 2, smoothness = 50, isFull = false) {
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
