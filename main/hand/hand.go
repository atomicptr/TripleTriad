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
  id: "placeholder"
  type: "sprite"
  data: "default_animation: \"card-back\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/cards.atlas\"\n"
  "}\n"
  ""
}
