varying mediump vec2 var_texcoord0;

uniform lowp vec4 top_color;
uniform lowp vec4 bottom_color;

void main()
{
    lowp float t = 1.0 - var_texcoord0.y;
    gl_FragColor = mix(bottom_color, top_color, t);
}
