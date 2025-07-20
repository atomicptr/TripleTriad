components {
  id: "element"
  component: "/main/board/element.script"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"thunder\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/element.tilesource\"\n"
  "}\n"
  ""
  scale {
    x: 0.5
    y: 0.5
  }
}
