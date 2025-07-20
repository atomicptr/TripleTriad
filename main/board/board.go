components {
  id: "board"
  component: "/main/board/board.script"
}
embedded_components {
  id: "background"
  type: "sprite"
  data: "default_animation: \"bg-board\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/misc.atlas\"\n"
  "}\n"
  ""
  position {
    z: -1.0
  }
}
embedded_components {
  id: "card_factory"
  type: "factory"
  data: "prototype: \"/main/card/card.go\"\n"
  ""
}
embedded_components {
  id: "element_factory"
  type: "factory"
  data: "prototype: \"/main/board/element.go\"\n"
  ""
}
