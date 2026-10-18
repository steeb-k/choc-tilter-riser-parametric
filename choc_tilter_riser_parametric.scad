// Choc v1 keycap reposition adapter (riser / tilter / offsetter)
// Snaps onto a Kailh Choc v1 (PG1350) switch stem and presents a new
// pair of choc legs on top, raised, tilted, rotated and/or offset.
//
// Stem dimensions below are nominal: measure your switches and keycaps
// with calipers and tweak the Fit values after a test print.

/* [Choc v1 stem (nominal, measure yours)] */
stem_w     = 1.2;   // X width of each leg
stem_d     = 3.0;   // Y depth of each leg
stem_pitch = 5.7;   // X center-to-center spacing of the two legs
peg_h      = 3.0;   // height of the new legs on top

/* [Fit] */
// added per side to the bottom sockets (bigger = looser)
socket_clear = 0.26; // [0:0.01:0.5]
// removed per side from the top pegs (bigger = looser, negative = fatter pegs)
peg_shrink   = -0.04; // [-0.15:0.01:0.2]
socket_depth = 2.6;  // how far the switch stem goes into the adapter

/* [Reposition] */
// extra height (mm) between base block and top slab
riser    = 2.0;  // [0:0.1:10]
// tilt forward/back in degrees (+ tilts the keycap toward -Y)
tilt_x   = 0;    // [-45:1:45]
// tilt left/right in degrees (+ tilts the keycap toward +X)
tilt_y   = 0;    // [-45:1:45]
// spin the keycap about vertical, in degrees
rotate_z = 0;    // [-180:1:180]
// shift keycap left/right (mm)
offset_x = 0;    // [-5:0.1:5]
// shift keycap forward/back (mm)
offset_y = 0;    // [-5:0.1:5]

/* [Body] */
body_w     = 9;    // X size of base block and top slab
body_d     = 8.75; // Y size of base block and top slab
// radius of the four outer vertical corners (mm)
corner_r   = 1.5;  // [0:0.1:4]
roof       = 0.6;  // material above the sockets in the base block
slab_t     = 0.8;  // thickness of the top slab under the new pegs

/* [Batch] */
// how many adapters to generate
count   = 1;   // [1:1:50]
// adapters per row
columns = 5;   // [1:1:20]
// space between neighboring adapters (mm); raise this for big tilts/offsets
gap     = 3;   // [0.5:0.5:20]

/* [Runner] */
// connect all pieces with a thin strip
runner   = false;
// width of the runner strip (mm)
runner_w = 1.0;  // [0.4:0.1:3]
// height of the runner strip (mm), printed flat on the bed
runner_h = 0.6;  // [0.2:0.1:2]
// how far the runner reaches into each piece (mm)
runner_overlap = 0.5; // [0.1:0.1:2]

/* [Hidden] */
$fn = 32;
eps = 0.01;
base_h = socket_depth + roof;
// keep the radius from exceeding half the smaller side
r_eff = max(0, min(corner_r, min(body_w, body_d) / 2 - eps));
pitch_x = body_w + gap;
pitch_y = body_d + gap;
cols = min(columns, count);
rows = ceil(count / cols);

// Rounded-corner box, centered in XY, sitting on z=0
module rounded_box(w, d, h) {
    linear_extrude(height = h)
        offset(r = r_eff)
            square([w - 2 * r_eff, d - 2 * r_eff], center = true);
}

// Two choc legs, centered on origin in XY, sitting on z=0
module legs(w, d, h) {
    for (s = [-1, 1])
        translate([s * stem_pitch / 2, 0, h / 2])
            cube([w, d, h], center = true);
}

// Transform for everything on top of the riser
module place_top() {
    translate([offset_x, offset_y, base_h + riser])
        rotate([tilt_x, tilt_y, 0])
            rotate([0, 0, rotate_z])
                children();
}

module base_block() {
    rounded_box(body_w, body_d, base_h);
}

module top_slab() {
    place_top()
        rounded_box(body_w, body_d, slab_t);
}

module adapter() {
    difference() {
        hull() {
            base_block();
            top_slab();
        }
        // sockets for the switch stem
        translate([0, 0, -eps])
            legs(stem_w + 2 * socket_clear,
                 stem_d + 2 * socket_clear,
                 socket_depth + eps);
    }
    // new legs for the keycap
    place_top()
        translate([0, 0, slab_t - eps])
            legs(stem_w - 2 * peg_shrink,
                 stem_d - 2 * peg_shrink,
                 peg_h + eps);
}

// XY position of adapter i in the grid
function pos(i) = [(i % cols) * pitch_x, -floor(i / cols) * pitch_y, 0];

// Runner segments only span the gaps between pieces, so they never
// cover the stem sockets on the underside.
module runners() {
    // along each row, between horizontal neighbors
    len_x = gap + 2 * runner_overlap;
    for (i = [0 : count - 1])
        if ((i % cols) < cols - 1 && i + 1 < count)
            translate(pos(i) + [body_w / 2 + gap / 2, 0, runner_h / 2])
                cube([len_x, runner_w, runner_h], center = true);

    // spine down the first column, joining the rows
    len_y = gap + 2 * runner_overlap;
    for (r = [0 : rows - 2])
        translate(pos(r * cols) + [0, -(body_d / 2 + gap / 2), runner_h / 2])
            cube([runner_w, len_y, runner_h], center = true);
}

for (i = [0 : count - 1])
    translate(pos(i)) adapter();

if (runner && count > 1)
    runners();
