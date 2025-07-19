varying mediump vec2 var_texcoord0;

uniform mediump vec4 top_color;
uniform mediump vec4 bottom_color;

void main()
{
    mediump float y = var_texcoord0.y;
    gl_FragColor = mix(bottom_color, top_color, pow(smoothstep(0.5, 0.6, y), 0.8));
}
