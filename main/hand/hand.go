components {
  id: "player_hand"
  component: "/main/hand/hand.script"
}
embedded_components {
  id: "card_factory"
  type: "factory"
  data: "prototype: \"/main/card/card.go\"\n"
  ""
}
embedded_components {
  id: "score"
  type: "sprite"
  data: "default_animation: \"9\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/score.tilesource\"\n"
  "}\n"
  ""
  position {
    y: -100.0
    z: 10.0
  }
  scale {
    x: 0.5
    y: 0.5
  }
}
