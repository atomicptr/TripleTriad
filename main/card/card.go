components {
  id: "card"
  component: "/main/card/card.script"
}
embedded_components {
  id: "front"
  type: "sprite"
  data: "default_animation: \"97\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 200.0\n"
  "  y: 200.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/cards.atlas\"\n"
  "}\n"
  ""
}
embedded_components {
  id: "rank_bottom"
  type: "sprite"
  data: "default_animation: \"2\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/rank.tilesource\"\n"
  "}\n"
  ""
  position {
    x: -48.0
    z: 0.1
  }
  scale {
    x: 0.5
    y: 0.5
    z: 0.5
  }
}
embedded_components {
  id: "rank_top"
  type: "sprite"
  data: "default_animation: \"A\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 128.0\n"
  "  y: 90.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/rank.tilesource\"\n"
  "}\n"
  ""
  position {
    x: -48.0
    y: 64.0
    z: 0.1
  }
  scale {
    x: 0.5
    y: 0.5
  }
}
embedded_components {
  id: "rank_left"
  type: "sprite"
  data: "default_animation: \"6\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 128.0\n"
  "  y: 90.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/rank.tilesource\"\n"
  "}\n"
  ""
  position {
    x: -64.0
    y: 32.0
    z: 0.1
  }
  scale {
    x: 0.5
    y: 0.5
    z: 0.5
  }
}
embedded_components {
  id: "rank_right"
  type: "sprite"
  data: "default_animation: \"8\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "size {\n"
  "  x: 128.0\n"
  "  y: 90.0\n"
  "}\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/rank.tilesource\"\n"
  "}\n"
  ""
  position {
    x: -32.0
    y: 32.0
    z: 0.1
  }
  scale {
    x: 0.5
    y: 0.5
    z: 0.5
  }
}
embedded_components {
  id: "element"
  type: "sprite"
  data: "default_animation: \"ice\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/element.tilesource\"\n"
  "}\n"
  ""
  position {
    x: 64.0
    y: 64.0
    z: 0.1
  }
  scale {
    x: 0.5
    y: 0.5
  }
}
embedded_components {
  id: "back"
  type: "sprite"
  data: "default_animation: \"card-back\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/cards.atlas\"\n"
  "}\n"
  ""
  position {
    z: -0.1
  }
}
