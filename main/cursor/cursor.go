components {
  id: "cursor"
  component: "/main/cursor/cursor.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"cursor\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/misc.atlas\"\n"
  "}\n"
  ""
  position {
    x: -100.0
    y: -25.0
  }
  scale {
    x: 0.5
    y: 0.5
  }
}
