components {
  id: "gameover"
  component: "/main/gameover/gameover.script"
}
embedded_components {
  id: "bg"
  type: "sprite"
  data: "default_animation: \"bg-result\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "textures {\n"
  "  sampler: \"texture_sampler\"\n"
  "  texture: \"/assets/misc.atlas\"\n"
  "}\n"
  ""
}
embedded_components {
  id: "restart"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 32.0\n"
  "}\n"
  "text: \"Press \\\"Select\\\" to continue\"\n"
  "font: \"/builtins/fonts/default.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  position {
    y: -314.0
    z: 0.5
  }
}
embedded_components {
  id: "score_player"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 32.0\n"
  "}\n"
  "text: \"0\"\n"
  "font: \"/builtins/fonts/default.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  position {
    x: 537.0
    y: 333.0
    z: 0.5
  }
}
embedded_components {
  id: "score_enemy"
  type: "label"
  data: "size {\n"
  "  x: 128.0\n"
  "  y: 32.0\n"
  "}\n"
  "text: \"0\"\n"
  "font: \"/builtins/fonts/default.font\"\n"
  "material: \"/builtins/fonts/label-df.material\"\n"
  ""
  position {
    x: -537.0
    y: 333.0
    z: 0.5
  }
}
