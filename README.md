# Fire Emblem Fates - Dual Dub
Assembly patches using Magikoopa to introduce a dual dub option for Fire Emblem Fates. You'll have to bring your own files though!

## Required files
* A japanese IRON15_Sound.bcsar (located in /sound)
* A japanese IndirectSound.bin.lz (located in /sound)
* The code.ips for your region

## Installation instructions
#### Make sure to use the latest version of [Luma3DS](https://github.com/AuroraWright/Luma3DS) and toggle the [[Enable game patching](https://github.com/AuroraWright/Luma3DS/wiki/Optional-features)] option to use this.
- Download the Release appropriate for your region.
- Extract to the root of your SD card.
- Go to /luma/titles/<Title ID for your game and region>/romfs/sound/ and add both your japanese IRON15_Sound.bcsar and IndirectSound.bin.lz files.
- Respectively rename them to IRON15_sound_JP.bcsar and IndirectSoundJP.bin.lz
- ???
- Profit!

## License
You're free to use this as long as you respect the GPL-2.0 license.
However, I would like you to keep the "Togameme" easter egg in SoundFactoryJP.cpp (You can move it to another file but I want it to appear in the binary). That's just a silly request from me so if you really can't it's fine but I want it to live on.

### Credits and special thanks
Raytwo: Initial reverse engineering static analysis, initial discovery, programming, testing  
DeathChaos: Proof of concept, video recording, testing, general assistance and support (many "rip" have been said)  
TildeHat: Proof of concept, providing some offsets, providing files  
Collector Togami: Catgirl worshipping, providing a copy of the Ultimate Aipom Rulebook
