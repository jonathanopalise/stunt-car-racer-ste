# Lotus STE

_Enhancements to the Atari ST version of Stunt Car Racer to support STE hardware features_

![Screenshot of current progress](https://github.com/jonathanopalise/stunt-car-racer-ste/blob/master/screenshot.png)

## What's this all about?

This is an experimental project at a very early stage, so don't get too excited at this point!

There's been much debate over the years within both the Atari ST and Amiga community over whether the performance of
solid 3D polygon games such as this can be improved by using the respective Blitter chips in the Atari ST and Amiga
range.

With this in mind, I'm using Stunt Car Racer on the ST as a testbed to explore this idea.

So far, I've written some patches to adapt existing CPU-driven routines to use the Blitter instead. Much of the sky
and ground, some longer horizontal spans of polygons and the top half of the car's engine are all drawn using the
Blitter. There doesn't appear to be a tangible increase in performance at this point, but I'm hoping that further
optimisation will yield visible results.

The modified version of the code doesn't exist as a runnable disk image as yet. You need to run the standard
unmodified game in the Hatari emulator, and load in the patches using the integrated debugger. Further instructions
are below. 

## How to build and run

Before attempting to build, you'll need the following executable dependencies to be available in your path:

- `vasm` (http://sun.hasenbraten.de/vasm/)
- `m68k-ataribrownest-elf-nm` (https://bitbucket.org/ggnkua/bigbrownbuild-git/src/master/)
- `php` (https://www.php.net/)

The build process is controlled by a `Makefile`. The `Makefile` is confirmed to work with Linux. It could possibly be repurposed for Windows with some changes - please get in touch if you can help.

Once you have all of the above executables in your path, run `make` to start the build process. Should the build process succeed, there will be a series of files present in the `bin` directory - these contain binary code to be overlaid on top of the existing Stunt Car Racer game code. In the event that the build process fails, please raise an issue against the project and I'll help in any way I can.

In order to apply these patches, you'll need to start the Hatari emulator, configure the machine as an STE with 1 Meg or more of memory, then load and run Stunt Car Racer from the Pompey Pirates #17 disk image (https://www.exxoshost.co.uk/atari/games/pompy/index.htm). Start the debugger (`AltGr + Pause`), then enter the following lines, replacing `<path-to-cloned-repository>` with the directory to which you've cloned the repo:

- `loadbin <path-to-cloned-repository>/bin/0x4caee_jump_to_draw_engine_top.bin 0x4caee`
- `loadbin <path-to-cloned-repository>/bin/0x4f246_jump_to_draw_ground.bin 0x4f246`
- `loadbin <path-to-cloned-repository>/bin/0x4f2a6_jump_to_draw_sky.bin 0x4f2a6`
- `loadbin <path-to-cloned-repository>/bin/0x4feb6_jump_to_update_halftone.bin 0x4feb6`
- `loadbin <path-to-cloned-repository>/bin/0x50018_redirect_jump.bin 0x50018`
- `loadbin <path-to-cloned-repository>/bin/0x5003c_jump_to_road_span_loop_end.bin 0x5003c`
- `loadbin <path-to-cloned-repository>/bin/0x80000.bin 0x80000`

Finally, enter `c` (for "continue") at the debugger prompt, and press the Enter key. The game should continue running, but with the updated code in place of the new code. If you see bombs or screen corruption, it's possible that something has gone wrong - raise an issue against the project and I'll help in any way I can.
