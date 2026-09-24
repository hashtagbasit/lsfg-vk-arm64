# lsfg-vk for ARM64

Lossless Scaling frame generation on ARM Linux handhelds. This is [lsfg-vk](https://github.com/PancakeTAS/lsfg-vk) built for aarch64, with a couple of fixes so it actually works with Proton ARM64 games.

The [decky-lsfg-vk](https://github.com/xXJSONDeruloXx/decky-lsfg-vk) plugin only comes with an x86 build of the layer, so on ARM it just silently does nothing. And if you build it yourself, Proton ARM64 games get stuck on "launching" forever. This fixes both.

Tested on SteamOS ARM on a KONKR Pocket FIT (Snapdragon 8 Gen 3) with Dying Light, but it should work on any aarch64 Linux with Vulkan.

This is a pretty big deal for ARM handhelds. These chips can run a lot of PC games now, but usually somewhere around 30-45fps. With frame gen on top that becomes 60-90fps on screen, which makes a huge difference to how smooth games feel on a small handheld, and until now it just didn't work on ARM Linux at all.

## What's fixed

- Built for aarch64, matching the lsfg-vk version the Decky plugin uses (`fp16-test-2`), so it reads the same config.
- The layer kept one global pointer to the next Vulkan layer. Wine creates a few Vulkan instances and devices from different places, the pointers got mixed up, MangoHud crashed inside Wine's explorer.exe and the game never started. It now tracks them per instance and device.
- It doesn't load into Wine's own helper processes anymore, only the game.
- Devices without a swapchain (compute stuff) just pass through instead of failing.

## Install

You need the decky-lsfg-vk plugin set up as normal (Lossless.dll, the `~/lsfg %command%` launch option, etc). Then grab `liblsfg-vk-arm64.so` from [Releases](../../releases), put it next to `install.sh` and run:

```
./install.sh
```

or system-wide (needs a writable /usr, on SteamOS run `sudo steamos-readonly disable` first):

```
sudo ./install.sh --system
```

It installs next to the plugin's x86 layer under its own name, so the two don't clash. It only turns on for games launched through `~/lsfg`, same as the plugin. `./uninstall.sh` removes it.

## Building it yourself

On an aarch64 machine with git, cmake, ninja, clang and the Vulkan headers:

```
./build.sh
```

It clones the lsfg-vk fork the plugin uses, applies the patches in `patches/` and builds `liblsfg-vk-arm64.so`.

## Credits

All the actual frame generation work is [PancakeTAS/lsfg-vk](https://github.com/PancakeTAS/lsfg-vk), and the Decky plugin and fork are by [xXJSONDeruloXx](https://github.com/xXJSONDeruloXx). You still need your own copy of Lossless Scaling from Steam.

Made while getting [SteamOS running on the Pocket FIT](https://github.com/hashtagbasit/SteamOS-ARM-SM8650).

## Supporting the project

If this got frame gen working on your handheld and you want to say thanks, a coffee really helps.

<p align="left">
  <a href="https://ko-fi.com/aimalb"><img src="https://img.shields.io/badge/Ko--fi-Buy%20me%20a%20coffee-ff5e5b?style=for-the-badge&logo=kofi&logoColor=white" alt="Ko-fi"></a>
  <a href="https://paypal.me/Basit2000"><img src="https://img.shields.io/badge/PayPal-Basit2000-00457c?style=for-the-badge&logo=paypal&logoColor=white" alt="PayPal"></a>
</p>

## License

MIT, same as lsfg-vk.
