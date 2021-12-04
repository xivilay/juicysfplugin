# Current fork changes:
- Left only CMake build for cross-platform compatibility (Windows/Linux are supported for now)
- Removed binaries from repo, added submodules instead
- Updated JUCE and fluidsynth to latest
- Changed build instructions section

# What

juicysfplugin is a cross-platform audio plugin for playing MIDI music through a soundfont synthesizer.

It's well-suited for making videogame music. If you have a soundfont of your favourite game, you can write your own melodies with its instruments.

[JUCE](https://github.com/WeAreROLI/JUCE) is the framework for making audio plugins.  
[fluidsynth](http://www.fluidsynth.org/) is the soundfont synthesizer.

Supports SF2 and SF3 soundfont formats.

Supports the following MIDI events:

- noteon, noteoff
- 192 program change (this changes soundfont preset)
- pitch wheel
- aftertouch (key pressure)
- channel pressure
- default modulators as described in [SoundFont specification 2.4](http://freepats.zenvoid.org/sf2/sfspec24.pdf)
  - includes (among others): CC 1 modulation wheel is mapped to vibrato LFO pitch depth
- CC 71 Timbre/Harmonic Intensity (filter resonance)
- CC 72 Release time
- CC 73 Attack time
- CC 74 Brightness (cutoff frequency, FILTERFC)
- CC 75 Decay Time
- CC 79 undefined (being used as Sustain time)
- may support SysEx (untested)

**Mode 1: standalone application**

juicysfplugin.app (or .exe on Windows) is a standalone application, for playing around.

You can plugin your hardware MIDI keyboard, or play with the software MIDI keyboard. Or route MIDI messages into it from a virtual MIDI controller (e.g. the [macOS IAC Bus](http://re-compose.desk.com/customer/portal/articles/1382244-setting-up-the-iac-bus-on-a-mac)).  

**Mode 2: audio plugin**

juicysfplugin audio plugins are provided: VST, VST3, AU, AUv3.  
This means you can host it inside your DAW (e.g. GarageBand, FL Studio Mac, Sibelius…) to record the sounds you make.

# Why

I couldn't find a _free_, _easy-to-use_ macOS audio plugin for making music with soundfonts.

# Install (macOS)

**Download Release.tar.xz, open it to unzip.**

Release contains:

```
juicysfplugin.app  # standalone application, for playing around
juicysfplugin.component  # AU plugin
juicysfplugin.vst  # VST plugin
juicysfplugin.vst3  # VST3 plugin
```

To install plugins, move them to the following folder:

```
juicysfplugin.component -> ~/Library/Audio/Plug-Ins/Components/juicysfplugin.component
juicysfplugin.vst -> ~/Library/Audio/Plug-Ins/VST/juicysfplugin.vst
juicysfplugin.vst3 -> ~/Library/Audio/Plug-Ins/VST3/juicysfplugin.vst3
```

## Launch (macOS)

Now, you may do one of the following:

- Open the standalone juicysfplugin.app
- Load the AU/VST/VST3 into your favourite DAW (e.g. GarageBand, FL Studio)

# Usage

You must drag-and-drop a soundfont into the file picker.

![image](https://user-images.githubusercontent.com/6141784/37062424-500bc91e-218e-11e8-9916-eae6d82ca566.png)

Here's some soundfonts to get you started:

- [Fatboy](https://fatboy.site/) (no specific license stated, but described as "free")
- MuseScore's [recommended soundfonts](https://musescore.org/en/handbook/soundfonts-and-sfz-files#list) (includes MIT, GPL, other licenses)
- FlameStudios' GPL-licensed [guitar soundfonts](http://www.flamestudios.org/free/Soundfonts)

I'll refrain from recommending certain General MIDI or videogame soundfonts, since the licensing and provenance are often unclear.

## Keybindings

Gain keyboard focus by clicking the plugin's keyboard.

- Up-down arrow keys to switch preset.
- Left-right to switch bank.

ASCII -> MIDI keybinding is the same as FL Studio's:

<img width="256px" alt="image" src="http://s3.amazonaws.com/fl_resource/flkeychart.png">

## Using the standalone .app (macOS) / .exe (Windows)

Generally the .app will Just Work™, but if your audio setup is more bespoke, then you'll need to configure.

**Options > Audio/MIDI settings**

<img width="256px" alt="image" src="https://user-images.githubusercontent.com/6141784/37062230-bdb128b6-218d-11e8-985a-e9b2b5fd0bb2.png">

**Set Output to Built-In Output**

Or any output device that you can hear audio through.

<img width="502" alt="image" src="https://user-images.githubusercontent.com/6141784/62873427-4cafd500-bd17-11e9-80af-03fbf9742802.png">

# Building from source (CMake)

Before build run `git submodule update --init --recursive` to checkout JUCE and fluidsynth sources. 
## Windows

CMake, Visual Studio with C++ should be installed.

Install `vcpkg` and `pkg-config` to be able to compile fluidsynth. 

Add `glib` and `libsndfile` libraries via `vcpkg`.

Example: `vcpkg install glib:x64-windows libsndfile:x64-windows`.

Define `PKG_CONFIG_EXECUTABLE` and `CMAKE_TOOLCHAIN_FILE` env variables to let cmake find fluidsynth dependencies. 

Run build scripts from `scripts\win\`. First `build-fluidsynth`, then `build`. Optionally `post_build` to copy binaries to `dist` fir.

For `asio` or `vst2` support sdk headers should be placed to `sdk` dir. Read Steinberg license carefully before doing it.

## Linux

Install the following packages if they are not installed:

`sudo apt install clang cmake doxygen g++ gcc libomp-dev libsndfile1-dev libsystemd-dev libxslt1-dev make pkgconfig`

Run build scripts from `scripts\linux\`. First `build-fluidsynth`, then `build`.

# Licenses

Overall, juicysfplugin is GPLv3.

See [licenses for all libraries and frameworks](https://github.com/Birch-san/juicysfplugin/tree/master/licenses_of_dependencies).
