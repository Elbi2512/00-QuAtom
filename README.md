# 00-QuAtom

Minimal bare-metal Raspberry Pi Zero 2 W build scaffolding that produces a
`kernel8.img` image for 64-bit boot.

## Build

The default build uses `clang` with the LLD linker and `llvm-objcopy`.

```sh
make
```

This produces:

- `kernel8.img` - raw image to copy to the FAT boot partition
- `build/kernel8.elf` - ELF output for debugging
- `build/kernel8.map` - link map

## Raspberry Pi Zero 2 W boot files

The Pi Zero 2 W boots the 64-bit kernel image as `kernel8.img`. A matching
sample boot configuration is provided in `boot/config.txt`.

Copy `kernel8.img` and `boot/config.txt` to the boot partition of the SD card.
The boot partition must also contain the standard Raspberry Pi firmware boot
files such as `start*.elf` and `fixup*.dat` (or come from an image that already
includes them).