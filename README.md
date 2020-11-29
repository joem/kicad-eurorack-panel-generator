KiCad Eurorack Panel Generator
------------------------------

**NOTE: This is currently a work in progress. Not finished yet. Sorry.**

This program generates a eurorack front panel for a given KiCad pcb file.

It can also do other related tasks such as generate blank panels and tell you some info about KiCad pcb files.

I'm building it in parts, and right now its main use (auto generation of front panels for a pcb) doesn't work yet. That said, some of the parts I've built already might be useful, so I'll list what the files are:


## `kicad_eurorack_panel_generator.rb`

This will be the main program. Right now it's just a placeholder file.


## `generate_pcb.rb`

This generates a PCB of the specified size. If no size is specified, it makes it 100mm x 100mm, since that's a useful size to have for cheap prototyping.

        Usage: generate_pcb.rb [options]
        Options:
            -x, --x-size XSIZE               The x-size of pcb (in mm)
            -y, --y-size YSIZE               The y-size of pcb (in mm)
            -a, --auto-extension             Add .kicad_pcb to output filename
            -o, --output OUTPUTFILE          The file to output
                                             (If not specified, output to stdout)
            -h, --help                       Show this message


## `generate_panel.rb`

This generates a eurorack panel sized correctly for the specified HP and optional formal (3U / Intellijel 1U / Pulp Logic 1U -- default is 3U).  The panel includes mounting holes.

NOTE: Mounting holes currently are not implemented!

Possible formats:

- 3u or 3U   = standard eurorack 3U
- 1ui or 1UI = Intellijel 1U
- 1up or 1UP = Pulp Logic 1U

Possible hole sizes:

- m3 or M3   = standard M3 holes

        Usage: generate_panel.rb [options]
        Options:
            -w, --width HP                   The width of panel in HP
            -f, --format FORMAT              The format (default is 3U)
                                             (See docs for posible formats)
            -h, --holes HOLESIZE             The mounting hole size (default is M3)
                                             (See docs for posible formats)
            -a, --auto-extension             Add .kicad_pcb to output filename
            -o, --output OUTPUTFILE          The file to output
                                             (If not specified, output to stdout)
                --help                       Show this message


## `generate_panel_from_pcb.rb`

This will generates a eurorack panel sized correctly to fit the specified PCB. Right now it's just a placeholder.


## lib/eurorack.rb

This module contains all eurorack-specific constants/classes/methods/info I'm using.

Some of the useful methods that are currently working great:

- `minimum_hp` -- Calculates the minimum HP that the given width in mm will fit behind.
- `panel_hp_to_mm` -- Converts from HP to mm, reduced by a small amount for tolerance.


## `lib/kicad_pcb.rb`

This module contains all kicad-specific constants/classes/methods/info I'm using.

Right now it just contains one class, Pcb, which is a fairly naive representation of a KiCad PCB, but it seems to work for my purposes so far.


## `lib/parsed_part.rb`

This module has constants and methods that help with identifying and handling the footprints on the kicad pcb. It has a ways to go before it's useful.

This module should be merged with the KicadPcb module eventually.


## `lib/sexpr_parser.rb`

This is a simple s-expression parser that helps with reading KiCad's pcb files.


