# Dino Rush

A lightweight Windows C++ game engine with **Lua (sol2)** bindings that powers a simple endless runner in the spirit of the Chrome “Dino” game. Rendering and audio are handled by a minimal Win32/GDI+ engine; all gameplay, assets, and content are driven from Lua.

## Features

- **Lua-first gameplay**: `initialize`, `start`, `update(dt)`, and `draw()` live in `lua/game.lua`.
- **Hot-loaded assets**: textures & sounds under `Resources/` (copied to the build output).
- **Tight engine bindings**: draw bitmaps & strings, poll keyboard, play sounds, simple shapes, colors.
- **Sprite animation**: frame-based animation controlled from Lua.
- **Simple obstacles & entities**: dino, cactus, and bird with spawn logic and difficulty ramp.

## Controls (default)

- **Z / W** – Jump  
- **S** – Crouch  
- **R** – Restart when you’re out  

## Run

Double-click `LuaEngine.exe` (in your chosen configuration folder).  
Window title and size are set from Lua in `initialize()` using `setWindowTitle` and `setWindowSize`.

## Gameplay overview (Lua)

- `lua/game.lua` maintains global state (score, spawn timers, difficulty).
- Entities (dino/obstacles) are created with image sheets and controlled via `AnimationController`.
- Spawning uses a randomized interval; speed ramps over time (e.g., cactus ~350 px/s, bird ~400 px/s in this build).
- Collision is AABB over sprite rects; toggle helpers are available in code (`SHOW_HITBOXES`, etc.).

## Lua API (bound from C++)

The binder (`src/MyClasses/LuaBinder.cpp`) exposes a minimal but useful API:

**Window & input**
- `setWindowTitle(title: string)`
- `setWindowSize(width: number, height: number)`
- `isKeyDown(key: string): boolean`  — use first character, e.g. `"Z"`, `"S"`, `"R"`

**Bitmaps & drawing**
- `createBitmap(path: string): Bitmap*`  — loads from `Resources/Textures/`
- `drawBitmap(bitmap, x, y)`
- `getBitmapWidth(bitmap): number`
- `getBitmapHeight(bitmap): number`
- `drawBitmapWithSource(bitmap, x, y, sourceRect: RECT)`
- `drawBitmapDestinationAndSource(bitmap, destRect: RECT, sourceRect: RECT)`
- `drawString(text: string, x: number, y: number)` *(available in binder; see annotations)*
- `setColor(r, g, b)`; `fillRect(l, t, r, b)`; `drawRect(l, t, r, b)`
- `fillWindowRect(r, g, b)`

**Audio**
- `Audio.new(filename: string)` — loads from `Resources/Sounds/`
- `audio:play()`, `audio:stop()`, `audio:tick()`
- `audio:setRepeat(boolean)`, `audio:setVolume(number)`, `audio:getVolume()`, `audio:isPlaying()`

**Helpers**
- `RECT.new()` — construct a rectangle (fields: `left, top, right, bottom`)

> See `lua/annotations.lua` for typed stubs you can use in editors for autocompletion.

## Engine architecture (high level)

- **`GameEngine`** wraps Win32 message handling, GDI+ initialization, backbuffer, timing, font/text, rectangle/sprite drawing, and simple audio (winmm).  
- **`LuaBinder`** opens Lua standard libs and binds engine types & functions with **sol2**; it calls into Lua’s:
  - `initialize()` once before the loop,
  - `start()` when the game begins,
  - `update(elapsedSec)` every frame,
  - `draw()` every frame after `update`.
- **Resources & scripts** are copied beside the executable by CMake post-build steps so Lua can `require` modules and load assets with simple relative paths.

## Credits

- **Engine**: based on coursework / Win32 engine by Kevin Hoefman (Howest), adapted for Lua scripting.  
- **Lua**: marovira/lua (5.4.4)  
- **Bindings**: ThePhD/sol2  
- **Art & SFX**: included under `Resources/` (see file names inside for attributions if any).

Happy running! 🦖
