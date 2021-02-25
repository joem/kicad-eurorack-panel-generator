KiCad Eurorack Panel Generator
------------------------------

**NOTE: This is currently a work in progress. Not finished yet. Sorry.**

This program generates a eurorack front panel for a given KiCad pcb file.

It can also do other related tasks such as generate blank panels and tell you some info about KiCad pcb files.

I'm building it in parts, and right now its main use (auto generation of front panels for a pcb) doesn't work yet. That said, some of the parts I've built already might be useful, so I'll list what the files are:


## `KicadPcb` (`lib/kicad_pcb`)

This library handles all the PCB parsing and generating. It does more than the KiCad Eurorack Panel Generator needs, since once I started making it someone full of features, I just kept going.

There are a lot of aspects to it...


### `KicadPcb` (`lib/kicad_pcb.rb`)

This is the main file of the library.


### KicadPcb::Header (`kicad_pcb/header.rb`)

The Header is the first part of a pcb file. It's a fairly simple part. The header has two parameters: `version` and `host_version`. If you have a custom `version` and `host_version` you can pass it to the contructor in a has. Otherwise, you can instantiate a Header object without the hash, and then later call `#set_defaults` to set the default `version` and `host_version`.

Like all the objects representing part of a pcb file, Header objects have a `#to_sexpr` method that outputs the appropriate s-expression for the pcb file.


### General

This is the next part of a pcb file. **TO BE FINISHED**


### KicadPcb::Page (`kicad_pcb/page.rb`)

The next part of a PCB file is the Page. This is the simplest of all the parts, as it only has one parameter, the page size. This parameter must be passed to the constructor as an argument. If no argument is passed, the default (A4) will be used.

Like all the objects representing part of a pcb file, Page objects have a `#to_sexpr` method that outputs the appropriate s-expression for the pcb file.


### KicadPcb::Layers (`kicad_pcb/layers.rb`)

The next part of a PCB file is the Layers section. This section is a list of at least one Layer. As such, the Layers object is a container that can hold one or more Layer objects. You can add a layer by calling the `#set_layer` method and passing a hash of the options for the Layer object. You can also call `#set_default_layers` in order to add all the default layers for a 2-sided PCB.

Like all the objects representing part of a pcb file, Layers objects have a `#to_sexpr` method that outputs the appropriate s-expression for the pcb file.


### KicadPcb::Layer (`kicad_pcb/layer.rb`)

### KicadPcb::Setup (`kicad_pcb/setup.rb`)

### KicadPcb::GraphicItems (`kicad_pcb/graphic_items.rb`)

### KicadPcb::GraphicItem (`kicad_pcb/graphic_item.rb`)

### KicadPcb:: (`kicad_pcb/graphic_item/`)

### KicadPcb::NetClasses (`kicad_pcb/net_classes.rb`)

### KicadPcb::NetClass (`kicad_pcb/net_class.rb`)

### KicadPcb::Nets (`kicad_pcb/nets.rb`)

### KicadPcb::Net (`kicad_pcb/net.rb`)

### KicadPcb::Parts (`kicad_pcb/parts.rb`)

### KicadPcb::Part (`kicad_pcb/part.rb`)

### KicadPcb::Tracks (`kicad_pcb/tracks.rb`)

### KicadPcb::Track (`kicad_pcb/track.rb`)

### KicadPcb:: (`kicad_pcb/track/`)

### KicadPcb::Zones (`kicad_pcb/zones.rb`)

### KicadPcb::Zone (`kicad_pcb/zone.rb`)



That concludes all the parts of a PCB file. The remaining classes are a bit different:


### KicadPcb::Param (`kicad_pcb/param.rb`)

This is a convenience class designed to be used for instance variables, so that in `#to_sexpr` you can just use string interpolation and it'll get formatted/rendered correctly, since string interpolation calls `#to_s` on the objects.

