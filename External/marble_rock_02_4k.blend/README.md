# Marble Rock 02 Texture

You can find this texture on [Poly Haven](https://polyhaven.com/a/marble_rock_02). The texture is licensed under CC0.

The source pack ships the normal and roughness maps as OpenEXR, which Godot's importer couldn't load:

```
ERROR: Failed loading resource: res://External/marble_rock_02_4k.blend/textures/marble_rock_02_nor_gl_4k.exr.
ERROR: editor/editor_node.cpp:1705 - Condition "res.is_null()" is true. Returning: ERR_CANT_OPEN
```

So, they were converted to 8-bit PNG. I also removed the Blender scene since I didn't need it.
