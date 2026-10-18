# choc-tilter-riser-parametric

A little adapter that snaps onto a Kailh Choc v1 (PG1350) switch and gives you a new
pair of choc legs on top, raised, tilted, rotated or shifted however you like. Handy
for thumb clusters, for sculpting a flat board a bit, or just for getting a keycap to
sit where your finger actually lands.

It's one OpenSCAD file. Everything is driven from the Customizer sidebar, so you
shouldn't need to touch the code unless you want to.

## Sample STLs

There are a few ready-made files in `STLs/` if you just want to print something and
see how it feels:

| File | What it is |
|---|---|
| `rise2-tx20-ty10.stl` | 2 mm rise, tilted 20° toward you, 10° to the side. Two pieces. |
| `rise2-tx-20-ty10.stl` | Same, but tilted 20° away from you. Two pieces. |
| `ty10-x8.stl` | No rise, 10° side tilt, eight pieces in a column. |

The filenames are a shorthand for the settings: `rise` is the riser height in mm, `tx`
and `ty` are the tilt angles, and `x8` means eight copies.

## Tilts and rises

This is the part you'll actually spend time in. Everything lives under **Reposition**
in the sidebar.

**riser** is the extra height between the base block and the top slab, in mm. Zero
gives you the thinnest possible adapter, which is still a few mm tall because the
socket and roof take up room. The samples use 0 and 2.

**tilt_x** tilts the keycap forward or back. Positive values tip the keycap toward
-Y, which is toward you if the board sits the normal way round. The two `rise2` samples
are +20 and -20, so you can print both and decide which direction you meant.

**tilt_y** tilts left or right. Positive tips the keycap toward +X. The samples all use
10°, which is a fairly gentle lean. Both tilts go up to 45° but things start to look
pretty wild past 25 or so.

**rotate_z** spins the keycap about vertical. Useful if you want a key angled a bit
toward the thumb without actually moving the switch.

**offset_x** and **offset_y** slide the keycap sideways or forward/back by up to 5 mm.
Combine with a tilt and the adapter turns into a lopsided wedge, which is fine, the
hull between the base and slab fills in whatever shape is needed.

A few things worth knowing:

- Tilt and rise stack up. A big tilt on a tall riser can push a keycap into its
  neighbours, so check clearances before printing a whole set.
- The base block never changes size. Only the slab on top moves, so the adapter
  always lands on the switch the same way.
- If you're tilting a lot, bump **gap** under Batch so neighbouring pieces don't
  overlap on the build plate.

## Tuning the fit

Stem sizes are nominal. Choc stems vary a bit between batches, keycaps vary more, and
printers vary most of all. Print one, see how it feels, then adjust.

**socket_clear** is added to each side of the sockets on the underside, the bit that
grabs the switch. Bigger is looser. The default is 0.26 mm, which is on the generous
side for a typical FDM printer. If the adapter won't go onto the switch, go up a
couple of hundredths. If it falls off, go down.

**peg_shrink** is removed from each side of the new legs on top, the bit the keycap
grabs. Bigger is looser, and negative values make the pegs fatter. It defaults to
-0.04, so the pegs are very slightly oversize out of the box. Keycaps that feel loose
want a more negative number. Keycaps that won't seat want a positive one.

**socket_depth** is how far the switch stem goes into the adapter. 2.6 mm is a good
match for the stem on a Choc v1, and you probably don't need to change it.

If none of that gets you there, measure your switch stems with calipers and set
**stem_w**, **stem_d** and **stem_pitch** under the stem section to what you actually
have. **peg_h** is the height of the new legs; the stock 3 mm matches a real choc stem.

Work in small steps. 0.02 mm per side is a noticeable change in how a snap fit feels.

## Everything else

**Body** controls the block itself. `body_w` and `body_d` are the footprint of both
the base and the slab, and `corner_r` rounds the vertical edges. `roof` is how much
material sits above the sockets and `slab_t` is how thick the top plate is. 0.6 and 0.8
have been fine for me but if you're printing on something that struggles with thin
walls you can thicken them up.

**Batch** lets you make more than one at a time. `count` is how many, `columns` is how
many per row, and `gap` is the space between them. The eight-pack sample was made with
`columns` set to 1 so they come out in a single line.

**Runner** joins all the pieces with a thin strip so you can pick up a whole batch at
once and snap them apart later. It's off by default. `runner_w` and `runner_h` set the
size of the strip and `runner_overlap` is how far it pokes into each piece. The runners
only ever span the gaps between pieces, so they can't cover up the sockets underneath.

## OpenSCAD tips

**The sidebar is empty.** OpenSCAD doesn't fill in the Customizer until it has
compiled the file once, so a freshly opened file shows a blank panel. Press F5 and it
populates. If there's no panel at all, turn it on under Window > Customizer (older
versions call it Window > Hide Customizer and some older builds have it under
Preferences > Features).

**Make it preview on open.** Turn on Design > Automatic Reload and Preview. It
remembers the setting, so from then on OpenSCAD compiles the file as soon as it opens
and the Customizer is ready to go. It'll also reload if you edit the file in another
editor, which is nice.

**Exporting.** F6 to render, then File > Export > Export as STL. Set `count` to how
many you want before you render and they'll all come out in one file.

## License

GPLv3. See `LICENSE`.