Calling `#render_value` on a Param object will simply call the Param's `#to_s` method, which will `#render_value` it's param. (I'm pretty sure I'm doing it correctly so it's all safe!)

Additionally, when in a KicadPcb class that's `require`'d this class, you can quickly create a new Param like so:

      @some_variable = Param["some value"]

Most of the KicadPcb classes instantiate values into Param objects upon object creation.

The Param class also has two useful class methods:

`Param#current_timestamp` returns a timestamp of the current date/time in the format used by pcb files, as a Param object.

`Param#timestamp(time_or_datetime)`. returns a timestamp of provided date/time in the format used by pcb files, as a Param object.


### Render (`kicad_pcb/render.rb`)

The Render module is `include`'d into most of the KicadPcb classes in order to provide the `#render_array`, `#render_hash`, and `#render_value` methods.


### KicadPcb::Parser (`kicad_pcb/parser.rb`)

### KicadPcb::Pcb (`kicad_pcb/pcb.rb`)

### KicadPcb:: (`kicad_pcb/writer.rb`)

### KicadPcb:: (`kicad_pcb/version.rb`)

This merely holds the KicadPcb::VERSION constant.










## Requirements

So far, this uses no external libraries, so it just need Ruby.

This was developed on a computer that had Ruby 2.4.1p111, so it should run on that version or any newer version (of which there are many). It will probably also run on older Ruby versions too, but if you go older than 2.0 you're asking for trouble.

I'll hopefully test it on more versions just to make sure.


## How To Use

1. Clone the repo or download and unzip the repo.
2. From the command line, run `ruby <name of file> -- help` to see the options. Available programs:
    - `ruby generate_panel.rb --help`
    - `ruby generate_panel_from_pcb.rb --help`
    - `ruby generate_pcb.rb --help`
    - `ruby kicad_eurorack_panel_generator.rb --help`
    - `ruby show_pcb_info.rb --help`
3. Run the desired program as above, but without the `--help` option and with the appropriate options for what you want to accomplish.


## References

Primary reference for eurorack 3U panel sizes:
http://www.doepfer.de/a100_man/a100m_e.htm

Reference for eurorack 3U pcb sizes and additional reference for eurorack 3U sizes:
https://sdiy.info/wiki/Eurorack_DIY_parts

Reference for Intellijel 1U pcb/panel sizes:
https://intellijel.com/support/1u-technical-specifications/

Reference for Pulp Logic 1U pcb/panel sizes:
http://pulplogic.com/1u_tiles/

Reference for KiCad file format: https://kicad.org/help/file-formats/ -- specifically the link to the [legacy PDF documentation](https://kicad.org/help/legacy_file_format_documentation.pdf) (but the documentation isn't great, so I mostly just made test pcb files in kicad and then made sense of the output)







---------------------------

---------------------------

---------------------------

# The below is old, and most of it is gone or changed:


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

Formats (default: `3U`)

- `3u` or `3U`   = standard eurorack 3U
- `1ui` or `1UI` = Intellijel 1U
- `1up` or `1UP` = Pulp Logic 1U

Mounting hole sizes (default: `M3`):

- `m3` or `M3` = standard M3 holes

Mounting hole position options (default: `auto`):

- `left`  = mounting holes only on left
- `right` = mounting holes only on right
- `both`  = both right and left mounting holes
- `auto`  = panels 9hp and skinnier only get mounting holes on left, panels 10hp and wider get left and right mounting holes 
- `none`  = no mounting holes

        Usage: generate_panel.rb [options]
        Options:
            -w, --width HP                   The width of panel in HP
            -f, --format FORMAT              The format (default: 3U)
            -p, --position POSITION          Mounting hole postion (default: auto)
            -a, --auto-extension             Add .kicad_pcb to output filename
            -o, --output OUTPUTFILE          The file to output
                                             (If not specified, output to stdout)
            -h, --help                       Show this message


## `generate_panel_from_pcb.rb`

This will generates a eurorack panel sized correctly to fit the specified PCB. Right now it's just a placeholder.


## `lib/eurorack.rb`

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

