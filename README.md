# Submarine Runner

This is my final project for my graphics class. You can play the game in the browser [here](https://yunusey.github.io/submarine-runner/).

https://github.com/user-attachments/assets/c121232b-420d-4349-8172-8ec4e783d3a5

## Building

The project provides a Nix flake that is based on [another flake](https://github.com/yunusey/CalculusVisualizations/blob/main/flake.nix) I made a few months prior to when I started working on this project. The flake currently supports a Linux and a WASM build.

If you have Nix installed on your machine, you can run the game using:

```bash
nix run github:yunusey/submarine-runner
```

To build for web, you can use:

```bash
nix build .#web -o .result
```

You need to specify `-o .result`, because the default output path, `result`, leads to Godot attempting to import the folder into the game.

## References

Inspirations and helpful resources that helped creation of this project.

- [Sebastian Lague - Coding Adventure: Marching Cubes](https://youtu.be/M3iI2l0ltbE?t=270)
- [Acerola - I Tried Simulating The Entire Ocean](https://www.youtube.com/watch?v=yPfagLeUa7k)
- [PAC-MAN](https://www.roblox.com/games/12646140566/PAC-MAN)
- [Blender Guru - How to Make a Mineshaft Ride in Blender](https://www.youtube.com/watch?v=gaYjZ8IBvds)
- [Freya Holmér - The Continuity of Splines](https://www.youtube.com/watch?v=jvPPXbo87ds)
- [Cadoink - Fake Water Caustics Shader in Godot](https://www.youtube.com/watch?v=mnpNePu0bv0)
- [StayAtHomeDev - How To Create a Water Depth Effect](https://www.youtube.com/watch?v=ib2atnKTLrs)
- [Poly Haven](https://polyhaven.com/) Textures licensed under CC0 (under `External/`; EXR images were converted to PNGs, because I had some issues with Godot failing to import them):
    - [Rusty Metal Grid Texture](https://polyhaven.com/a/rusty_metal_grid): Used in submarine's body.
    - [Blue Metal Plate Texture](https://polyhaven.com/a/blue_metal_plate): Used in submarine's radio and fan.
    - [Rock 04 Texture](https://polyhaven.com/a/rock_04): Used in obstacles.
    - [Marble Rock 02 Texture](https://polyhaven.com/a/marble_rock_02): Used in tunnel.
